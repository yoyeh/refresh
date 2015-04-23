//
//  PhoneVerificationViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 4/20/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class PhoneVerificationViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var phoneNumberInput: UITextField!
    
    @IBAction func clickedVerifyButton(sender: AnyObject) {
        if (!phoneNumberInput.text.isEmpty) {
            var phoneNumber = phoneNumberInput.text
            phoneNumber = "".join(phoneNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(2, forKey: "verificationStatus") // set to verified
            defaults.setObject(phoneNumber, forKey: "mainUserPhoneNumber")
            
            // TODO set or update main user contact information. 
            // Create contact here or in RefreshNetwork method?
            
            // text message
            if (MFMessageComposeViewController.canSendText()) {
                var messageVC = MFMessageComposeViewController()
            
                messageVC.body = "Click send to verify your phone number. [RANDOMCODE]"
                messageVC.recipients = ["9172825940"] // replace with custom phone number
                messageVC.messageComposeDelegate = self
            
                self.presentViewController(messageVC, animated: true, completion: nil)
            }
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
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
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
}