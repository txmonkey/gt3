import 'dart:async';

import 'package:flutter/services.dart';

class Gt3 {
  static const MethodChannel _channel =
      const MethodChannel('gt3');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get showGeeTest async {
    return await _channel.invokeMethod('showGeeTest');
  }
}
