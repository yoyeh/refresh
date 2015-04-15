//
//  ContactsDetailViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 4/2/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit

class ContactsDetailViewController: UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        frequencyStepper.hidden = false
    }
    
    
    @IBOutlet weak var callFrequencyLabel: UILabel!
    @IBOutlet weak var frequencyStepper: UIStepper!
    
    @IBAction func frequencyStepperValueChanged(sender: UIStepper) {
        callFrequencyLabel.text = Int(sender.value).description
    }
    
    var detailContact: Contacts? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let contact = detailContact {
            title = contact.firstName
            detailLabel?.text = contact.contactDetails
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        frequencyStepper.wraps = true
        frequencyStepper.autorepeat = true
        frequencyStepper.minimumValue = 1
        frequencyStepper.maximumValue = 8
        frequencyStepper.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    @IBOutlet weak var lastCallInfoText: UITextView!
    
    @IBAction func editContactInfo(sender: AnyObject) {
        lastCallInfoText.editable = true
    }
}