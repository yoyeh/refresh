//
//  SettingsViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 5/5/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        let phone = defaults.stringForKey("mainUserPhoneNumber")
        phoneNumberLabel.text = phone
    }
}