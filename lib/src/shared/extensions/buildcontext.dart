import 'package:flutter/material.dart';
import 'package:teams_gen/src/core/config/router.dart';
import 'package:teams_gen/src/shared/util/helper.dart';

extension BuildContextUI on BuildContext {
  ThemeData get theme => Theme.of(this);

  bool get isDark => theme.brightness == Brightness.dark;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSuccessToast(
    String message,
  ) {
    return Helper.showToast(message, type: ToastType.successColor);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showErrorToast(
    String message,
  ) {
    return Helper.showToast(message, type: ToastType.error);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showWarningToast(
    String message,
  ) {
    return Helper.showToast(message, type: ToastType.warning);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showInfoToast(
    String message,
  ) {
    return Helper.showToast(message, type: ToastType.info);
  }
}

extension BuildContextNav on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  void pop<T>([T? result]) => navigator.pop<T>(result);

  Future<T?> pushRoute<T>(AppRoute<T> route) {
    return navigator.pushNamed<T>(route.path.path, arguments: route.data);
  }

  Future<T?> replaceRoute<T extends Object?, TO extends Object?>(
    AppRoute<T> route,
  ) {
    return navigator.pushReplacementNamed<T, TO>(
      route.path.path,
      arguments: route.data,
    );
  }
}
