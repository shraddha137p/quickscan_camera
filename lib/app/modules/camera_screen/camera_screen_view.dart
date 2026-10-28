import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:get/get.dart';
import 'package:quickscan_camera/app/core/widgets/common_button.dart';
import 'package:quickscan_camera/app/core/widgets/common_text.dart';

import 'camera_screen_controller.dart';

class CameraScreenView extends GetView<CameraScreenController> {
  const CameraScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: CommonText.semiBold('QuickScan Camera', size: 18.sp),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(colors),

            SizedBox(height: 16.h),

            Expanded(child: _buildCameraPreview(colors)),

            SizedBox(height: 20.h),

            _buildCaptureControls(colors),

            SizedBox(height: 20.h),

            _buildActionButtons(colors),
          ],
        ).paddingSymmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colors) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText.semiBold(
            controller.isSessionStart.value
                ? 'Capturing Images'
                : 'Ready to Capture',
            size: 15.sp,
            color: colors.onSurface,
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: CommonText.medium(
              '${controller.imageCount} Photos',
              size: 12.sp,
              color: colors.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview(ColorScheme colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        color: colors.inverseSurface,
        child: Obx(() {
          if (controller.errorMessage.value.isNotEmpty) {
            return _buildCameraError(colors);
          }

          if (!controller.isInitialized.value) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          final camera = controller.cameraController;

          if (camera == null) {
            return const SizedBox.shrink();
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: ClipRect(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: camera.value.previewSize!.height,
                      height: camera.value.previewSize!.width,
                      child: CameraPreview(camera),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 16.h,
                left: 16.w,
                child: Obx(() => _buildStatusBadge(colors)),
              ),

              Positioned(
                bottom: 16.h,
                left: 16.w,
                right: 16.w,
                child: CommonText.regular(
                  'Position QR code, barcode or object in frame',
                  size: 12.sp,
                  color: colors.onInverseSurface,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatusBadge(ColorScheme colors) {
    final isActive = controller.isSessionStart.value;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colors.inverseSurface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 9.sp,
            color: isActive ? colors.tertiary : colors.onInverseSurface,
          ),

          SizedBox(width: 7.w),

          CommonText.medium(
            isActive ? 'Session Active' : 'Camera Ready',
            size: 11.sp,
            color: colors.onInverseSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraError(ColorScheme colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_photography_outlined,
            color: colors.onInverseSurface,
            size: 42.sp,
          ),

          SizedBox(height: 12.h),

          CommonText.medium(
            controller.errorMessage.value,
            size: 13.sp,
            color: colors.onInverseSurface,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20.h),

          CommonButton(
            text: controller.isPermissionPermanentlyDenied.value
                ? 'Open Settings'
                : 'Retry Camera',
            height: 46,
            onPressed: controller.retryCamera,
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureControls(ColorScheme colors) {
    return Obx(() {
      final canCapture =
          controller.isInitialized.value &&
          controller.isSessionStart.value &&
          !controller.isCapture.value;

      return Column(
        children: [
          GestureDetector(
            onTap: canCapture ? controller.captureImage : null,
            child: AnimatedOpacity(
              opacity: canCapture ? 1 : 0.4,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: 76.w,
                height: 76.w,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primary, width: 3),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: colors.onPrimary,
                    size: 30.sp,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          CommonText.regular(
            'Tap to capture',
            size: 12.sp,
            color: colors.onSurfaceVariant,
          ),
        ],
      );
    });
  }

  Widget _buildActionButtons(ColorScheme colors) {
    return Obx(() {
      final canStart =
          controller.isInitialized.value && !controller.isSessionStart.value;

      final canStop =
          controller.isSessionStart.value && !controller.isCapture.value;

      return Row(
        children: [
          Expanded(
            child: CommonButton(
              text: 'Start',
              height: 52,
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              onPressed: canStart ? controller.startSession : null,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: CommonButton(
              text: 'Stop',
              height: 52,
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
              onPressed: canStop ? controller.stopSession : null,
            ),
          ),
        ],
      );
    });
  }
}
