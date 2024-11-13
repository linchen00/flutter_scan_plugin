import Flutter
import UIKit

public class FlutterScanPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_scan_plugin", binaryMessenger: registrar.messenger())
        let instance = FlutterScanPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let startScannngEventChannel = FlutterEventChannel(name: "flutter_scan_plugin/startScanning",
                                                           binaryMessenger: registrar.messenger(),
                                                           codec:FlutterStandardMethodCodec.sharedInstance(),
                                                           taskQueue: registrar.messenger().makeBackgroundTaskQueue?())
        startScannngEventChannel.setStreamHandler(TimeHandler())
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
