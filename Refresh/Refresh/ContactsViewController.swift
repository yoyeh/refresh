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
    private var contacts:[Contacts] = []
    private var localdatabase = LocalDatabase()
    private var personPicker: ABPeoplePickerNavigationController
    private var defaults = NSUserDefaults.standardUserDefaults()
    private var serveruser:ServerUser = ServerUser()

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
        if var first = ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String {
            newContact.firstName = first
        }
        if var last = ABRecordCopyValue(person, kABPersonLastNameProperty)?.takeRetainedValue() as? String {
            newContact.lastName = last
        }
        
        // Get all phone numbers of contact, choose first one
        if var phones : ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue() {
            if let phoneNumber = ABMultiValueCopyValueAtIndex(phones, 0).takeRetainedValue() as? String {
                var phone = "".join(phoneNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
                if count(phone) == 10 {
                    newContact.phoneNumber = "1" + phone
                }
                else {
                    newContact.phoneNumber = phone
                }
            }
        }
        
        if (!localdatabase.doesContactExist(newContact)) {
            contacts.append(newContact)
        }
        localdatabase.addContact(newContact)
        
        self.tableView.reloadData()
        
        serveruser = ServerUser(phoneNumber: defaults.stringForKey("mainUserPhoneNumber")!, serverConnection: true)
        serveruser.putContactToServer(contacts, status: 0)

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
                contact.specialDates = contact.removeOldDates()
                localdatabase.editContact(contact)
                let navController = segue.destinationViewController as! UINavigationController
                let detailController = navController.topViewController as! ContactsDetailViewController
                detailController.detailContact = contact
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
        if contact.firstName == "" {
            cell.textLabel?.text = contact.lastName
        }
        else if contact.lastName == "" {
            cell.textLabel?.text = contact.firstName
        }
        else {
            cell.textLabel?.text = contact.firstName + " " + contact.lastName
        }
        
        return cell
    }
    
    // Delete contact by swiping
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let contactToDelete = contacts[indexPath.row] as Contacts
            contacts.removeAtIndex(indexPath.row)
            localdatabase.deleteContact(contactToDelete)
            serveruser = ServerUser(phoneNumber: defaults.stringForKey("mainUserPhoneNumber")!, serverConnection: true)
            serveruser.changeContactsOnServer(contacts)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}