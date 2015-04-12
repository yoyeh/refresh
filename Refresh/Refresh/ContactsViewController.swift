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
    var localdatabase = LocalDatabase()
    let personPicker: ABPeoplePickerNavigationController

    required init(coder aDecoder: NSCoder) {
        personPicker = ABPeoplePickerNavigationController()
        super.init(coder: aDecoder)
        personPicker.peoplePickerDelegate = self
    }
    
    // Initialize mandatory function
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
    }
    
    // Open up addressbook when user presses '+'
    @IBAction func performPickPerson(sender: AnyObject) {
        self.presentViewController(personPicker, animated : true, completion : nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecordRef!) {
        // Check if it is the right picker
        if peoplePicker != personPicker {
            return
        }

        var newContact = Contacts()
        
        // Get name of contact
        newContact.firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as! String
        newContact.lastName = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue() as! String
        println(newContact.lastName)
        
        // Get all phone numbers of contact, choose first one
        let phones : ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        var phoneNumber = ABMultiValueCopyValueAtIndex(phones, 0).takeRetainedValue() as! String
        newContact.phoneNumber = "".join(phoneNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
        
        if (!localdatabase.doesContactExist(newContact)) {
        contacts.append(newContact)
        }
        localdatabase.addContact(newContact)
        
        self.tableView.reloadData()
        
        var serveruser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
        serveruser.putContactToServer(contacts, status: 0)

        var serveruser2 = ServerUser(yourContactInfo: newContact, serverConnection: true)
        var contacts2:[Contacts] = []
        contacts2.append(yourContactInformation)
        serveruser2.putContactToServer(contacts2, status: 2)
    }
    
    // Called only once, the first time the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        localdatabase.initializeDatabase()
    }
    
    // Called right before view appears each time
    override func viewWillAppear(animated: Bool) {
        contacts = localdatabase.returnContactList()!
    }
    
    // Called when view disappears
    override func viewDidDisappear(animated: Bool) {
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