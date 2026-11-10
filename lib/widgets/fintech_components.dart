import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Solid, high-contrast scaffold with minimal AppBar and flat light canvas.
/// Completely eliminates glassmorphic blurs and background photographs.
class FintechScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  const FintechScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppTheme.background,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Flat, high-contrast card with crisp solid borders.
/// Replaces GlassCard with a modern minimal fintech card.
class FintechCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  const FintechCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.borderRadius = 14,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: 1.0,
          color: borderColor ?? AppTheme.border,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

/// Button variants for the high-contrast fintech aesthetic.
enum FintechButtonVariant {
  primary,   // Solid pitch black background, stark white text
  secondary, // Light neutral background, dark text
  outline,   // White background with crisp border, dark text
  danger,    // Crimson red background or red outline
  ghost,     // Transparent background with subtle hover
}

/// High-contrast action button.
/// Replaces GlassPill actions with solid tactile buttons.
class FintechButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final FintechButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double borderRadius;
  final double fontSize;

  const FintechButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = FintechButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height = 46,
    this.borderRadius = 10,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    Border? border;

    switch (variant) {
      case FintechButtonVariant.primary:
        bgColor = AppTheme.primary;
        fgColor = Colors.white;
        border = null;
        break;
      case FintechButtonVariant.secondary:
        bgColor = AppTheme.surfaceVariant;
        fgColor = AppTheme.textPrimary;
        border = null;
        break;
      case FintechButtonVariant.outline:
        bgColor = AppTheme.surface;
        fgColor = AppTheme.textPrimary;
        border = Border.all(color: AppTheme.border, width: 1.2);
        break;
      case FintechButtonVariant.danger:
        bgColor = AppTheme.danger;
        fgColor = Colors.white;
        border = null;
        break;
      case FintechButtonVariant.ghost:
        bgColor = Colors.transparent;
        fgColor = AppTheme.textPrimary;
        border = null;
        break;
    }

    final buttonContent = Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: onPressed == null ? bgColor.withValues(alpha: 0.5) : bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      alignment: Alignment.center,
      child: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: fgColor,
              ),
            )
          : Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: fgColor),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: isFullWidth
            ? SizedBox(width: double.infinity, child: buttonContent)
            : buttonContent,
      ),
    );
  }
}

/// Status / Tag pill component.
/// Clean minimal flat badge without glowing borders or blurs.
class FintechBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const FintechBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  factory FintechBadge.success(String label, {IconData? icon}) {
    return FintechBadge(
      label: label,
      backgroundColor: AppTheme.successLight,
      textColor: AppTheme.success,
      icon: icon,
    );
  }

  factory FintechBadge.warning(String label, {IconData? icon}) {
    return FintechBadge(
      label: label,
      backgroundColor: AppTheme.warningLight,
      textColor: AppTheme.warning,
      icon: icon,
    );
  }

  factory FintechBadge.danger(String label, {IconData? icon}) {
    return FintechBadge(
      label: label,
      backgroundColor: AppTheme.dangerLight,
      textColor: AppTheme.danger,
      icon: icon,
    );
  }

  factory FintechBadge.neutral(String label, {IconData? icon}) {
    return FintechBadge(
      label: label,
      backgroundColor: AppTheme.surfaceVariant,
      textColor: AppTheme.textSecondary,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor ?? AppTheme.textSecondary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor ?? AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Minimalist top-level metric ticker tile.
/// Displays label, prominent bold financial value, and optional subtitle or trend.
class FintechKPICard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? valueColor;

  const FintechKPICard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return FintechCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              if (icon != null)
                Icon(icon, size: 15, color: AppTheme.textTertiary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// High-contrast segmented control / filter pill bar.
class FintechSegmentedBar extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const FintechSegmentedBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSelected = opt == selected;
          return GestureDetector(
            onTap: () => onSelected(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        )
                      ]
                    : null,
              ),
              child: Text(
                opt,
                style: TextStyle(
                  color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Flat, crisp text field input component for modals and dialogs.
class FintechInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final IconData? prefixIcon;

  const FintechInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.textTertiary, fontSize: 13),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: AppTheme.textSecondary)
                : null,
            filled: true,
            fillColor: AppTheme.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

