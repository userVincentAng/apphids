import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int? maxLines;

  const HeaderText(
    this.text, {
    super.key,
    this.fontSize = 24,
    this.color,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.left,
    this.maxLines,
  });

  factory HeaderText.small(
    String text, {
    Key? key,
    Color? color,
    TextAlign textAlign = TextAlign.left,
    int? maxLines,
  }) {
    return HeaderText(
      text,
      key: key,
      fontSize: 18,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  factory HeaderText.large(
    String text, {
    Key? key,
    Color? color,
    TextAlign textAlign = TextAlign.left,
    int? maxLines,
  }) {
    return HeaderText(
      text,
      key: key,
      fontSize: 32,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).textTheme.titleLarge?.color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}
