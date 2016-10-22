//
//  feedBackViewController.swift
//  MyShopping
//
//  Created by Anantha Krishnan K G on 21/10/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit
import PopupDialog
import BMSPush
import BMSCore
import OpenWhisk

class feedBackViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var feedText: UITextView!
    @IBOutlet var idText: UITextField!
    @IBOutlet var name: UITextField!
    var original:CGFloat = 0.0;
    var change:CGFloat = 0.0;
    var up:Bool = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(feedBackViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(feedBackViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(_ sender: Notification) {
        
        if (up == false){
            original = self.view.frame.origin.y;
            self.view.frame.origin.y -= change
            up = true
            change = 0;
        }
    }
    func keyboardWillHide(_ sender: Notification) {
        if(up == true){
            self.view.frame.origin.y = original
            up = false
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == self.name){
            change = 0;
        }
        else{
            change = 150;
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        change = 150;
        return true
    }
    
    @IBAction func sendAction(_ sender: AnyObject) {
        
        
        var devId = String()
        let authManager  = BMSClient.sharedInstance.authorizationManager
        devId = authManager.deviceIdentity.ID!;
        
        let textValue = feedText.text;
        let productNumber = idText.text;
        let nameValue = name.text;
        
        let whiskKey = Bundle.main.object(forInfoDictionaryKey: "whiskKey") as! String;
        let whiskPass = Bundle.main.object(forInfoDictionaryKey: "whiskPass") as! String;
        
        let credentialsConfiguration = WhiskCredentials(accessKey: whiskKey, accessToken: whiskPass)
        
        let whisk = Whisk(credentials: credentialsConfiguration)
        
        let db = Bundle.main.object(forInfoDictionaryKey: "cloudantName") as! String;
        let userName = Bundle.main.object(forInfoDictionaryKey: "cloudantUserName") as! String;
        let password = Bundle.main.object(forInfoDictionaryKey: "cloudantPassword") as! String;
        let hostName = Bundle.main.object(forInfoDictionaryKey: "cloudantHostName") as! String;
        
        var params = Dictionary<String, Any>()
        params["username"] = userName
        params["host"] = hostName
        params["password"] = password
        params["dbname"] = db
        let randomId = randomString(2);
        let doc = ["_id": randomId, "deviceIds":"\(devId)", "message":"\(textValue!)", "name":"\(nameValue!)", "productNumber": "\(productNumber!)"]
        params["doc"] = doc
       
        do {
            
            try whisk.invokeAction(name: "write", package: "cloudant", namespace: "whisk.system", parameters: params as AnyObject?, hasResult: false, callback: {(reply, error) -> Void in
                if let error = error {
                    //do something
                    print("Error invoking action \(error.localizedDescription)")
                } else {
                    print("Action invoked! \( reply)")
                    self.alertview();
                }
                
            })
        } catch {
            print("Error \(error)")
        }
        
    }
    func randomString(_ length: Int) -> String {
        let allowedChars = "abc12345"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<length){
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.characters.index(allowedChars.startIndex, offsetBy: randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    func alertview(){
        
        
        let title = "Thank you"
        let message = "Thanks for your valuable Feed back"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        let buttonTwo = DefaultButton(title: "OK") {
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        popup.addButtons([buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }

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

