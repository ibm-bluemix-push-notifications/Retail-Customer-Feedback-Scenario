/*
 * Copyright 2015-2016 IBM Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import BMSPush
import BMSCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
    
    func application (application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        
        let push =  BMSPushClient.sharedInstance
        let myBMSClient = BMSClient.sharedInstance
        
        myBMSClient.initializeWithBluemixAppRoute("https://ananthop.mybluemix.net", bluemixAppGUID: "3de683c5-88a7-4fb7-9d03-08b53c57d303", bluemixRegion: BMSClient.REGION_US_SOUTH)
        
        myBMSClient.defaultRequestTimeout = 10.0
        
        // MARK:    REGISTERING DEVICE
        
        push.registerDeviceToken(deviceToken) { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during device registration : \(response)")
                
                print( "status code during device registration : \(statusCode)")
                
            }
            else{
                print( "Error during device registration \(error) ")
            }
        }
    }
    
    //Called if unable to register for APNS.
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        let message:NSString = "Error registering for push notifications: "+error.description
        
        self.showAlert("Registering for notifications", message: message)
        
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        let payLoad = ((((userInfo as NSDictionary).valueForKey("aps") as! NSDictionary).valueForKey("alert") as! NSDictionary).valueForKey("body") as! NSString)
        
        self.showAlert("Recieved Push notifications", message: payLoad)
        
    }
    
    
    func showAlert (title:NSString , message:NSString){
        
        // create the alert
        let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.window!.rootViewController!.presentViewController(alert, animated: true, completion: nil)
    }



}

