
import 'package:flutter/foundation.dart';
import 'dart:io' as io;

bool isWindows() {
  if (kIsWeb) {
    return false;
  } else {
    return _isWindows();
  }
}

bool _isWindows() => io.Platform.isWindows || io.Platform.isMacOS;

bool isPhone() {
  if (kIsWeb) {
    return false;
  } else {
    return _isPhone();
  }
}

bool _isPhone() => io.Platform.isAndroid || io.Platform.isIOS;