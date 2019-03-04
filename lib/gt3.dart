import 'dart:async';

import 'package:flutter/services.dart';

class Gt3 {
  static const MethodChannel _channel =
      const MethodChannel('gt3');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> showGeeTest(String url) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'key': url,
    };
    return await _channel.invokeMethod('showGeeTest', params);
  }
}
