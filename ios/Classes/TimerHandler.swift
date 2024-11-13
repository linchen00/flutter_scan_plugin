import Foundation
import Flutter

class TimeHandler: NSObject,FlutterStreamHandler{
    
    private var eventSink: FlutterEventSink?
    
    private let backgroundQueue = DispatchQueue(label: "com.example.backgroundTimer")
    
    private var timer: DispatchSourceTimer?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("onListen......")
        
        self.eventSink = events
        timer = DispatchSource.makeTimerSource(queue: backgroundQueue)
        timer?.schedule(deadline: .now(), repeating: 1.0)
        timer?.setEventHandler { [weak self] in
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "HH:mm:ss"
            let time = dateFormat.string(from: Date())
            print("time:\(time)")
            DispatchQueue.main.async {
                self?.eventSink?(time)
            }
            print("GCD Timer fired on background thread!")
        }
        timer?.resume()
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("onCancel......")
        stop()
        return nil
    }
    
    func stop() -> Void {
        timer?.cancel()
        timer = nil
    }
    
    
}
