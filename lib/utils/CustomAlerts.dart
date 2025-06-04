import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hr_app/utils/Colors.dart';
import 'package:toastification/toastification.dart';

class Customalerts {
  static successAlert({required String title, String body = ""}) {
    toastification.show(
      context: Get.context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(title),
      description: Text(body, style: TextStyle(fontWeight: FontWeight.w600)),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return ScaleTransition(scale: animation, child: child);
      },
      primaryColor: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(12.0),
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  static warningAlert({required String title, String body = ""}) {
    toastification.show(
      context: Get.context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      description: Text(body),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return ScaleTransition(scale: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      closeOnClick: false,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  static errorAlert({required String title, String body = ""}) {
    toastification.show(
      context: Get.context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      description: Text(body),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return ScaleTransition(scale: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      closeOnClick: false,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }
}
