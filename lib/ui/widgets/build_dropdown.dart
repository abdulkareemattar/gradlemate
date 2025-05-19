import 'package:flutter/material.dart';
Widget buildDropdown(
    BuildContext context,
    String? selectedValue,
    String hintText,
    List<String> items,
    Function(String?) onChanged,
    ) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final backgroundColor = isDark ? Colors.grey[850] : Colors.white;
  final textColor = isDark ? Colors.white : Colors.black87;

  return DropdownButtonFormField<String>(
    value: selectedValue,
    decoration: InputDecoration(
      labelText: hintText,
      labelStyle: TextStyle(color: textColor),
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    icon: Icon(Icons.arrow_drop_down, color: textColor),
    dropdownColor: backgroundColor,
    style: TextStyle(color: textColor, fontSize: 14),
    items: items
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    ))
        .toList(),
    onChanged: onChanged,
  );
}


