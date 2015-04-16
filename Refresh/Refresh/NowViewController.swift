//
//  NowViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 3/26/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit

var yourContactInformation = Contacts(firstname: "Main", lastname: "User", callfrequency: 5, lastcalldate: "null", lastcallinfo: "null", specialdates: "null", Status: 0, phonenumber: "1112223333")


class NowViewController: UITableViewController {
    var contacts:[Contacts] = []
    var localdatabase = LocalDatabase()
    //var displayCell:[Int] = []
    var availableImage = UIImage(named: "available.png")
    var notAvailableImage = UIImage(named: "unavailable.png")
    var serverUser: ServerUser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        println("Inside viewDidLoad()")
    }
    
    // Called right before view appears each time
    override func viewWillAppear(animated: Bool) {
        localdatabase.initializeDatabase()
        contacts = localdatabase.returnContactList()!
        
        println("Inside viewWillAppear")
        
        serverUser.getStatusOfOtherUsers(contacts, callback: statusCallback)
        sleep(1)
            
        sortContacts()
        println("Getting out of viewWillAppear()")
        
        self.tableView.reloadData()
    }
    
    private func statusCallback(statusesFromServer: [Int], contacts: [Contacts]) {
    }
    
    // Sort contacts
    func sortContacts() {
        // Sort the contacts array by callFrequency
        contacts.sort { $0.callFrequency > $1.callFrequency }
        
        let df1 = NSDateFormatter()
        let df2 = NSDateFormatter()
        // sort the contacts by last date called
        
        // Sort the contacts array by status
        contacts.sort { $0.status > $1.status }
    }

    // Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    // Display all contacts
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("NowContactCell", forIndexPath: indexPath) as! NowContactCell
        
        let contact = contacts[indexPath.row] as Contacts
        cell.nameLabel.text = contact.firstName
        if contact.status == 2 {
            cell.statusImageView.image = availableImage
        }
        else {
            cell.statusImageView.image = notAvailableImage
        }

        return cell
    }
    
    // Call contact on click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let contact = contacts[indexPath.row] as Contacts
        var phoneNumber = contact.phoneNumber
        
        if let url = NSURL(string: "tel://\(phoneNumber)") {
            UIApplication.sharedApplication().openURL(url)
            var startTime = NSDate.timeIntervalSinceReferenceDate()
            afterPhoneCall(contact, startTime: startTime)
        }
    }
    // save date and info after phone call
    func afterPhoneCall(contact : Contacts, startTime : NSTimeInterval)
    {
        sleep(3)
        let alertController: UIAlertController = UIAlertController(title: "Returning to Refresh!", message: "", preferredStyle: .Alert)
        let OKAction : UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsed = currentTime - startTime
            if elapsed >= 90 {
                self.saveInfo(contact)
            }
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated : true, completion: nil)
    }
    
    func saveInfo(contact : Contacts)
    {
        var localdatabase = LocalDatabase()
        localdatabase.initializeDatabase()
        
        var date = NSDate()
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = .ShortStyle
        
        contact.lastCallDate = dateformatter.stringFromDate(date)
        localdatabase.editContact(contact)
        
        var inputText : UITextField?
        let actionSheetController: UIAlertController = UIAlertController(title: "Call Info", message: "What did you talk about?", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            }
        
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.addTextFieldWithConfigurationHandler { (textField) in
            //TextField configuration
            inputText = textField
        }
        let OKAction = UIAlertAction(title: "Save", style: .Default) { (action) in
            contact.lastCallInfo = inputText!.text
            localdatabase.editContact(contact)
        }
        actionSheetController.addAction(OKAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
}