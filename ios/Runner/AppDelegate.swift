import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FBSDKCoreKit
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      // TODO: Add your Google Maps API key
      GMSServices.provideAPIKey("AIzaSyCDl6nOon4YgN9tGJuoPdxdExWjsNJFOnE")
//      FirebaseApp.configure()
     FBSDKCoreKit.ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )

     Settings.shared.appID = "556835619490578";
     Settings.shared.clientToken = "9a2129e89f35d554a9ca9e2a009fe832";
//      Settings.shared.appURLSchemeSuffix = "fb846528426459564";
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

       Messaging.messaging().apnsToken = deviceToken
       super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
     }
}
