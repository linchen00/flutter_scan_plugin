
import 'flutter_scan_plugin_platform_interface.dart';

class FlutterScanPlugin {
  Future<String?> getPlatformVersion() {
    return FlutterScanPluginPlatform.instance.getPlatformVersion();
  }

  Stream<String> startDeviceScanStream() {
    return FlutterScanPluginPlatform.instance.startDeviceScanStream();
  }

}
