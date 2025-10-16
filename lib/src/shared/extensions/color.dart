import 'package:flutter/material.dart';

extension ColorsX on Color {
  Color wOpacity(double value) => withAlpha((value * 255).toInt());
}
