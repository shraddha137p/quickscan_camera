import 'package:flutter/material.dart';
import 'package:quickscan_camera/app/core/widgets/extensions.dart';

import '../../../gen/fonts.gen.dart';

enum TextType {
  extraBold,
  bold,
  semiBold,
  medium,
  regular,
  light,
}

class CommonText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;

  final int? maxLines;
  final bool isItalic;
  final bool isUnderLine;
  final VoidCallback? onTap;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final TextType? type;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  const CommonText.extraBold(
      this.text, {
        this.size = 12,
        this.color,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.isItalic = false,
        this.letterSpacing,
        this.onTap,
        this.type = TextType.extraBold,
        this.isUnderLine = false,
        this.fontWeight,
        super.key,
      });

  const CommonText.bold(
      this.text, {
        this.size = 12,
        this.color,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.isItalic = false,
        this.letterSpacing,
        this.onTap,
        this.type = TextType.bold,
        this.isUnderLine = false,
        this.fontWeight,
        super.key,
      });

  const CommonText.semiBold(
      this.text, {
        this.size = 12,
        this.color,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.isItalic = false,
        this.letterSpacing,
        this.onTap,
        this.type = TextType.semiBold,
        this.isUnderLine = false,
        this.fontWeight,
        super.key,
      });

  const CommonText.medium(
      this.text, {
        this.size = 12,
        this.color,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.isItalic = false,
        this.letterSpacing,
        this.onTap,
        this.type = TextType.medium,
        this.isUnderLine = false,
        this.fontWeight,
        super.key,
      });

  const CommonText.regular(
      this.text, {
        this.size = 12,
        this.color,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.isItalic = false,
        this.letterSpacing,
        this.onTap,
        this.type = TextType.regular,
        this.isUnderLine = false,
        this.fontWeight,
        super.key,
      });

  const CommonText.light(
      this.text, {
        this.size = 12,
        this.color,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.isItalic = false,
        this.letterSpacing,
        this.onTap,
        this.type = TextType.light,
        this.isUnderLine = false,
        this.fontWeight,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    TextStyle defStyle = TextStyle(
      fontSize: size,
      decorationThickness: 2,
      letterSpacing: letterSpacing,
      fontFamily: FontFamily.notoSansJP,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? context.colorScheme.onSurface,
      fontStyle: isItalic ? FontStyle.italic : null,
      decorationColor: context.colorScheme.onSurface,

      decoration: isUnderLine ? TextDecoration.underline : null,
    );
    TextStyle mStyle;

    switch (type) {
      case TextType.extraBold:
        mStyle = TextStyle(
          fontSize: size,
          decorationThickness: 2,
          letterSpacing: letterSpacing,
          fontFamily: FontFamily.notoSansJP,
          fontWeight: fontWeight ?? FontWeight.w800,
          color: color ?? context.colorScheme.onSurface,
          fontStyle: isItalic ? FontStyle.italic : null,
          decorationColor: context.colorScheme.onSurface,
          decoration: isUnderLine ? TextDecoration.underline : null,
        );
      case TextType.bold:
        mStyle = TextStyle(
          fontSize: size,
          decorationThickness: 1,
          letterSpacing: letterSpacing,
          fontFamily: FontFamily.notoSansJP,
          fontWeight: fontWeight ?? FontWeight.w700,
          color: color ?? context.colorScheme.onSurface,
          fontStyle: isItalic ? FontStyle.italic : null,
          decorationColor: context.colorScheme.tertiary,
          decoration: isUnderLine ? TextDecoration.underline : null,
        );
      case TextType.semiBold:
        mStyle = TextStyle(
          fontSize: size,
          decorationThickness: 1,
          letterSpacing: letterSpacing,
          fontFamily: FontFamily.notoSansJP,
          fontWeight: fontWeight ?? FontWeight.w600,
          color: color ?? context.colorScheme.onSurface,
          fontStyle: isItalic ? FontStyle.italic : null,
          decorationColor: context.colorScheme.tertiary,
          decoration: isUnderLine ? TextDecoration.underline : null,
        );
      case TextType.medium:
        mStyle = TextStyle(
          fontSize: size,
          decorationThickness: 1,
          letterSpacing: letterSpacing,
          fontFamily: FontFamily.notoSansJP,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: color ?? context.colorScheme.onSurface,
          fontStyle: isItalic ? FontStyle.italic : null,
          decorationColor: context.colorScheme.tertiary,
          decoration: isUnderLine ? TextDecoration.underline : null,
        );
      case TextType.regular:
        mStyle = TextStyle(
          fontSize: size,
          decorationThickness: 1,
          letterSpacing: letterSpacing,
          fontFamily: FontFamily.notoSansJP,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color ?? context.colorScheme.onSurface,
          fontStyle: isItalic ? FontStyle.italic : null,
          decorationColor: context.colorScheme.tertiary,
          decoration: isUnderLine ? TextDecoration.underline : null,
        );
      case TextType.light:
        mStyle = TextStyle(
          fontSize: size,
          decorationThickness: 1,
          letterSpacing: letterSpacing,
          fontFamily: FontFamily.notoSansJP,
          fontStyle: isItalic ? FontStyle.italic : null,
          color: color ?? context.colorScheme.onSurface,
          fontWeight: fontWeight ?? FontWeight.w300,
          decorationColor: context.colorScheme.tertiary,
          decoration: isUnderLine ? TextDecoration.underline : null,
        );
      default:
        mStyle = defStyle;
    }

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: mStyle,
      )
    );
  }
}
