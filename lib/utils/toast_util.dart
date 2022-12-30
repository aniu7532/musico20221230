import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyToast {
  /// init EasyLoading
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return EasyLoading.init(builder: builder);
  }

  static void show({
    String? status,
    EasyLoadingMaskType? maskType,
  }) {
    const indicator = CircularProgressIndicator(
      strokeWidth: 2,
    );
    EasyLoading.show(
      status: status,
      indicator: indicator,
      maskType: maskType ?? EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
  }

  static void showSuccess(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap = true,
  }) {
    EasyLoading.showSuccess(
      status,
      duration: duration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  static void showError(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap = true,
  }) {
    EasyLoading.showError(
      status,
      dismissOnTap: dismissOnTap,
      duration: duration,
      maskType: maskType,
    );
  }

  static void showInfo(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap = true,
  }) {
    EasyLoading.showInfo(
      status,
      duration: duration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  ///居中吐司  后续有需求把位置作为参数封装
  static void showToast(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap = true,
  }) {
    EasyLoading.showToast(
      status,
      duration: duration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  /// 默认样式的输入dialog
  /// create by ls 2022/4/25
  static void showDialog(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap = true,
  }) {
    EasyLoading.show(
        status: status,
        maskType: maskType,
        dismissOnTap: dismissOnTap,
        indicator: Text('ss'));
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
