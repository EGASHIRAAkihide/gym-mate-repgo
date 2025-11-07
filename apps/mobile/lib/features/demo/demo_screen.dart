import 'package:flutter/material.dart';
import '../../design/tokens.gen.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('RepGo Tokens Demo')),
      body: ListView(
        padding: EdgeInsets.all(Tokens.space_4),
        children: [
          // =========================
          // Colors
          // =========================
          Text('Brand / Colors',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              _Swatch(
                  color: Color(Tokens.color_brand_primary),
                  label: 'brand/primary'),
              const SizedBox(width: 12),
              _Swatch(
                  color: Color(Tokens.color_brand_secondary),
                  label: 'brand/secondary'),
              const SizedBox(width: 12),
              _Swatch(
                  color: Color(Tokens.color_semantic_success),
                  label: 'semantic/success'),
            ],
          ),
          const SizedBox(height: 24),

          // =========================
          // Spacing
          // =========================
          Text('Spacing',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _Box(w: Tokens.space_2, label: 'space/2'),
              _Box(w: Tokens.space_4, label: 'space/4'),
              _Box(w: Tokens.space_6, label: 'space/6'),
              _Box(w: Tokens.space_10, label: 'space/10'),
            ],
          ),
          const SizedBox(height: 24),

          // =========================
          // Policy (出会い禁止 + 写真必須)
          // =========================
          Text('Policy',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: EdgeInsets.all(Tokens.space_4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('安全に関する重要なお知らせ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text(
                      'RepGoは「筋トレ仲間」探しのアプリです。出会い・恋愛目的での利用は禁止です。'),
                  const SizedBox(height: 4),
                  const Text(
                      '登録には本人確認のための顔写真が必須です。安心・安全にご利用ください。'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // =========================
          // Buttons (Token-based)
          // =========================
          Text('Buttons (Tokens)',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _TokenButton.primary(label: 'Primary'),
              _TokenButton.secondary(label: 'Secondary'),
              _TokenButton.ghost(label: 'Ghost'),
              _TokenButton.disabled(label: 'Disabled'),
            ],
          ),
          const SizedBox(height: 24),

          // =========================
          // Inputs (Token-based)
          // =========================
          Text('Inputs (Tokens)',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const _InputDemoGroup(),
          const SizedBox(height: 24),

          // =========================
          // Avatars (Token-based)
          // =========================
          Text('Avatars (Tokens)',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          // サイズバリエーション
          Row(
            children: [
              _Avatar(
                size: Tokens.space_8, // 32
                backgroundColor: Color(Tokens.color_neutral_200),
                label: 'K',
                type: _AvatarType.initial,
                status: _AvatarStatus.none,
              ),
              const SizedBox(width: 12),
              _Avatar(
                size: Tokens.space_12, // 48
                backgroundColor: Color(Tokens.color_brand_primary),
                label: 'M',
                type: _AvatarType.initial,
                status: _AvatarStatus.online,
              ),
              const SizedBox(width: 12),
              _Avatar(
                size: Tokens.space_16, // 64
                backgroundColor: Color(Tokens.color_neutral_200),
                label: '',
                type: _AvatarType.placeholder,
                status: _AvatarStatus.offline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // タイプバリエーション
          Row(
            children: [
              _Avatar(
                size: Tokens.space_12,
                backgroundColor: Color(Tokens.color_neutral_200),
                label: 'A',
                type: _AvatarType.initial,
                status: _AvatarStatus.none,
              ),
              const SizedBox(width: 12),
              _Avatar(
                size: Tokens.space_12,
                backgroundColor: Color(Tokens.color_neutral_400),
                label: '',
                type: _AvatarType.placeholder,
                status: _AvatarStatus.online,
              ),
              const SizedBox(width: 12),
              _Avatar(
                size: Tokens.space_12,
                backgroundColor: Color(Tokens.color_neutral_300),
                label: '',
                type: _AvatarType.imageMock,
                status: _AvatarStatus.none,
              ),
            ],
          ),
          const SizedBox(height: 48),

          // =========================
          // Cards (Token-based)
          // =========================
          Text('Cards (Tokens)',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const _CardDemoGroup(),
          const SizedBox(height: 24),

          // =========================
          // Icon sample
          // =========================
          Center(
            child: Icon(Icons.fitness_center, size: 48, color: p),
          ),
        ],
      ),
    );
  }
}

/// カラースウォッチ表示
class _Swatch extends StatelessWidget {
  final Color color;
  final String label;
  const _Swatch({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(Tokens.radius_m),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

/// spacing のバー表示
class _Box extends StatelessWidget {
  final double w;
  final String label;
  const _Box({required this.w, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: w,
            height: 12,
            color: Color(Tokens.color_semantic_info)),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

/// Token ベース Button デモ
class _TokenButton extends StatelessWidget {
  final String label;
  final _TokenButtonVariant variant;
  final bool disabled;

  const _TokenButton._({
    required this.label,
    required this.variant,
    required this.disabled,
  });

  const _TokenButton.primary({required String label})
      : this._(
          label: label,
          variant: _TokenButtonVariant.primary,
          disabled: false,
        );

  const _TokenButton.secondary({required String label})
      : this._(
          label: label,
          variant: _TokenButtonVariant.secondary,
          disabled: false,
        );

  const _TokenButton.ghost({required String label})
      : this._(
          label: label,
          variant: _TokenButtonVariant.ghost,
          disabled: false,
        );

  const _TokenButton.disabled({required String label})
      : this._(
          label: label,
          variant: _TokenButtonVariant.primary,
          disabled: true,
        );

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late Color border;
    switch (variant) {
      case _TokenButtonVariant.primary:
        bg = Color(Tokens.color_brand_primary);
        fg = Color(Tokens.color_text_inverse);
        border = Colors.transparent;
        break;
      case _TokenButtonVariant.secondary:
        bg = Color(Tokens.color_brand_secondary);
        fg = Color(Tokens.color_text_inverse);
        border = Colors.transparent;
        break;
      case _TokenButtonVariant.ghost:
        bg = Colors.transparent;
        fg = Color(Tokens.color_text_primary);
        border = Color(Tokens.color_border_subtle);
        break;
    }

    if (disabled) {
      bg = Color(Tokens.color_neutral_200);
      fg = Color(Tokens.color_neutral_500);
    }

    final child = Text(
      label,
      style: TextStyle(
        fontSize: Tokens.typography_body_md_fontSize,
        height: Tokens.typography_body_md_lineHeight,
        fontWeight: FontWeight.w600,
        color: fg,
      ),
    );

    return InkWell(
      onTap: disabled ? null : () {},
      borderRadius: BorderRadius.circular(Tokens.radius_xl),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Tokens.space_4,
          vertical: Tokens.space_3,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Tokens.radius_xl),
          border: Border.all(color: border),
        ),
        child: child,
      ),
    );
  }
}

enum _TokenButtonVariant { primary, secondary, ghost }

/// Input デモ用グループ（Default / Error / Disabled）
class _InputDemoGroup extends StatefulWidget {
  const _InputDemoGroup();

  @override
  State<_InputDemoGroup> createState() => _InputDemoGroupState();
}

class _InputDemoGroupState extends State<_InputDemoGroup> {
  final _normalController = TextEditingController();
  final _errorController = TextEditingController();
  bool _normalHasError = false;

  @override
  void dispose() {
    _normalController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Tokens.radius_m),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = Color(Tokens.color_background_surface);
    final borderDefault = Color(Tokens.color_border_subtle);
    final borderFocus = Color(Tokens.color_brand_secondary);
    final borderError = Color(Tokens.color_semantic_error);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Default + validation
        Text('Default + validation',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        TextField(
          controller: _normalController,
          decoration: InputDecoration(
            filled: true,
            fillColor: bg,
            hintText: 'ニックネームを入力',
            hintStyle: TextStyle(
              color: Color(Tokens.color_text_secondary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Tokens.space_3,
              vertical: Tokens.space_2,
            ),
            enabledBorder: _border(borderDefault),
            focusedBorder: _border(_normalHasError ? borderError : borderFocus),
            errorBorder: _border(borderError),
            focusedErrorBorder: _border(borderError),
            errorText: _normalHasError ? '必須項目です' : null,
          ),
          onChanged: (v) {
            setState(() {
              _normalHasError = v.trim().isEmpty;
            });
          },
        ),
        const SizedBox(height: 16),

        // Error 固定
        Text('Error (static)',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        TextField(
          controller: _errorController,
          decoration: InputDecoration(
            filled: true,
            fillColor: bg,
            hintText: 'フォームにエラーがある例',
            hintStyle: TextStyle(
              color: Color(Tokens.color_text_secondary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Tokens.space_3,
              vertical: Tokens.space_2,
            ),
            enabledBorder: _border(borderError),
            focusedBorder: _border(borderError),
            errorText: '形式が正しくありません',
          ),
        ),
        const SizedBox(height: 16),

        // Disabled
        Text('Disabled',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        TextField(
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(Tokens.color_neutral_100),
            hintText: '編集できない状態',
            hintStyle: TextStyle(
              color: Color(Tokens.color_text_secondary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Tokens.space_3,
              vertical: Tokens.space_2,
            ),
            disabledBorder: _border(borderDefault),
          ),
        ),
      ],
    );
  }
}

/// Avatar Type
enum _AvatarType { initial, placeholder, imageMock }

/// Avatar Status
enum _AvatarStatus { none, online, offline }

/// Avatar 表示用ウィジェット
class _Avatar extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final String label;
  final _AvatarType type;
  final _AvatarStatus status;

  const _Avatar({
    required this.size,
    required this.backgroundColor,
    required this.label,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Widget inner;
    switch (type) {
      case _AvatarType.initial:
        inner = Text(
          label.isNotEmpty ? label : '?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Color(Tokens.color_text_inverse),
                fontWeight: FontWeight.w600,
              ),
        );
        break;
      case _AvatarType.placeholder:
        inner = Icon(
          Icons.person_outline,
          color: Color(Tokens.color_text_secondary),
          size: size * 0.5,
        );
        break;
      case _AvatarType.imageMock:
        // 本物の画像の代わりにグラデ or 模擬表現
        inner = Icon(
          Icons.fitness_center,
          color: Color(Tokens.color_text_inverse),
          size: size * 0.5,
        );
        break;
    }

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Tokens.radius_full),
      ),
      child: Center(child: inner),
    );

    if (status == _AvatarStatus.none) {
      return avatar;
    }

    // Status dot
    final dotSize = 8.0;
    final dotColor = switch (status) {
      _AvatarStatus.online => Color(Tokens.color_semantic_success),
      _AvatarStatus.offline => Color(Tokens.color_neutral_400),
      _ => Colors.transparent,
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: BorderRadius.circular(dotSize),
              border: Border.all(
                color: Color(Tokens.color_background_surface),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardDemoGroup extends StatelessWidget {
  const _CardDemoGroup();

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Color(Tokens.color_text_primary),
        );
    final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Color(Tokens.color_text_secondary),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Card / Default', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Color(Tokens.color_background_surface),
            borderRadius: BorderRadius.circular(Tokens.radius_xl),
            border: Border.all(color: Color(Tokens.color_border_subtle)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Tokens.space_4,
            vertical: Tokens.space_3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('一緒にトレーニングしませんか？', style: titleStyle),
              const SizedBox(height: 4),
              Text(
                '同じジム・同じ時間帯で通っているユーザーとマッチできます。',
                style: bodyStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Text('Card / Emphasis (brand border)',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Color(Tokens.color_background_elevated),
            borderRadius: BorderRadius.circular(Tokens.radius_xl),
            border: Border.all(color: Color(Tokens.color_brand_secondary)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Tokens.space_4,
            vertical: Tokens.space_3,
          ),
          child: Row(
            children: [
              Icon(Icons.fitness_center,
                  size: 20, color: Color(Tokens.color_brand_secondary)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'あなたのレベルに近いユーザーが3人見つかりました。',
                  style: bodyStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}