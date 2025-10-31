import fs from "fs";
import path from "path";
import OpenAI from "openai"; // npm i openai

// ---- 1) 共通ヘッダー＆ルール読み込み ----
const root = process.cwd();
const rulesCandidates = [
  path.join(root, ".cursorrules"),
  path.join(root, ".cursor", "rules", "core.md"),
];
const rules = rulesCandidates
  .filter((p) => fs.existsSync(p))
  .map((p) => fs.readFileSync(p, "utf8"))
  .join("\n\n");

// ---- 2) 仕様・KPI・ADRの取り込み（長すぎる場合は先頭/該当節を抜粋）----
const spec = fs.readFileSync(path.join(root, "docs", "poc_spec_v2.md"), "utf8");
const kpi = fs.readFileSync(path.join(root, "docs", "kpi.md"), "utf8");
const adr = fs.readFileSync(path.join(root, "docs", "adr", "0001-architecture.md"), "utf8");

// 必要ならここで spec の § を抽出する簡単な関数を入れてもOK

// ---- 3) ユーザーのタスク指示（引数 or 標準入力）----
const userTask = process.argv.slice(2).join(" ").trim() || `
Task: Implement the ProfileSetup screen as per spec §3.
- Enforce photo-required gating and no-dating copy.
- Use tokens.gen.dart and follow Figma layout (±4dp).
Return changed files and a short summary.
`;

// ---- 4) OpenAI 呼び出し（Responses または Chat Completions）----
const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

// Responses API 例（推奨）
// docs: https://platform.openai.com/docs/api-reference/responses
(async () => {
  const prompt = [
    "### Project Rules\n", rules,
    "\n\n### Spec (poc_spec_v2.md)\n", spec.substring(0, 12000),
    "\n\n### KPI (kpi.md)\n", kpi.substring(0, 4000),
    "\n\n### ADR (0001-architecture.md)\n", adr.substring(0, 4000),
    "\n\n### User Task\n", userTask,
  ].join("");

  const res = await client.responses.create({
    model: "gpt-4.1-mini", // 手持ちのモデルに置換
    input: prompt,
    temperature: 0.2,
  });

  const text = res.output_text ?? JSON.stringify(res, null, 2);
  console.log(text);
})().catch((e) => {
  console.error(e);
  process.exit(1);
});