# ADR 0001: 技術アーキテクチャ選定理由

## 状況
2025-10-31時点、GymMate（筋トレ仲間マッチングアプリ）のPoC開発を開始。

本PoCの目的は、「健全で安全な筋トレ仲間マッチング」を通じて、  
ユーザー継続率・利用意向を検証することにある。

## 決定事項
アプリ開発の技術スタックは以下とする。

### 🧩 フロントエンド
**Flutter 3.x**
- **理由:**  
  - クロスプラットフォームでの高速開発が可能（iOS/Android同時展開）  
  - UI再現性が高く、Figmaからのトークン同期（Design Tokens → Dart）と相性が良い  
  - SupabaseやFirebaseなどとの統合ライブラリが豊富

### ⚙️ バックエンド
**Supabase**
- **理由:**  
  - Firebaseと同等の認証・DB・Storage機能を持ち、PostgreSQLベースでRLSが利用可能  
  - 写真アップロード・チャット・通報などに適したセキュリティ制御が可能  
  - Flutter SDKが公式対応しており、開発コストが低い

### 💬 チャット・リアルタイム通信
**Supabase Realtime**
- PostgreSQLの変更を自動反映し、マッチング・チャットのリアルタイム更新に使用。

### ☁️ ストレージ
**Supabase Storage**
- 顔写真・プロフィール画像保存用。  
- RLSポリシーにより本人のみ書込可能、署名付きURLにより安全に参照。

### 📊 分析・ロギング
**Firebase Analytics / Crashlytics**
- 利用イベント（登録、マッチ、通報）をトラッキングし、PoCのKPI分析に使用。

### 🧠 開発支援
**Codex（AIペアプログラミング）**
- Flutter構築・Supabaseクエリ生成・RLSポリシー設計を自動化。  
- ADR・KPIなどのドキュメントを元に仕様整合性を担保。

**Figma**
- Design TokensをJSON出力し、Style Dictionary経由でFlutterへ反映。  
- 画面デザインとコードベースを常に同期。

---

## 非採用技術の理由
| 技術 | 採用しなかった理由 |
|------|--------------------|
| React Native | Flutterよりもデザイン再現性が低い。PoC期間中はFlutterが有利。 |
| Firebase Auth単独 | RLS制御やPostgres連携ができず、柔軟性が不足。 |
| Custom Node.js API | SupabaseでPoC要件を満たせるため、工数過剰。 |

---

## 今後の検討事項
- 本番リリース時に**独自バックエンド（FastAPI or Node.js）**への移行を検討。  
- 大規模化に伴い、**Appwrite**または**Hasura + Postgres**への移行可能性を評価。

---

## ステータス
✅ 承認済み（PoC開発フェーズ）