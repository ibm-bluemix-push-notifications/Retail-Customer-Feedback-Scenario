//
//  FeedBackViewController.swift
//  ShoppingApp
//
//  Created by Anantha Krishnan K G on 10/06/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit
import BMSPush
import BMSCore

class FeedBackViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet var sendButton: ZFRippleButton!
    @IBOutlet var feedText: UITextView!
    @IBOutlet var idText: UITextField!
    @IBOutlet var name: UITextField!
    var original:CGFloat = 0.0;
    var change:CGFloat = 0.0;
    var up:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.navigationItem.hidesBackButton = false;
        self.view.backgroundColor = UIColor(red: 219.0/255.0, green: 221.0/255.0, blue: 222.0/255.0, alpha: 1.0);
        self.sendButton.layer.cornerRadius = 5.0;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeedBackViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeedBackViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        if (up == false){
            original = self.view.frame.origin.y;
            self.view.frame.origin.y -= change
            up = true
            change = 0;
        }
    }
    func keyboardWillHide(sender: NSNotification) {
        if(up == true){
            self.view.frame.origin.y = original
            up = false
        }
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if(textField == self.name){
            change = 0;
        }
        else{
            change = 150;
        }
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        change = 150;
        return true
    }
    @IBAction func sendAction(sender: AnyObject) {
        
        
        var devId = String()
        let authManager  = BMSClient.sharedInstance.authorizationManager
        devId = authManager.deviceIdentity.id!
        
        let textValue = feedText.text;
        // var idNumber = idText.text;
        let nameValue = name.text;
        
        let dict:NSMutableDictionary = NSMutableDictionary()
        
        var devIdArray = [String]()
        devIdArray.append(devId);
        
        dict.setValue(devIdArray, forKey: "deviceIds")
        dict.setValue(textValue, forKey:"message")
        dict.setValue(nameValue, forKey: "name")

        
        let randomId = randomString(2);
        let db = NSBundle.mainBundle().objectForInfoDictionaryKey("CloudantName") as! String;
        let userName = NSBundle.mainBundle().objectForInfoDictionaryKey("cloudantUserName") as! String;
        let authData = NSBundle.mainBundle().objectForInfoDictionaryKey("cloudantPermission") as! String;
        
        
        // here "jsonData" is the dictionary encoded in JSON data
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        let data = authData.dataUsingEncoding(NSUTF8StringEncoding);
        let base64 = data!.base64EncodedStringWithOptions([])
        
        var url = String();
        url = "http://\(userName).cloudant.com/\(db)/\(randomId)";
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!);
        request.HTTPMethod = "PUT"
        request.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        request.HTTPBody = jsonData;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
           // self.alertview();
        }
        task.resume()
        
    }
    func randomString(length: Int) -> String {
        let charactersString = "abc12345"
        let charactersArray = Array(arrayLiteral: charactersString)
        
        var string = ""
        for _ in 0..<length {
            string += charactersArray[Int(arc4random()) % charactersArray.count]
        }
        
        return string
    }
    
    func alertview(){
        
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = "THank you"
        alertViewController.message = "Thanks for your valuable Feed back"
        
        // Customize appearance as desired
        alertViewController.buttonCornerRadius = 20.0
        alertViewController.view.tintColor = self.view.tintColor
        
        alertViewController.titleFont = UIFont(name: "AvenirNext-Bold", size: 19.0)
        alertViewController.messageFont = UIFont(name: "AvenirNext-Medium", size: 16.0)
        alertViewController.cancelButtonTitleFont = UIFont(name: "AvenirNext-Medium", size: 16.0)
        
        alertViewController.swipeDismissalGestureEnabled = true
        alertViewController.backgroundTapDismissalGestureEnabled = true
        
        // Add alert actions
        let cancelAction = NYAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: { (action: NYAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                exit(0)
            }
        )
        alertViewController.addAction(cancelAction)
        
        
        // Present the alert view controller
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
