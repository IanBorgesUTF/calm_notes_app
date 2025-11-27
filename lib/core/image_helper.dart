import 'image_helper_io.dart' if (dart.library.html) 'image_helper_web.dart' as impl;
import 'package:flutter/widgets.dart';

ImageProvider? imageProviderFromPath(String? path) => impl.imageProviderFromPath(path);