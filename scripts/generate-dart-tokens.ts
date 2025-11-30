// scripts/generate-dart-tokens.ts
import fs from "fs";
import path from "path";

type AnyObj = Record<string, any>;

const ROOT = process.cwd();

// 優先: Style Dictionary が生成した compiled JSON
const COMPILED = path.join(ROOT, "design", "build", "tokens.compiled.json");
// フォールバック: 元の tokens.json
const FALLBACK = path.join(ROOT, "design", "tokens.json");

// Flutter プロジェクト側の出力先
const OUTPUT_DIR = path.join(ROOT, "apps", "mobile", "lib", "design");
const OUTPUT_FILE = path.join(OUTPUT_DIR, "tokens.gen.dart");

function ensureDirs() {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
}

function readJson(file: string): AnyObj {
  if (!fs.existsSync(file)) {
    throw new Error(`Missing JSON file: ${file}`);
  }
  return JSON.parse(fs.readFileSync(file, "utf8"));
}

function dartColor(hex: string) {
  // "#RRGGBB" or "#AARRGGBB" → 0xFFRRGGBB（不透明デフォルト）
  const v = hex.replace("#", "");
  const argb = v.length === 6 ? `FF${v.toUpperCase()}` : v.toUpperCase();
  return `0x${argb}`;
}

// 文字列に "" 付与（Dart literal）
const dq = (s: string) => JSON.stringify(s);

// v が { value: ... } or プリミティブ のどちらでもOKにする helper
function leafValue(v: any): any | undefined {
  if (v == null) return undefined;
  if (typeof v === "string" || typeof v === "number" || typeof v === "boolean") {
    return v;
  }
  if (typeof v === "object" && "value" in v) {
    return (v as AnyObj).value;
  }
  return undefined;
}

function toNumberOrNull(v: any): number | null {
  const raw = leafValue(v);
  if (raw == null) return null;
  const n = Number(raw);
  return Number.isNaN(n) ? null : n;
}

//
// Color セクション生成
//
function genColorSection(tokens: AnyObj) {
  const lines: string[] = [];
  const color = tokens.color || {};

  function walk(obj: AnyObj, pathSegs: string[] = []) {
    Object.entries(obj).forEach(([k, v]) => {
      const val = leafValue(v);
      if (val != null) {
        const name = [...pathSegs, k].join("_");
        const value = String(val);
        if (value.startsWith("#")) {
          lines.push(`  static const int ${name} = ${dartColor(value)};`);
        } else if (value.startsWith("{")) {
          // alias の場合はとりあえず文字列として保持
          lines.push(`  static const String ${name} = ${dq(value)};`);
        } else {
          lines.push(`  static const String ${name} = ${dq(value)};`);
        }
      } else if (v && typeof v === "object") {
        walk(v as AnyObj, [...pathSegs, k]);
      }
    });
  }

  walk(color, ["color"]);
  return lines.join("\n");
}

//
// Space / Radius など数値マップ
//
function genNumberMapSection(tokens: AnyObj, rootKey: string) {
  const root = tokens[rootKey];
  if (!root || typeof root !== "object") return "";

  const lines: string[] = [];

  function walk(obj: AnyObj, segs: string[] = []) {
    Object.entries(obj).forEach(([k, v]) => {
      const val = leafValue(v);
      if (val != null) {
        const name = [...segs, k].join("_").replace(/\./g, "_");
        const num = Number(val);
        if (!Number.isNaN(num)) {
          lines.push(`  static const double ${name} = ${num};`);
        } else {
          lines.push(`  static const String ${name} = ${dq(String(val))};`);
        }
      } else if (v && typeof v === "object") {
        walk(v as AnyObj, [...segs, k]);
      }
    });
  }

  walk(root as AnyObj, [rootKey]);
  return lines.join("\n");
}

