import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreenController extends GetxController {
  CameraController? cameraController;

  final isInitialized = false.obs;
  final isInitializing = false.obs;
  final isSessionStart = false.obs;
  final isCapture = false.obs;
  final isPermissionPermanentlyDenied = false.obs;
  final errorMessage = ''.obs;

  final captureImages = <XFile>[].obs;

  int get imageCount => captureImages.length;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      isPermissionPermanentlyDenied.value = false;
      return true;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      isPermissionPermanentlyDenied.value = true;
      errorMessage.value =
          'Camera access is disable. Please enable it from '
          'settings.';
    } else {
      isPermissionPermanentlyDenied.value = false;
      errorMessage.value = 'Camera permission is requeired to capture images.';
    }
    return false;
  }

  Future<void> initializeCamera() async {
    if (isInitializing.value || isInitialized.value) return;

    isInitializing.value = true;
    errorMessage.value = '';

    CameraController? newController;

    try {
      final hasPermission = await checkCameraPermission();

      if (!hasPermission || isClosed) return;

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        errorMessage.value = 'No camera found on this device';

        return;
      }

      final selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      newController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await newController.initialize();

      if (isClosed) {
        await newController.dispose();
        return;
      }

      cameraController = newController;

      isInitialized.value = true;
    } on CameraException catch (e) {
      errorMessage.value = _cameraError(e);

      await newController?.dispose();
    } catch (e) {
      errorMessage.value = 'Unable to initialize  camera.';
      await newController?.dispose();
    } finally {
      if (!isClosed) {
        isInitialized.value = true;
      }
    }
  }

  Future<void> retryCamera() async {
    if (isPermissionPermanentlyDenied.value) {
      await openAppSettings();
      return;
    }
    await initializeCamera();
  }

  void startSession() {
    if (!isInitialized.value || isSessionStart.value || isCapture.value) {
      return;
    }

    captureImages.clear();
    isSessionStart.value = true;
  }

  Future<void> captureImage() async {
    final controller = cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        !isSessionStart.value ||
        isCapture.value ||
        controller.value.isTakingPicture) {
      return;
    }

    try {
      isCapture.value = true;

      final image = await controller.takePicture();
      if (isClosed) return;

      captureImages.add(image);
    } on CameraException catch (e) {
      if (!isClosed) {
        Get.snackbar(
          'Capture Failed',
          e.description ??
              'Unable to capture '
                  'image',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (!isClosed) {
        Get.snackbar(
          'Error',
          'Something went wrong while capturing  image.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (!isClosed) {
        isCapture.value = false;
      }
    }
  }

  Future<void> stopSession() async {
    if (!isSessionStart.value || isCapture.value) {
      return;
    }

    isSessionStart.value = false;

    final image = List<XFile>.from(captureImages);

    if (image.isEmpty) {
      Get.snackbar(
        'No Images',
        'Please capture at least one image',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.toNamed('/results-screen', arguments: image);
  }

  String _cameraError(CameraException error) {
    switch (error.code) {
      case 'CameraAccessDenied':
        return 'Camera Permission Denied. Please allow access.';
      case 'CameraAccessDeniedWithoutPrompt':
      case 'CameraPermissionRestricted':
        isPermissionPermanentlyDenied.value = true;

        return 'Enable camera access from device settings.';

      default:
        return error.description ?? 'Camera unavailable.';
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    cameraController = null;
    super.onClose();
  }
}
