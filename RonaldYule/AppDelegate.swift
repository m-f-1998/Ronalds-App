//
//  AppDelegate.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 20/07/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import UIKit
import OneSignal
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        // change tint color of navigation bar items
        UINavigationBar.appearance().tintColor = UIColor.white/* Change tint color using Xcode default vales */
        
        // change tint color of navigation bar background
        UINavigationBar.appearance().barTintColor = UIColor(hex: "003146") /* Change background color using Xcode default vales */
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // change tint color of tab bar items
        UITabBar.appearance().tintColor = UIColor(hex: "32A4CC") /* Change tint color using Xcode default vales */
        
        // change tint color of tab bar background
        UITabBar.appearance().barTintColor = UIColor(hex: "003146") /* Change background color using Xcode default vales */
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace '11111111-2222-3333-4444-0123456789ab' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "9cf7d029-11d3-433b-92a6-3e435fab6af7",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        STPPaymentConfiguration.shared().publishableKey = "pk_live_F27oRsOruxafBt76Z3mnpYKG"
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.matthewfrankland.stripe"
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        
        return true
    }
    
    // Application will terminate
    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let characterSet = CharacterSet(charactersIn: "<>")
        let deviceTokenString: String = ((deviceToken.description as NSString).trimmingCharacters(in: characterSet) as NSString).replacingOccurrences(of: " ", with: "") as String
        print(deviceTokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    internal var shouldRotate = false
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if window == self.window {
            return .portrait
        } else {
            return .allButUpsideDown
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TABBAR") as! UITabBarController

        if shortcutItem.type == "matthewfrankland.RonaldYule.contacts"{
            vc.selectedIndex = 3
            window?.rootViewController? = vc
        }
        
        if shortcutItem.type == "matthewfrankland.RonaldYule.allvideos" {
            vc.selectedIndex = 1
            window?.rootViewController? = vc
        }
        
        if shortcutItem.type == "matthewfrankland.RonaldYule.website"{
            UIApplication.shared.open(URL(string: "http://www.ronaldyule.co.uk")!, options: [:], completionHandler: nil)
        }
    }
}
