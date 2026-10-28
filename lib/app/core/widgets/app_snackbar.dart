import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String title, String message) {
    _show(
      title,
      message,
      const Color(0xFF2E7D32),
      Icons.check_circle_outline,
    );
  }

  static void error(String title, String message) {
    _show(
      title,
      message,
      const Color(0xFFC62828),
      Icons.error_outline,
    );
  }

  static void _show(
    String title,
    String message,
    Color backgroundColor,
    IconData icon,
  ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: Icon(icon, color: Colors.white),
    );
  }
}