import fs from "fs";
import path from "path";

type AnyObj = Record<string, any>;

const ROOT = process.cwd();
const PLAIN = path.join(ROOT, "design", "tokens.json");
const COMPILED = path.join(ROOT, "design", "build", "tokens.compiled.json");
const OUTPUT_DIR = path.join(ROOT, "apps", "mobile", "lib", "design");
const OUTPUT_FILE = path.join(OUTPUT_DIR, "tokens.gen.dart");

function ensureDirs() {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
}

function readJsonFlexible(): AnyObj {
  // 優先: compiled → fallback: plain
  if (fs.existsSync(COMPILED)) {
    return JSON.parse(fs.readFileSync(COMPILED, "utf8"));
  }
  if (fs.existsSync(PLAIN)) {
    return JSON.parse(fs.readFileSync(PLAIN, "utf8"));
  }
  throw new Error(
    `tokens not found: ${COMPILED} or ${PLAIN}\n先に "pnpm run tokens:build" 実行、または design/tokens.json を用意してください。`
  );
}

// --------- ノード値取得ユーティリティ（value / $value 両対応） ----------
function nodeValue(node: any): any {
  if (node == null) return undefined;
  if (typeof node === "object" && "value" in node) return node.value;
  if (typeof node === "object" && "$value" in node) return node.$value;
  return undefined;
}

function hasValueField(node: any): boolean {
  if (node == null || typeof node !== "object") return false;
  return "value" in node || "$value" in node;
}

// パスで辿る（例: "color.neutral.50.value" or "$value"）
function getByPathFlexible(obj: AnyObj, pathStr: string): any {
  const segs = pathStr.split(".").map((s) => s.trim());
  let cur: any = obj;
  for (const seg of segs) {
    if (cur == null) return undefined;
    cur = cur[seg];
  }
  return cur;
}

function resolveAliasHex(tokens: AnyObj, raw: string, depth = 0): string | undefined {
  // raw: "{color.neutral.50.value}"
  if (!raw?.startsWith("{") || !raw.endsWith("}")) return undefined;
  if (depth > 8) return undefined; // 安全弁
  const m = raw.match(/^\{(.+)\}$/);
  if (!m) return undefined;
  const target = getByPathFlexible(tokens, m[1]);
  if (target == null) return undefined;

  // target がオブジェクトなら value/$value を見に行く
  let val = target;
  const nv = nodeValue(target);
  if (nv !== undefined) val = nv;

  if (typeof val === "string") {
    if (val.startsWith("#")) return val;
    if (val.startsWith("{")) return resolveAliasHex(tokens, val, depth + 1);
  }
  return undefined;
}

function hexToDartInt(hex: string): string {
  const v = hex.replace("#", "").toUpperCase();
  const argb = v.length === 6 ? `FF${v}` : v; // 6桁なら不透明付与
  return `0x${argb}`;
}

// ----------------- セクション別出力 -----------------

// color.* → int（#RRGGBB or alias）。その他は String 保存
function genColorSection(tokens: AnyObj) {
  const colorRoot = tokens.color || {};
  const lines: string[] = [];

  function walk(obj: AnyObj, segs: string[] = ["color"]) {
    Object.entries(obj).forEach(([k, v]) => {
      if (hasValueField(v)) {
        const name = [...segs, k].join("_"); // e.g. color_brand_primary
        const raw = String(nodeValue(v));
        let hex = raw;

        if (raw.startsWith("{")) {
          const resolved = resolveAliasHex(tokens, raw);
          if (resolved) hex = resolved;
        }
        if (hex.startsWith("#")) {
          lines.push(`  static const int ${name} = ${hexToDartInt(hex)};`);
        } else {
          lines.push(`  static const String ${name} = ${JSON.stringify(raw)}; // non-hex`);
        }
      } else if (v && typeof v === "object") {
        walk(v as AnyObj, [...segs, k]);
      }
    });
  }
  walk(colorRoot);
  return lines.join("\n");
}

// space.*, radius.* → double（数値以外は String）
function genNumberTree(tokens: AnyObj, rootKey: string) {
  const root = tokens[rootKey] || {};
  const lines: string[] = [];
  function walk(obj: AnyObj, segs: string[] = [rootKey]) {
    Object.entries(obj).forEach(([k, v]) => {
      if (hasValueField(v)) {
        const name = [...segs, k].join("_").replace(/\./g, "_");
        const raw = String(nodeValue(v));
        if (/^\d+(\.\d+)?$/.test(raw)) {
          lines.push(`  static const double ${name} = ${raw};`);
        } else {
          lines.push(`  static const String ${name} = ${JSON.stringify(raw)}; // non-number`);
        }
      } else if (v && typeof v === "object") {
        walk(v as AnyObj, [...segs, k]);
      }
    });
  }
  walk(root);
  return lines.join("\n");
}

