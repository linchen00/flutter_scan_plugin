import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_scan_plugin_platform_interface.dart';

/// An implementation of [FlutterScanPluginPlatform] that uses method channels.
class MethodChannelFlutterScanPlugin extends FlutterScanPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_scan_plugin');

  @visibleForTesting
  final startDeviceScanEventChannel = const EventChannel('flutter_scan_plugin/startScanning');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Stream<String> startDeviceScanStream() {
    return startDeviceScanEventChannel.receiveBroadcastStream().map((event) => event as String);
  }
}
