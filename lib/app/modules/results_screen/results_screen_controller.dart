import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

enum ScanResultType { qrCode, barCode, image }

class ScanResult {
  final String imagePath;
  final ScanResultType type;
  final String? data;
  final String? format;

  const ScanResult({
    required this.imagePath,
    required this.type,
    this.data,
    this.format,
  });
}

class ResultsScreenController extends GetxController {
  final isLoading = false.obs;
  final results = <ScanResult>[].obs;

  final errorMessage = ''.obs;

  late final BarcodeScanner barcodeScanner;

  @override
  void onInit() {
    super.onInit();
    barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.all]);

    final arguments = Get.arguments;

    if (arguments is List<XFile>) {
      processImages(arguments);
    } else {
      errorMessage.value = 'No captured images received';
    }
  }

  Future<void> processImages(List<XFile> images) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';
    results.clear();

    try {
      for (final image in images) {
        if (isClosed) return;

        try {
          final inputImage = InputImage.fromFilePath(image.path);

          final barCodes = await barcodeScanner.processImage(inputImage);

          if (isClosed) return;

          if (barCodes.isEmpty) {
            results.add(
              ScanResult(imagePath: image.path, type: ScanResultType.image),
            );

            continue;
          }

          //Display all detected code in the captured image
          for (final barcode in barCodes) {
            final isQrCode = barcode.format == BarcodeFormat.qrCode;

            results.add(
              ScanResult(
                imagePath: image.path,
                type: isQrCode ? ScanResultType.qrCode : ScanResultType.barCode,

                data:
                    barcode.rawValue ??
                    barcode.displayValue ??
                    'No '
                        'readable data',
                format: barcode.format.name,
              ),
            );
          }
        } catch (e) {
          //If scanning fails, still show the image
          results.add(
            ScanResult(imagePath: image.path, type: ScanResultType.image),
          );
        }
      }
    } catch (e) {
      errorMessage.value = 'Unable to process images.';
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  int get qrCount =>
      results.where((item) => item.type == ScanResultType.qrCode).length;

  int get barcodeCount =>
      results.where((item) => item.type == ScanResultType.barCode).length;

  int get imageCount =>
      results.where((item) => item.type == ScanResultType.image).length;

  @override
  void onClose() {
    barcodeScanner.close();
    super.onClose();
  }
}
