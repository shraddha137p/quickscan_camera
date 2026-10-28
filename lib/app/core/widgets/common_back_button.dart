import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:quickscan_camera/app/core/widgets/extensions.dart';

class CommonBackButton extends StatelessWidget {
  const CommonBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap ?? Get.back,
        child: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.surface,
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          child: Icon(
            Icons.arrow_back,
            size: 22.sp,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
