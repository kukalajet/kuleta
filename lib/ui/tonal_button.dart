import 'package:flutter/material.dart';

class TonalButton extends StatelessWidget {
  const TonalButton({
    required this.onPressed,
    required this.title,
    this.onPrimary,
    this.primary,
    this.minimumSize,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final String title;
  final void Function()? onPressed;
  final Color? onPrimary;
  final Color? primary;
  final Size? minimumSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final textStyle =
        textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary);
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: onPrimary ?? Theme.of(context).colorScheme.onPrimary,
      backgroundColor: primary ?? Theme.of(context).colorScheme.primary,
      minimumSize: minimumSize ?? const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ).copyWith(elevation: ButtonStyleButton.allOrNull(0));

    return Padding(
      padding: padding,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(
          title,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
