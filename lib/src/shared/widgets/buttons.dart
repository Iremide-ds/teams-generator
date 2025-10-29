import 'package:flutter/material.dart';
import 'package:teams_gen/src/shared/extensions/color.dart';

/// A reusable button widget with consistent styling and multiple variants
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isDisabled = !enabled || isLoading || onPressed == null;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(context, colorScheme, textTheme, isDisabled),
    );
  }

  Widget _buildButton(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDisabled,
  ) {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _buildPrimaryStyle(colorScheme, textTheme, isDisabled),
          autofocus: autofocus,
          focusNode: focusNode,
          child: _buildButtonChild(colorScheme, textTheme, isDisabled),
        );
      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _buildSecondaryStyle(colorScheme, textTheme, isDisabled),
          autofocus: autofocus,
          focusNode: focusNode,
          child: _buildButtonChild(colorScheme, textTheme, isDisabled),
        );
      case ButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _buildOutlinedStyle(colorScheme, textTheme, isDisabled),
          autofocus: autofocus,
          focusNode: focusNode,
          child: _buildButtonChild(colorScheme, textTheme, isDisabled),
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: _buildTextStyle(colorScheme, textTheme, isDisabled),
          autofocus: autofocus,
          focusNode: focusNode,
          child: _buildButtonChild(colorScheme, textTheme, isDisabled),
        );
      case ButtonVariant.destructive:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _buildDestructiveStyle(colorScheme, textTheme, isDisabled),
          autofocus: autofocus,
          focusNode: focusNode,
          child: _buildButtonChild(colorScheme, textTheme, isDisabled),
        );
    }
  }

  Widget _buildButtonChild(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDisabled,
  ) {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.outlined || variant == ButtonVariant.text
                ? colorScheme.primary
                : colorScheme.onPrimary,
          ),
        ),
      );
    }

    final textWidget = Text(
      text,
      style: _getTextStyle(textTheme, colorScheme, isDisabled),
    );

    if (icon == null) {
      return textWidget;
    }

    final iconWidget = Icon(
      icon,
      size: _getIconSize(),
      color: _getIconColor(colorScheme, isDisabled),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconPosition == IconPosition.left
          ? [iconWidget, const SizedBox(width: 8), textWidget]
          : [textWidget, const SizedBox(width: 8), iconWidget],
    );
  }

  ButtonStyle _buildPrimaryStyle(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDisabled,
  ) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled
          ? colorScheme.onSurface.wOpacity(0.12)
          : colorScheme.primary,
      foregroundColor: isDisabled
          ? colorScheme.onSurface.wOpacity(0.38)
          : colorScheme.onPrimary,
      elevation: isDisabled ? 0 : 2,
      shadowColor: colorScheme.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: _getPadding(),
      minimumSize: Size(0, _getHeight()),
    );
  }

  ButtonStyle _buildSecondaryStyle(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDisabled,
  ) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled
          ? colorScheme.onSurface.wOpacity(0.12)
          : colorScheme.secondary,
      foregroundColor: isDisabled
          ? colorScheme.onSurface.wOpacity(0.38)
          : colorScheme.onSecondary,
      elevation: isDisabled ? 0 : 2,
      shadowColor: colorScheme.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: _getPadding(),
      minimumSize: Size(0, _getHeight()),
    );
  }

  ButtonStyle _buildOutlinedStyle(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDisabled,
  ) {
    return OutlinedButton.styleFrom(
      foregroundColor: isDisabled
          ? colorScheme.onSurface.wOpacity(0.38)
          : colorScheme.primary,
      side: BorderSide(
        color: isDisabled
            ? colorScheme.onSurface.wOpacity(0.12)
            : colorScheme.primary,
        width: 1.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: _getPadding(),
      minimumSize: Size(0, _getHeight()),
    );
  }

  ButtonStyle _buildTextStyle(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDisabled,
  ) {
    return TextButton.styleFrom(
      foregroundColor: isDisabled
          ? colorScheme.onSurface.wOpacity(0.38)
          : colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: _getPadding(),
      minimumSize: Size(0, _getHeight()),
    );
  }

  ButtonStyle _buildDestructiveStyle(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDisabled,
  ) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled
          ? colorScheme.onSurface.wOpacity(0.12)
          : colorScheme.error,
      foregroundColor: isDisabled
          ? colorScheme.onSurface.wOpacity(0.38)
          : colorScheme.onError,
      elevation: isDisabled ? 0 : 2,
      shadowColor: colorScheme.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: _getPadding(),
      minimumSize: Size(0, _getHeight()),
    );
  }

  TextStyle _getTextStyle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    bool isDisabled,
  ) {
    final baseStyle = switch (size) {
      ButtonSize.small => textTheme.labelMedium,
      ButtonSize.medium => textTheme.labelLarge,
      ButtonSize.large => textTheme.titleMedium,
    };

    return baseStyle?.copyWith(
          fontWeight: FontWeight.w600,
          color: _getTextColor(colorScheme, isDisabled),
        ) ??
        const TextStyle(fontWeight: FontWeight.w600);
  }

  Color _getTextColor(ColorScheme colorScheme, bool isDisabled) {
    if (isDisabled) {
      return colorScheme.onSurface.wOpacity(0.38);
    }

    return switch (variant) {
      ButtonVariant.primary => colorScheme.onPrimary,
      ButtonVariant.secondary => colorScheme.onSecondary,
      ButtonVariant.outlined => colorScheme.primary,
      ButtonVariant.text => colorScheme.primary,
      ButtonVariant.destructive => colorScheme.onError,
    };
  }

  Color _getIconColor(ColorScheme colorScheme, bool isDisabled) {
    if (isDisabled) {
      return colorScheme.onSurface.wOpacity(0.38);
    }

    return switch (variant) {
      ButtonVariant.primary => colorScheme.onPrimary,
      ButtonVariant.secondary => colorScheme.onSecondary,
      ButtonVariant.outlined => colorScheme.primary,
      ButtonVariant.text => colorScheme.primary,
      ButtonVariant.destructive => colorScheme.onError,
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      ButtonSize.small => const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      ButtonSize.medium => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      ButtonSize.large => const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    };
  }

  double _getHeight() {
    return switch (size) {
      ButtonSize.small => 32,
      ButtonSize.medium => 44,
      ButtonSize.large => 56,
    };
  }

  double _getIconSize() {
    return switch (size) {
      ButtonSize.small => 16,
      ButtonSize.medium => 20,
      ButtonSize.large => 24,
    };
  }
}

/// Specialized button for primary actions
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      iconPosition: iconPosition,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
    );
  }
}

/// Specialized button for secondary actions
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      iconPosition: iconPosition,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
    );
  }
}

/// Specialized button for destructive actions
class DestructiveButton extends StatelessWidget {
  const DestructiveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.destructive,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      iconPosition: iconPosition,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
    );
  }
}

/// Specialized button for outlined actions
class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.outlined,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      iconPosition: iconPosition,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
    );
  }
}

/// Specialized button for text-only actions
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.text,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      iconPosition: iconPosition,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
    );
  }
}

/// Button variants enum
enum ButtonVariant { primary, secondary, outlined, text, destructive }

/// Button sizes enum
enum ButtonSize { small, medium, large }

/// Icon position enum
enum IconPosition { left, right }
