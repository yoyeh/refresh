//
//  PhoneConfirmationViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 4/26/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit

class PhoneConfirmationViewController: UIViewController,UITextFieldDelegate {

    private var defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var confirmationCodeInput: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBAction func clickedConfirmButton(sender: AnyObject) {
        
        // Instead of text is not empty, verify confirmation code
        
        if (!confirmationCodeInput.text.isEmpty) {
            // valid code
            var confirmationCode = confirmationCodeInput.text
            
            defaults.setInteger(2, forKey: "verificationStatus") // verified status
            self.performSegueWithIdentifier("SuccessfulConfirmationSegue", sender: self)
        }
        else {
            // invalid phone number - prompt user with alert to enter valid phone number
            let alert = UIAlertView()
            alert.title = "Invalid Confirmation Code"
            alert.message = "Please re-enter the confirmation code or re-enter your phone number."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    @IBOutlet weak var changeNumberButton: UIButton!
    @IBAction func clickedChangeNumberButton(sender: AnyObject) {
        defaults.setInteger(0, forKey: "verificationStatus") // no phone number entered status
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.confirmationCodeInput.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        defaults = NSUserDefaults.standardUserDefaults()
        let phone = defaults.integerForKey("mainUserPhoneNumber")
        phoneNumberLabel.text = "Phone number entered: " + String(phone)
    }

    // Hide keyboard when user taps anywhere outside keyboard
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when user presses "Done" button on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}