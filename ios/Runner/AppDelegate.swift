import UIKit
import Flutter
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    // Check if the app is running on an iPad
    if UIDevice.current.userInterfaceIdiom == .pad {
        fatalError("This app is designed for iPhones only.")
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
