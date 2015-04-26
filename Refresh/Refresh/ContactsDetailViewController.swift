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
    private var localdatabase = LocalDatabase()
    private var updatedContact = Contacts()
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var callFrequencyLabel: UILabel!
    @IBOutlet weak var frequencyStepper: UIStepper!
    
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            frequencyStepper.hidden = false
            sender.title = "Done"
        }
        else { // if done
            sender.title = "Edit"
            frequencyStepper.hidden = true
            updatedContact.callFrequency = Int(frequencyStepper.value)
            localdatabase.editContact(updatedContact)
        }
    }
    
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
            
            callFrequencyLabel?.text = String(contact.callFrequency)
            detailLabel?.text = contact.contactDetails
            
            // write copy contact duplicate or copy function?
            updatedContact = Contacts(firstname: contact.firstName, lastname: contact.lastName, callfrequency: contact.callFrequency, lastcalldate: contact.lastCallDate, lastcallinfo: contact.lastCallInfo, specialdates: contact.specialDates, Status: contact.status, phonenumber: contact.phoneNumber)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localdatabase.initializeDatabase()
        
        configureView()
        
        frequencyStepper.wraps = true
        frequencyStepper.autorepeat = true
        frequencyStepper.minimumValue = 1
        frequencyStepper.maximumValue = 8
        frequencyStepper.hidden = true
        frequencyStepper.value = Double(updatedContact.callFrequency)
    }
    
    override func viewDidAppear(animated: Bool) {
    }

}