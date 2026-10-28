
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';

import 'package:quickscan_camera/app/core/widgets/common_text.dart';

import 'results_screen_controller.dart';

class ResultsScreenView extends GetView<ResultsScreenController> {
  const ResultsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: CommonText.semiBold('Scan Results', size: 18.sp),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colors.primary),
                  SizedBox(height: 16.h),
                  CommonText.medium(
                    'Processing captured images...',
                    size: 14.sp,
                  ),
                ],
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: CommonText.medium(
                controller.errorMessage.value,
                size: 14.sp,
                color: colors.error,
                textAlign: TextAlign.center,
              ),
            );
          }

          if (controller.results.isEmpty) {
            return Center(
              child: CommonText.medium(
                'No results found.',
                size: 14.sp,
              ),
            );
          }

          return Column(
            children: [
              _buildSummary(colors),

              if (controller.isLoading.value)
                LinearProgressIndicator(color: colors.primary),

              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.results.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final result = controller.results[index];

                    return _buildResultCard(
                      context,
                      colors,
                      result,
                      index,
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSummary(ColorScheme colors) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 16.h,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('${controller.qrCount}', 'QR Codes', colors),
          _summaryItem('${controller.barcodeCount}', 'Barcodes', colors),
          _summaryItem('${controller.imageCount}', 'Images', colors),
        ],
      ),
    );
  }

  Widget _summaryItem(
      String value,
      String label,
      ColorScheme colors,
      ) {
    return Column(
      children: [
        CommonText.bold(
          value,
          size: 20.sp,
          color: colors.onPrimaryContainer,
        ),
        SizedBox(height: 4.h),
        CommonText.medium(
          label,
          size: 11.sp,
          color: colors.onPrimaryContainer,
        ),
      ],
    );
  }


  Widget _buildResultCard(
      BuildContext context,
      ColorScheme colors,
      ScanResult result,
      int index,
      ) {
    final isImage = result.type == ScanResultType.image;
    final isQr = result.type == ScanResultType.qrCode;

    final title = isImage
        ? 'Captured Image'
        : isQr
        ? 'QR Code'
        : 'Barcode';

    final icon = isImage
        ? Icons.image_outlined
        : isQr
        ? Icons.qr_code_rounded
        : Icons.view_week_rounded;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(9.w),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: colors.primary,
                  size: 22.sp,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: CommonText.semiBold(
                  title,
                  size: 15.sp,
                ),
              ),

              CommonText.medium(
                'Image ${index + 1}',
                size: 12.sp,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),

          SizedBox(height: 14.h),

          if (isImage)
            _buildImagePreview(context, result, colors)
          else
            _buildCodeData(result, colors),
        ],
      ),
    );
  }

  Widget _buildImagePreview(
      BuildContext context,
      ScanResult result,
      ColorScheme colors,
      ) {
    return GestureDetector(
      onTap: () => showFullImage(
        context,
        result.imagePath,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Image.file(
              File(result.imagePath),
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: double.infinity,
                  height: 120.h,
                  alignment: Alignment.center,
                  color: colors.surfaceContainerHighest,
                  child: CommonText.medium(
                    'Unable to display image',
                    size: 13.sp,
                  ),
                );
              },
            ),

            Positioned(
              right: 10.w,
              bottom: 10.h,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.open_in_full_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCodeData(
      ScanResult result,
      ColorScheme colors,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.medium(
            'Detected Data',
            size: 12.sp,
            color: colors.onSurfaceVariant,
          ),

          SizedBox(height: 8.h),

          CommonText.semiBold(
            result.data ?? 'No readable data',
            size: 14.sp,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: CommonText.regular(
                  'Format: ${result.format ?? "Unknown"}',
                  size: 11.sp,
                  color: colors.onSurfaceVariant,
                ),
              ),

              IconButton(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: result.data ?? ''),
                  );

                  Get.snackbar(
                    'Copied',
                    'Data copied to clipboard.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: Icon(
                  Icons.copy_rounded,
                  color: colors.primary,
                  size: 20.sp,
                ),
                tooltip: 'Copy data',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showFullImage(
      BuildContext context,
      String imagePath,
      ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close Image Preview',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 220),

      pageBuilder: (
          dialogContext,
          animation,
          secondaryAnimation,
          ) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Center(
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white,
                            size: 50,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 12.h,
                  left: 16.w,
                  child: CommonText.semiBold(
                    'Image Preview',
                    size: 17.sp,
                    color: Colors.white,
                  ),
                ),

                Positioned(
                  top: 8.h,
                  right: 16.w,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                    tooltip: 'Close preview',
                  ),
                ),
              ],
            ),
          ),
        );
      },

      transitionBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
          ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
