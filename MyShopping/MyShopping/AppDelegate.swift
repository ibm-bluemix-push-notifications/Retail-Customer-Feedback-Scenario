//
//  AppDelegate.swift
//  MyShopping
//
//  Created by Anantha Krishnan K G on 21/10/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit
import BMSPush
import BMSCore
import PopupDialog
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.applicationIconBadgeNumber = 0;
        
        let types = UIApplication.shared.isRegisteredForRemoteNotifications;
        if (types == false) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            { (granted, error) in
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        return true
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
    
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        let push =  BMSPushClient.sharedInstance
        let myBMSClient = BMSClient.sharedInstance
        
        let region = Bundle.main.object(forInfoDictionaryKey: "appRegion") as! String;
        let appId = Bundle.main.object(forInfoDictionaryKey: "pushAppGuid") as! String;
        let clientSecret = Bundle.main.object(forInfoDictionaryKey: "pushClientSecret") as! String;
        
        myBMSClient.initialize(bluemixRegion:region)
        push.initializeWithAppGUID(appGUID: appId, clientSecret: clientSecret);
        
        // MARK:    REGISTERING DEVICE
        push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                print( "Response during device registration : \(response)")
                
                print( "status code during device registration : \(statusCode)")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "action"), object: self)
                

                
            }
            else{
                print( "Error during device registration \(error) ")
            }
        }
        
    }
    
    
    //Called if unable to register for APNS.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        let message:NSString = "Error registering for push notifications: \(error.localizedDescription)" as NSString
        
        self.showAlert("Registering for notifications", message: message)
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! NSString)
        
        self.showAlert("Recieved Push notifications", message: payLoad)
        
    }
    
    
    func showAlert (_ title:NSString , message:NSString){
        
        // create the alert
        let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }



}

