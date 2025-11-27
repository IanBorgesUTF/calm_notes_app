import 'dart:io';
import 'package:flutter/widgets.dart';

ImageProvider? imageProviderFromPath(String? path) {
  if (path == null || path.isEmpty) return null;
  try {
    final f = File(path);
    if (!f.existsSync()) return null;
    return FileImage(f);
  } catch (_) {
    return null;
  }
}