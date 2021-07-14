import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:bitmap/bitmap.dart';

class BrotherLabelPrinter {
  static const MethodChannel _channel =
      const MethodChannel('com.bridges/brother_label_printer');

  static Future<void> printFromPath(String ip, String path) async {
    return await _channel
        .invokeMethod('printLabel', {'ip': ip, 'path': path});
  }

  static Future<void> fileExist(String path) async {
    return await _channel.invokeMethod('fileExist', path);
  }
}
