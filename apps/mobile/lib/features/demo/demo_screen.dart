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
          Text('Brand / Colors', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              _Swatch(color: Color(Tokens.color_brand_primary), label: 'brand/primary'),
              const SizedBox(width: 12),
              _Swatch(color: Color(Tokens.color_brand_secondary), label: 'brand/secondary'),
              const SizedBox(width: 12),
              _Swatch(color: Color(Tokens.color_semantic_success), label: 'semantic/success'),
            ],
          ),
          const SizedBox(height: 24),

          Text('Spacing', style: Theme.of(context).textTheme.headlineMedium),
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

          Text('Policy', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: EdgeInsets.all(Tokens.space_4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('安全に関する重要なお知らせ', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('RepGoは「筋トレ仲間」探しのアプリです。出会い・恋愛目的での利用は禁止です。'),
                  const SizedBox(height: 4),
                  const Text('登録には本人確認のための顔写真が必須です。安心・安全にご利用ください。'),
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

          Text('Buttons', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Primary')),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
              const SizedBox(width: 12),
              TextButton(onPressed: () {}, child: const Text('Text')),
            ],
          ),
          const SizedBox(height: 48),

          Center(
            child: Icon(Icons.fitness_center, size: 48, color: p),
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  final String label;
  const _Swatch({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(Tokens.radius_m))),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  final double w;
  final String label;
  const _Box({required this.w, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(width: w, height: 12, color: Color(Tokens.color_semantic_info)),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}