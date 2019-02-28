import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt3/gt3.dart';

void main() {
  const MethodChannel channel = MethodChannel('gt3');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Gt3.platformVersion, '42');
  });
}
