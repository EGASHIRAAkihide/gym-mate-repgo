# 💪 RepGo— 筋トレ仲間マッチングアプリ（PoC開発）

> 「一人では続かない」を解決する、健全で安全な筋トレマッチングプラットフォーム  
> Built with **Flutter + Supabase + Figma Design Tokens**

---

## 📘 概要

**GymMate** は、「筋トレを継続したいがモチベーションが続かない」人に向けた  
**“合トレ仲間マッチングアプリ”** のPoC（概念実証）プロジェクトです。

出会い目的を排除し、信頼できる仲間との安全なマッチングを提供します。  
顔写真必須・ジム名登録・通報機能を備えた安心設計です。

---

## 🚀 プロジェクト構成

```bash
gym-mate-poc/
├── apps/
│   └── mobile/               # Flutterアプリ本体
│       ├── lib/
│       │   ├── design/       # Style Dictionary経由で生成される tokens.gen.dart
│       │   ├── features/     # auth, profile, match, chat, report
│       │   └── shared/       # 共通widget, services
│       └── pubspec.yaml
├── design/
│   ├── tokens.json           # Figma Tokens出力
│   └── style-dictionary/     # config for tokens → Dart
├── docs/
│   ├── poc_spec_v2.md        # PoC設計書（主要仕様）
│   ├── adr/
│   │   └── 0001-architecture.md
│   └── kpi.md
└── .github/
├── ISSUE_TEMPLATE/
│   ├── feature_request.md
│   └── bug_report.md
└── PULL_REQUEST_TEMPLATE.md
```

---

## ⚙️ 技術スタック

| カテゴリ | 技術 |
|-----------|------|
| モバイル開発 | Flutter 3.x |
| バックエンド | Supabase (Auth, Postgres, Storage, Realtime) |
| デザイン | Figma + Design Tokens + Style Dictionary |
| 分析 | Firebase Analytics / Crashlytics |
| 開発支援 | GitHub Actions / Codex AI / Notion Docs |

---

## 🧩 主要機能（MVP範囲）

| 機能 | 内容 |
|------|------|
| 写真必須のユーザー登録 | 信頼性と安全性を担保 |
| プロフィール設定 | トレーニング目的・レベル・ジム名 |
| 条件マッチング | 地域・目的・時間帯による絞り込み |
| チャット機能 | 1:1リアルタイム通信（Supabase Realtime） |
| 通報・ブロック | 不適切利用を防止 |
| 通知機能 | マッチ成立・メッセージ通知 |
| 管理機能 | 管理者用ダッシュボード（通報確認など） |

---

## 🧱 開発手順

### 1️⃣ 初期セットアップ

```bash
# クローン
git clone https://github.com/<YOUR_NAME>/gym-mate-poc.git
cd gym-mate-poc

# Flutter & Supabase セットアップ
flutter pub get
supabase init
```

### 2️⃣ Design Tokens 生成

```bash
cd design/style-dictionary
npx style-dictionary build

→ apps/mobile/lib/design/tokens.gen.dart に自動生成。
```

### 3️⃣ 実行

```bash
cd apps/mobile
flutter run
```

⸻

## 📊 KPI管理
	•	指標一覧: docs/kpi.md￼
	•	分析: Firebase Analytics + Supabase集計 + Metabase予定
	•	Go/No-Go判断: 登録率・再利用率・通報率・満足度を複合評価

⸻

##🤝 コントリビューション

### Issue & PRルール
	•	新機能：.github/ISSUE_TEMPLATE/feature_request.md
	•	不具合：.github/ISSUE_TEMPLATE/bug_report.md
	•	すべてのPRに対して以下を確認:
	•	Figmaデザインに一致
	•	PoC仕様（docs/poc_spec_v2.md）と整合
	•	写真必須ロジックが機能
	•	“出会い目的禁止”の文言を確認済み

⸻

## 📁 ドキュメント一覧

| ファイル | 内容 |
|------|------|
| docs/poc_spec_v2.md | 信頼性と安全性を担保 |
| docs/adr/0001-architecture.md | トレーニング目的・レベル・ジム名 |
| docs/kpi.md | 地域・目的・時間帯による絞り込み |
| .github/PULL_REQUEST_TEMPLATE.md | 1:1リアルタイム通信（Supabase Realtime） |
| design/tokens.json | 不適切利用を防止 |

⸻

## 🔒 安全設計の方針
	•	出会い・恋愛目的は禁止（利用規約明記）
	•	写真登録は本人確認を目的とし、第三者閲覧不可（署名付きURL）
	•	通報・ブロック・モデレーション機能をPoC段階から導入
	•	全データ通信はHTTPS / JWTベース認証

⸻

## 🧠 開発フェーズ目標（PoC）

フェーズ	内容	期間
Week 1〜2	Figma設計 / Flutter Scaffold構築	✅
Week 3〜4	MVP完成（登録〜チャット）	
Week 5〜6	クローズドテスト（10〜30人）	
Week 7	KPI分析・Go判断	

| フェーズ | 内容 | 期間 |
|------|------|
| Week 1〜2 | Figma設計 / Flutter Scaffold構築 | ✅ |
| Week 3〜4 | MVP完成（登録〜チャット） | |
| Week 5〜6 | クローズドテスト（10〜30人）	 | |
| Week 7 | KPI分析・Go判断 | |

⸻

## 🪜 将来の展望
	•	ジム連携API（店舗別マッチング）
	•	トレーナー/インフルエンサー登録制度
	•	モチベーションSNS（投稿＋称賛機能）
	•	マネタイズ：プレミアムマッチ／ジム提携広告

⸻

## 🧑‍💻 ライセンス

MIT License

© 2025 江頭知創研究所
