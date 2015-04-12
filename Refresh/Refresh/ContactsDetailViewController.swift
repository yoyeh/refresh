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
    }
    
    @IBOutlet weak var lastCallInfoText: UITextView!
    
    @IBAction func editContactInfo(sender: AnyObject) {
        lastCallInfoText.editable = true
    }
}