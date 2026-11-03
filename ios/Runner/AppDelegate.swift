import AVFoundation
import CoreLocation
import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let headingHandler = HeadingStreamHandler()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Promemoria locali (fasi del fallout, controllo dello zaino) visibili anche con l'app aperta.
    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "RefugeHeading") {
      FlutterEventChannel(name: "rifugio/heading", binaryMessenger: registrar.messenger())
        .setStreamHandler(headingHandler)
      FlutterMethodChannel(name: "rifugio/files", binaryMessenger: registrar.messenger())
        .setMethodCallHandler(Self.handleFiles)
      FlutterMethodChannel(name: "rifugio/speech", binaryMessenger: registrar.messenger())
        .setMethodCallHandler { [weak self] call, result in self?.handleSpeech(call, result: result) }
    }
  }

  private let synthesizer = AVSpeechSynthesizer()

  /// Lettura ad alta voce con le voci di sistema (offline).
  private func handleSpeech(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "speak":
      guard let args = call.arguments as? [String: Any], let text = args["text"] as? String else {
        return result(FlutterError(code: "args", message: nil, details: nil))
      }
      synthesizer.stopSpeaking(at: .immediate)
      try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
      let utterance = AVSpeechUtterance(string: text)
      utterance.voice = AVSpeechSynthesisVoice(language: args["language"] as? String)
      synthesizer.speak(utterance)
      result(nil)
    case "stop":
      synthesizer.stopSpeaking(at: .immediate)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Esclude una cartella (es. i file ZIM da decine di GB) dal backup iCloud.
  private static func handleFiles(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "excludeFromBackup", let path = call.arguments as? String else {
      return result(FlutterMethodNotImplemented)
    }
    var url = URL(fileURLWithPath: path)
    var values = URLResourceValues()
    values.isExcludedFromBackup = true
    do {
      try url.setResourceValues(values)
      result(nil)
    } catch {
      result(FlutterError(code: "backup", message: error.localizedDescription, details: nil))
    }
  }
}

/// Invia a Flutter la direzione della bussola di sistema (già calibrata da iOS).
class HeadingStreamHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  private var sink: FlutterEventSink?

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    guard CLLocationManager.headingAvailable() else {
      return FlutterError(code: "unavailable", message: "Bussola non disponibile", details: nil)
    }
    sink = events
    manager.delegate = self
    manager.headingFilter = 1
    manager.startUpdatingHeading()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    manager.stopUpdatingHeading()
    sink = nil
    return nil
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    // trueHeading vale -1 se la posizione non è nota: in quel caso si usa il nord magnetico.
    let heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
    sink?(["heading": heading, "accuracy": newHeading.headingAccuracy])
  }

  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool { true }
}
