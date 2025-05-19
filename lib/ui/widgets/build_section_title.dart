import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildSectionTitle(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.teal,
    ),
  );
}