// typography → 個別フィールド（fontSize/lineHeight/fontWeight/fontFamily）
function genTypographySection(tokens: AnyObj) {
  const typo = tokens.typography || {};
  const lines: string[] = [];

  const ffSans = nodeValue(typo?.fontFamily?.sans);
  if (typeof ffSans === "string") {
    lines.push(`  static const String fontFamilySans = ${JSON.stringify(ffSans)};`);
  }

  ["heading", "body", "caption"].forEach((group) => {
    const g = (typo as AnyObj)[group];
    if (!g || typeof g !== "object") return;

    Object.entries(g).forEach(([k, v]) => {
      const node = v as AnyObj;
      const base = `typography_${group}_${k}`;
      const fs = Number(nodeValue(node?.fontSize));
      const lh = Number(nodeValue(node?.lineHeight));
      const fw = Number(nodeValue(node?.fontWeight));
      const ff = nodeValue(node?.fontFamily);

      if (!Number.isNaN(fs)) lines.push(`  static const double ${base}_fontSize = ${fs};`);
      if (!Number.isNaN(lh)) lines.push(`  static const double ${base}_lineHeight = ${lh};`);
      if (!Number.isNaN(fw)) lines.push(`  static const int ${base}_fontWeight = ${fw};`);
      if (typeof ff === "string") lines.push(`  static const String ${base}_fontFamily = ${JSON.stringify(ff)};`);
    });
  });
  return lines.join("\n");
}

// elevation.* → List<Map<String,Object>>
function genElevationSection(tokens: AnyObj) {
  const elev = tokens.elevation || {};
  const lines: string[] = [];
  Object.entries(elev).forEach(([level, defRaw]) => {
    const def = defRaw as AnyObj;
    let arr: AnyObj[] = [];

    const maybe = nodeValue(def);
    if (Array.isArray(maybe)) arr = maybe as AnyObj[];
    else if (maybe && typeof maybe === "object") arr = [maybe as AnyObj];
    else if (Array.isArray(defRaw)) arr = defRaw as AnyObj[];
    else if (defRaw && typeof defRaw === "object" && !hasValueField(defRaw)) arr = [defRaw as AnyObj];

    if (arr.length === 0) {
      lines.push(`  // elevation_${level}: no shadow data`);
      return;
    }

    const entries = arr.map((s) => {
      const color = s.color ?? "#00000024";
      const x = Number(s.x ?? 0);
      const y = Number(s.y ?? 0);
      const blur = Number(s.blur ?? 0);
      const spread = Number(s.spread ?? 0);
      const type = String(s.type ?? "dropShadow");
      return `{"color": ${JSON.stringify(color)}, "type": ${JSON.stringify(type)}, "x": ${x}, "y": ${y}, "blur": ${blur}, "spread": ${spread}}`;
    });
    lines.push(`  static const List<Map<String, Object>> elevation_${level} = const [${entries.join(", ")}];`);
  });
  return lines.join("\n");
}

function buildDart(tokens: AnyObj) {
  const out =
    [
      "// GENERATED FILE - DO NOT EDIT.",
      "// Generated from design/build/tokens.compiled.json or design/tokens.json",
      "class Tokens {",
      genColorSection(tokens),
      genNumberTree(tokens, "space"),
      genNumberTree(tokens, "radius"),
      genTypographySection(tokens),
      genElevationSection(tokens),
      "}",
    ].join("\n");

  // 必須キーの軽い検査（Flutter側で参照している代表名）
  const required = [
    "color_brand_primary",
    "color_brand_secondary",
    "color_text_primary",
    "color_semantic_error",
    "color_semantic_success",
    "space_4",
    "radius_xl",
    "typography_heading_2_fontSize",
    "typography_body_md_fontSize",
  ];
  for (const key of required) {
    if (!out.includes(key)) {
      // 中身が String でも問題ないので、" color_brand_primary "（スペース付）で厳密に探す必要はない
      throw new Error(`生成物に必須キーが見つかりません: ${key}\n tokens.json / SD の構造やスペルを確認してください。`);
    }
  }
  return out;
}

function tryBuildFrom(filePath: string) {
  const tokens = JSON.parse(fs.readFileSync(filePath, "utf8"));
  const dart = buildDart(tokens);
  fs.writeFileSync(OUTPUT_FILE, dart, "utf8");
  console.log(`✔ Wrote ${OUTPUT_FILE} (source: ${path.relative(process.cwd(), filePath)})`);
}

function listSomeColorKeys(filePath: string) {
  try {
    const tokens = JSON.parse(fs.readFileSync(filePath, "utf8"));
    const keys: string[] = [];
    function walk(obj: AnyObj, segs: string[] = []) {
      if (!obj || typeof obj !== "object") return;
      Object.entries(obj).forEach(([k, v]) => {
        const next = [...segs, k];
        if (hasValueField(v)) {
          keys.push(next.join("."));
        } else if (v && typeof v === "object") {
          walk(v as AnyObj, next);
        }
      });
    }
    if (tokens.color) walk(tokens.color, ["color"]);
    console.log(`🔎 color keys in ${path.basename(filePath)} (first 20):`);
    console.log(keys.slice(0, 20).map(k => `  - ${k}`).join("\n") || "  (none)");
  } catch (e) {
    console.log(`(skip listSomeColorKeys: ${e})`);
  }
}

function main() {
  ensureDirs();

  const prefer = fs.existsSync(COMPILED) ? COMPILED : (fs.existsSync(PLAIN) ? PLAIN : null);
  if (!prefer) {
    throw new Error(`tokens not found: ${COMPILED} or ${PLAIN}`);
  }

  try {
    // まず compiled を試す
    tryBuildFrom(prefer);
  } catch (e) {
    console.warn(`⚠ Failed with ${path.basename(prefer)}: ${(e as Error).message}`);
    // デバッグ: どんなキーがあるか出す
    listSomeColorKeys(prefer);

    // plain にフォールバック
    if (prefer !== PLAIN && fs.existsSync(PLAIN)) {
      console.log("↩ Falling back to design/tokens.json ...");
      tryBuildFrom(PLAIN);
      return;
    }
    throw e;
  }
}

main();