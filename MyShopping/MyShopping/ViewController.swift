//
//  ViewController.swift
//  MyShopping
//
//  Created by Anantha Krishnan K G on 21/10/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit
import PopupDialog

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       NotificationCenter.default.addObserver(self, selector: #selector(ViewController.actionName), name: NSNotification.Name(rawValue: "action"), object: nil)
        //self.performSegue(withIdentifier: "feedback", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateMessage () {
        
        self.performSegue(withIdentifier: "feedback", sender: self)

        
    }
    
    func actionName() {
        

        
        let title = "How was your experience"
        let message = "Please give a feed back for your last purchase"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Not now") {
            print("You canceled the car dialog.")
        }
        
        let buttonTwo = DefaultButton(title: "Now") {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "action"), object: self)
            self.performSegue(withIdentifier: "feedback", sender: self)
        }
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }

}

