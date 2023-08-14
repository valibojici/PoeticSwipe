import 'package:flutter/material.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip({
    super.key,
    required this.message,
    this.margin = const EdgeInsets.all(10.0),
    this.padding = const EdgeInsets.all(10.0),
  });
  final String message;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      margin: margin,
      padding: padding,
      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.97)),
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 10),
      child: const Icon(
        Icons.info_outline,
        size: 20,
        color: Colors.grey,
      ),
    );
  }
}
