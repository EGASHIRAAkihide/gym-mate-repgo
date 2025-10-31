# 🧩 Pull Request Template

## 🎯 目的
<!-- このPRの目的を簡潔に説明してください -->
例：
- プロフィール画面のUI改善
- 写真必須バリデーションの追加
- Supabaseチャット機能の接続修正

---

## 🧱 変更内容
<!-- 主な変更点を箇条書きで -->
- [ ] 新機能 / 修正の概要
- [ ] デザイン一致（Figma）
- [ ] KPI計測イベント追加
- [ ] 安全性ポリシー遵守（出会い禁止・写真必須）

---

## 📷 スクリーンショット / 動作確認
| 機能 | 状況 | 備考 |
|------|------|------|
| 登録 | ✅ 動作確認済み | |
| マッチ | ✅ 動作確認済み | |
| チャット | ⬜ 未確認 | |

---

## 🧪 テスト項目
- [ ] Flutterビルド成功 (`flutter analyze` / `flutter test`)
- [ ] Supabase Auth, DB, Storage動作確認済み
- [ ] Design Tokens (`tokens.gen.dart`) 正常反映
- [ ] Firebase Analyticsイベント発火確認

---

## 🧩 関連Issue
<!-- 関連するIssue番号を記述 -->
Closes #123

---

## 📎 参照ドキュメント
- [docs/poc_spec_v2.md](../docs/poc_spec_v2.md)
- [docs/kpi.md](../docs/kpi.md)
- [docs/adr/0001-architecture.md](../docs/adr/0001-architecture.md)

---

## ✅ チェックリスト
- [ ] Figmaデザインと一致している  
- [ ] `docs/poc_spec_v2.md` に記載の仕様と整合している  
- [ ] “出会い目的禁止”の文言が画面内で確認できる  
- [ ] 写真未登録時に登録できない  
- [ ] テスト・ビルド成功  
- [ ] KPI影響を確認済み  

---

## 🧠 備考
<!-- レビューアへの補足や懸念点があれば記載 -->