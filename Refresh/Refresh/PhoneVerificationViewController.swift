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
            defaults.setInteger(1, forKey: "verificationStatus") // Set to phone number entered
            defaults.setObject(phoneNumber, forKey: "mainUserPhoneNumber")
            
            //Sending the phonenumber over to the server
            var tempUser = ServerUser(phoneNumber: phoneNumber, serverConnection: true)
            tempUser.sendVerificationRequest()
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
    
    // test local notifications
    @IBOutlet weak var notificationButton: UIButton!
    @IBAction func sendNotification(sender: AnyObject) {
        var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        localNotification.alertBody = "Paul Chang just came online"
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    // for testing only
    @IBOutlet weak var escape: UIButton!
    @IBAction func pressedEscape(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let phone = defaults.integerForKey("mainUserPhoneNumber")
        let verStatus = defaults.integerForKey("verificationStatus")
        println("Phone Number: " + String(phone))
        println("Verification status: " + String(verStatus))
    }
}