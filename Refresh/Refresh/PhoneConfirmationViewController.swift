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

    @IBOutlet weak var confirmationCodeInput: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func clickedConfirmButton(sender: AnyObject) {
        // Verify code here
        
        // If matches server code, then
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.confirmationCodeInput.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}