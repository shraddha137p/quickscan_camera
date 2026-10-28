import 'package:get/get.dart';
import 'package:quickscan_camera/app/modules/camera_screen/camera_screen_binding.dart';
import 'package:quickscan_camera/app/modules/camera_screen/camera_screen_view.dart';
import 'package:quickscan_camera/app/modules/results_screen/results_screen_binding.dart';
import 'package:quickscan_camera/app/modules/results_screen/results_screen_view.dart';



part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.CAMERA_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.CAMERA_SCREEN,
      page: () => const CameraScreenView(),
      binding: CameraScreenBinding(),
    ),

    GetPage(
      name: _Paths.RESULTS_SCREEN,
      page: () => const ResultsScreenView(),
      binding: ResultsScreenBinding(),
    ),
  ];
}
