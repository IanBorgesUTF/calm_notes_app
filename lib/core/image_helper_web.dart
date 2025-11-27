import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

ImageProvider? imageProviderFromPath(String? path) {
  if (path == null || path.isEmpty) return null;
  try {
    final p = path.trim();
    if (p.startsWith('data:')) {
      final idx = p.indexOf(',');
      if (idx > -1) {
        final payload = p.substring(idx + 1);
        final bytes = base64Decode(payload);
        return MemoryImage(Uint8List.fromList(bytes));
      }
    }
    if (p.startsWith('http://') || p.startsWith('https://')) {
      return NetworkImage(p);
    }
    return null;
  } catch (_) {
    return null;
  }
}