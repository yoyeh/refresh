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
    
    
    @IBAction func clickedVerifyButton(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(2, forKey: "verificationStatus") // set to verified
    }
    
}