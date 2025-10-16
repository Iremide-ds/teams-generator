import 'package:flutter/material.dart';
import 'package:teams_gen/src/app.dart';
import 'package:teams_gen/src/core/config/colors.dart';
import 'package:teams_gen/src/shared/extensions/buildcontext.dart';

final class Helper {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showToast(
    String message, {
    required ToastType type,
    BuildContext? context,
  }) {
    context ??= appNavigatorKey.currentContext;

    if (context == null) return null;

    final bgColor = switch (type) {
      ToastType.error =>
        context.isDark
            ? AppColors.error.backgroundDark
            : AppColors.error.backgroundLight,
      ToastType.info =>
        context.isDark
            ? AppColors.brand.backgroundDark
            : AppColors.brand.backgroundLight,
      ToastType.warning =>
        context.isDark
            ? AppColors.warning.backgroundDark
            : AppColors.warning.backgroundLight,
      ToastType.successColor =>
        context.isDark
            ? AppColors.success.backgroundDark
            : AppColors.success.backgroundLight,
    };

    final contentColor = switch (type) {
      ToastType.error => AppColors.error.text,
      ToastType.info => AppColors.brand.text,
      ToastType.warning => AppColors.warning.text,
      ToastType.successColor => AppColors.success.text,
    };

    final iconColor = switch (type) {
      ToastType.error => AppColors.error.icon,
      ToastType.info => AppColors.brand.icon,
      ToastType.warning => AppColors.warning.icon,
      ToastType.successColor => AppColors.success.icon,
    };

    final borderColor = switch (type) {
      ToastType.error => AppColors.error.border,
      ToastType.info => AppColors.brand.border,
      ToastType.warning => AppColors.warning.border,
      ToastType.successColor => AppColors.success.border,
    };

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,

        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: borderColor),
        ),

        backgroundColor: bgColor,
        closeIconColor: iconColor,
        content: Text(message, style: TextStyle(color: contentColor)),
      ),
    );
  }
}

enum ToastType { error, info, warning, successColor }
