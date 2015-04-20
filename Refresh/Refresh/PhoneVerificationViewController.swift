//
//  PhoneVerificationViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 4/20/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit

class PhoneVerificationViewController: UIViewController {
    
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var phoneNumberInput: UITextField!
    
    @IBAction func clickedVerifyButton(sender: AnyObject) {
        if (!phoneNumberInput.text.isEmpty) {
            var phoneNumber = phoneNumberInput.text
            phoneNumber = "".join(phoneNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(2, forKey: "verificationStatus") // set to verified
            defaults.setObject(phoneNumber, forKey: "mainUserPhoneNumber")
            
            // set or update main user contact information. Create contact here or in RefreshNetwork method?
        }
        else {
            // prompt user with alert to enter valid phone number
            let alert = UIAlertView()
            alert.title = "Invalid Phone Number"
            alert.message = "Please Enter a valid phone number."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}