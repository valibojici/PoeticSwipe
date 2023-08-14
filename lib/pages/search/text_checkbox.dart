import 'package:flutter/material.dart';

class TextCheckbox extends StatelessWidget {
  const TextCheckbox(
      {super.key,
      required this.text,
      required this.checked,
      required this.onTap});
  final bool checked;
  final String text;
  final void Function(bool?) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Checkbox(value: checked, onChanged: onTap), Text(text)],
    );
  }
}
