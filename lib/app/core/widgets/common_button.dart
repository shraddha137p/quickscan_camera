import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'common_text.dart';
import 'extensions.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 58,
    this.borderRadius = 30,
    this.fontSize = 13,
    this.letterSpacing = 0.5,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  final double height;
  final double borderRadius;
  final double fontSize;
  final double letterSpacing;

  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor =
        backgroundColor ?? context.colorScheme.primary;

    final Color textColor =
        foregroundColor ?? context.colorScheme.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          disabledBackgroundColor: buttonColor,
          disabledForegroundColor: textColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius.r,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: 22.w,
          height: 22.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: textColor,
          ),
        )
            : CommonText.semiBold(
          text,
          size: fontSize.sp,
          color: textColor,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}