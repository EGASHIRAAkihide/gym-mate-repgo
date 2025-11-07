import 'package:flutter/material.dart';
import '../../design/tokens.gen.dart';

class DemoButtonScreen extends StatelessWidget {
  const DemoButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Tokens.color_background_surface),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(Tokens.color_brand_primary),
            foregroundColor: Color(Tokens.color_text_inverse),
            padding: EdgeInsets.symmetric(
              horizontal: Tokens.space_4.toDouble(),
              vertical: Tokens.space_3.toDouble(),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Tokens.radius_xl.toDouble(),
              ),
            ),
            elevation: 0,
          ),
          onPressed: () {},
          child: Text(
            'Primary Button',
            style: TextStyle(
              fontSize: Tokens.typography_body_md_fontSize.toDouble(),
              height: Tokens.typography_body_md_lineHeight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}