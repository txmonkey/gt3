package com.example.jiyan1;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** Jiyan1Plugin */
public class Jiyan1Plugin implements MethodCallHandler {

  private static String TAG = Jiyan1Plugin.class.getSimpleName();
  private static MethodChannel.Result GTresult;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "jiyan1");
    channel.setMethodCallHandler(new Jiyan1Plugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("showGeeTest")) {
      GTresult = result;
    } else {
      result.notImplemented();
    }
  }

  public static void GTResult(String status) {
    GTresult.success(status);
  }


}