//
// Typography セクション
//
function genTypographySection(tokens: AnyObj) {
  const typo = tokens.typography || {};
  const lines: string[] = [];

  // フォントファミリ
  let sansFamily: string | null = null;
  if (typo.fontFamily?.sans != null) {
    const val = leafValue(typo.fontFamily.sans);
    if (val != null) sansFamily = String(val);
  }
  if (sansFamily) {
    lines.push(`  static const String fontFamilySans = ${dq(sansFamily)};`);
  }

  // Heading / Body / Caption フラット展開
  const groups = ["heading", "body", "caption"];
  groups.forEach(group => {
    const g = (typo as AnyObj)[group];
    if (!g) return;

    Object.entries(g).forEach(([k, v]) => {
      const node = v as AnyObj;
      const base = `typography_${group}_${k}`;

      const fs = toNumberOrNull(node.fontSize);
      if (fs != null) {
        lines.push(`  static const double ${base}_fontSize = ${fs};`);
      }

      const lh = toNumberOrNull(node.lineHeight);
      if (lh != null) {
        lines.push(`  static const double ${base}_lineHeight = ${lh};`);
      }

      const fw = toNumberOrNull(node.fontWeight);
      if (fw != null) {
        lines.push(`  static const int ${base}_fontWeight = ${fw.toFixed(0)};`);
      }

      const ffVal = leafValue(node.fontFamily ?? typo.fontFamily?.sans);
      if (ffVal != null) {
        lines.push(`  static const String ${base}_fontFamily = ${dq(String(ffVal))};`);
      }
    });
  });

  return lines.join("\n");
}

//
// Elevation セクション
//
function genElevationSection(tokens: AnyObj) {
  const elev = tokens.elevation || {};
  const lines: string[] = [];

  Object.entries(elev).forEach(([level, def]) => {
    let arr: AnyObj[] | null = null;

    if (Array.isArray(def)) {
      arr = def as AnyObj[];
    } else if (def && typeof def === "object" && Array.isArray((def as AnyObj).value)) {
      arr = (def as AnyObj).value as AnyObj[];
    }

    if (!arr) return;

    const entries = arr.map(s => {
      const color = String(s.color ?? "#000000");
      const x = Number(s.x ?? 0);
      const y = Number(s.y ?? 0);
      const blur = Number(s.blur ?? 0);
      const spread = Number(s.spread ?? 0);
      return `{"color": ${dq(color)}, "x": ${x}, "y": ${y}, "blur": ${blur}, "spread": ${spread}}`;
    });

    lines.push(
      `  static const List<Map<String, Object>> elevation_${level} = [${entries.join(
        ", "
      )}];`
    );
  });

  return lines.join("\n");
}

//
// Dart 全体生成
//
function buildDart(tokens: AnyObj, sourceLabel: string) {
  const colorSec = genColorSection(tokens);
  const spaceSec = genNumberMapSection(tokens, "space");
  const radiusSec = genNumberMapSection(tokens, "radius");
  const typoSec = genTypographySection(tokens);
  const elevSec = genElevationSection(tokens);

  const header = `// GENERATED FILE - DO NOT EDIT.
// Generated from ${sourceLabel}
class Tokens {
`;
  const footer = `
}
`;

  return [
    header,
    colorSec ? `\n${colorSec}\n` : "",
    spaceSec ? `\n${spaceSec}\n` : "",
    radiusSec ? `\n${radiusSec}\n` : "",
    typoSec ? `\n${typoSec}\n` : "",
    elevSec ? `\n${elevSec}\n` : "",
    footer,
  ].join("");
}

function main() {
  ensureDirs();

  let tokens: AnyObj | null = null;
  let source = "";

  // 1. まず compiled を試す
  try {
    tokens = readJson(COMPILED);
    source = "design/build/tokens.compiled.json";
  } catch (e) {
    console.warn(
      `⚠ Could not read compiled tokens at ${COMPILED}. Falling back to design/tokens.json`
    );
  }

  // 2. ダメなら tokens.json にフォールバック
  if (!tokens) {
    tokens = readJson(FALLBACK);
    source = "design/tokens.json";
  }

  const dart = buildDart(tokens, source);
  fs.writeFileSync(OUTPUT_FILE, dart, "utf8");
  console.log(`✔ Wrote ${OUTPUT_FILE} (source: ${source})`);
}

main();