//
//  ContactsViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 3/26/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit
import AddressBookUI

class ContactsViewController: UITableViewController, ABPeoplePickerNavigationControllerDelegate {
    var contacts:[Contacts] = []
    
    let personPicker: ABPeoplePickerNavigationController
    
    // initialize addressbook
    required init(coder aDecoder: NSCoder) {
        personPicker = ABPeoplePickerNavigationController()
        super.init(coder: aDecoder)
        personPicker.peoplePickerDelegate = self
    }
    
    // initialize mandatory function
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
    }
    
    // open up address book when '+' is hit
    @IBAction func performPickPerson(sender: AnyObject) {
        self.presentViewController(personPicker, animated : true, completion : nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecordRef!) {
        
        // Check if it is the right picker
        if peoplePicker != personPicker {
            return
        }

        var localdatabase = LocalDatabase()
        localdatabase.initializeDatabase()
        var newContact = Contacts()
        
        // get name of contact
        let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as! String
        let lastName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as! String
        
         // get all phone numbers of contact, choose first one
        let phones : ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        let phone = ABMultiValueCopyValueAtIndex(phones, 0).takeRetainedValue() as! String
        
        newContact.firstName = firstName
        newContact.lastName = lastName
        newContact.phoneNumber = phone
        
        localdatabase.addContact(newContact)
        
        println(firstName + " " + lastName)
        println(phone)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupContactArray()
    }
    
    // open up address book when '+' is hit
    @IBAction func addContacts(sender: AnyObject) {
        self.presentViewController(personPicker, animated : true, completion : nil)
    }
    
    // Data setup
    func setupContactArray() {
        // Clear the array. (Start from scratch.)
        contacts.removeAll(keepCapacity: true)
        
        // Create a contact.
        var friend1 = Contacts()
        friend1.firstName = "Paul"
        friend1.lastName = "Chang"
        friend1.callFrequency = 4
        friend1.lastCallDate = "03/01/2015"
        friend1.lastCallInfo = "Talked about COS 333 project."
        friend1.specialDates = "null"
        friend1.status = 2
        
        // Add it to the array
        contacts.append(friend1)
        
        // Create another contact.
        var friend2 = Contacts()
        friend2.firstName = "Malena"
        friend2.lastName = "de la Fuente"
        friend2.callFrequency = 2
        friend2.lastCallDate = "03/02/2015"
        friend2.lastCallInfo = "Talked about the weather."
        friend2.specialDates = "null"
        friend2.status = 2
        
        // Add it to the array
        contacts.append(friend2)
        
        // Sort the contacts array by callFrequency
        contacts.sort { $0.callFrequency < $1.callFrequency }
    }
    
    // Handle Segues to other views
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showContactDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let contact = contacts[indexPath.row]
                (segue.destinationViewController as! ContactsDetailViewController).detailContact = contact
            }
        }
    }
    
    // Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! UITableViewCell
        
        let contact = contacts[indexPath.row] as Contacts
        cell.textLabel?.text = contact.firstName + " " + contact.lastName
        
        return cell
    }
}