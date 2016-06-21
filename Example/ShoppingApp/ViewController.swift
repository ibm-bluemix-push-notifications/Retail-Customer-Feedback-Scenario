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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = UIColor(red: 52.0/255.0, green: 170.0/255.0, blue: 220.0/255.0, alpha: 1.0);

        regPush();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func regPush(){
        
        let types = UIApplication.sharedApplication().isRegisteredForRemoteNotifications();
        if (types == false) {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
        else{
            alertview();
        }
       // alertview()
        
    }
    
    func alertview(){
        
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = "Feed Back"
        alertViewController.message = "Would you like to send us the feed back of latest purchase ?"
        
        // Customize appearance as desired
        alertViewController.buttonCornerRadius = 20.0
        alertViewController.view.tintColor = self.view.tintColor
        
        alertViewController.titleFont = UIFont(name: "AvenirNext-Bold", size: 19.0)
        alertViewController.messageFont = UIFont(name: "AvenirNext-Medium", size: 16.0)
        alertViewController.cancelButtonTitleFont = UIFont(name: "AvenirNext-Medium", size: 16.0)
        alertViewController.buttonTitleFont = UIFont(name: "AvenirNext-Medium", size: 16.0)
        
        alertViewController.swipeDismissalGestureEnabled = true
        alertViewController.backgroundTapDismissalGestureEnabled = true
        
        // Add alert actions
        let cancelAction = NYAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: { (action: NYAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        let cancelAction1 = NYAlertAction(
            title: "Done",
            style: .Cancel,
            handler: { (action: NYAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("push", sender: self)
            }
        )
        alertViewController.addAction(cancelAction)

        alertViewController.addAction(cancelAction1)

        // Present the alert view controller
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }

}

