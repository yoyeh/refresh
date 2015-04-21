//
//  AppDelegate.swift
//  Refresh
//
//  Created by Yolanda Yeh on 3/25/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var types: UIUserNotificationType = UIUserNotificationType.Badge |
            UIUserNotificationType.Alert |
            UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
//        application.registerForRemoteNotifications()
        
//        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))) {
//            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge, categories: nil))
//        }
//        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.boolForKey("firstLaunch") {
            // not first launch
            let verStatus = defaults.integerForKey("verificationStatus")
            if verStatus == 0 {
                // show screen to enter phone number
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var initialViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("VerifyPhoneStoryboardID") as! UIViewController
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
            else if verStatus == 1 {
                // resend text option
            }
            else {
                // open normal app view, no verification process
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var initialViewController: UITabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarStoryboardID") as! UITabBarController
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        else {
            // first launch
            defaults.setBool(true, forKey: "firstLaunch")
            defaults.setInteger(0, forKey: "verificationStatus")
            // verification status
            // [0] has not entered phone number
            // [1] phone number entered but not verfied
            // [2] phone number verified
        }
        
        return true
    }
    
    // If the app is running while the notification is delivered, there is no alert displayed on screen.
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        println( deviceTokenString )
        
    }

    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError ) {
        println( error.localizedDescription )
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

