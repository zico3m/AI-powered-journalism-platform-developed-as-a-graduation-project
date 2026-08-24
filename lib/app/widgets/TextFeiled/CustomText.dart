import 'dart:ui';

import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? color;
  final String? fontFamily;
 final TextStyle? style;
 final FontWeight? fontWeight;





  const CustomText({
    super.key,
    required this.text,
    this.textAlign,
    this.fontSize,
    this.color,
    this.fontFamily, this.style, this.fontWeight,
  });


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }
}
