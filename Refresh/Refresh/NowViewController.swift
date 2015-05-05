//
//  NowViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 3/26/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit

class NowViewController: UITableViewController {
    private var contacts:[Contacts] = []
    private var defaults = NSUserDefaults.standardUserDefaults()
    private var localdatabase = LocalDatabase()
    private var availableImage = UIImage(named: "available.png")
    private var notAvailableImage = UIImage(named: "unavailable.png")
    private var statusUpdateTime:Double = 1
    private var newContact : Contacts = Contacts() // store the contact information
    private var startTime : NSTimeInterval = 0.0 // checking the length of the phone call
    
    var serverUser:ServerUser = ServerUser() //Empty ServerUserObject - Cannot initialize object here because 'defaults' not recognized

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Called right before view appears each time
    override func viewWillAppear(animated: Bool) {
        //Initialize the server object to
        serverUser = ServerUser(phoneNumber: defaults.stringForKey("mainUserPhoneNumber")!, serverConnection: true)
        
        localdatabase.initializeDatabase()
        contacts = localdatabase.returnContactList()!
        updateStatus()
        
        var statusUpdate = NSTimer.scheduledTimerWithTimeInterval(statusUpdateTime, target: self, selector: Selector("updateStatus"), userInfo: nil, repeats: true)
    }
    
    func updateStatus() {
        serverUser.getStatusOfOtherUsers(contacts)
        sortContacts()
        self.tableView.reloadData()
    }
    
    // Sort contacts
    func sortContacts() {
        // Sort the contacts array by time since last call
        contacts.sort { $0.sortLastDate($0) < $1.sortLastDate($1) }

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
        if contact.firstName == "null" {
            cell.nameLabel.text = contact.lastName
        }
        else if contact.lastName == "null" {
            cell.nameLabel.text = contact.firstName
        }
        else {
            cell.nameLabel.text = contact.firstName + " " + contact.lastName
        }
        
        if contact.status == 2 {
            cell.statusImageView.image = availableImage
        }
        else {
            cell.statusImageView.image = notAvailableImage
        }
        
        let oneHour = 60
        let oneDay = 24 * oneHour
        let oneWeek = 7 * oneDay
        
        var activeSince = contact.activeSince
        if activeSince > -1 {
            if activeSince < oneHour {
                cell.activeSinceLabel.text = "Active" + String(activeSince) + "m ago"
            }
            else if activeSince < oneDay {
                var hours = Int(round(Double(activeSince) / Double(oneHour)))
                cell.activeSinceLabel.text = "Active" + String(hours) + "h ago"
            }
            else if activeSince < oneWeek {
                var days = Int(round(Double(activeSince) / Double(oneDay)))
                cell.activeSinceLabel.text = "Active" + String(days) + "d ago"
            }
            else {
                cell.activeSinceLabel.text = "Active >1w ago"
            }
        }
        else {
            cell.activeSinceLabel.text = ""
        }
        
        return cell
    }

    // Call contact on click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let contact = contacts[indexPath.row] as Contacts
        var phoneNumber = contact.phoneNumber
        
        if let url = NSURL(string: "tel://\(phoneNumber)") {
            UIApplication.sharedApplication().openURL(url)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            newContact = contact
        }
    }
    
    // cancel button for saving call info
    @IBAction func cancelToNowViewController(segue : UIStoryboardSegue) {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsed = currentTime - startTime
        
        if elapsed >= 10 {
            var date = NSDate()
            var dateformatter = NSDateFormatter()
            dateformatter.dateStyle = .ShortStyle
            
            newContact.lastCallDate = dateformatter.stringFromDate(date)
            localdatabase.editContact(newContact)
        }
    }
    
    // save button for saving call info
    @IBAction func saveContactInfo(segue : UIStoryboardSegue) {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsed = currentTime - startTime
 
        if let saveinfoviewcontroller = segue.sourceViewController as? SaveInfoController {
            // check how long the phone call was 
            if elapsed >= 10 {
                var date = NSDate()
                var dateformatter = NSDateFormatter()
                dateformatter.dateStyle = .ShortStyle
                
                newContact.lastCallDate = dateformatter.stringFromDate(date)
            }
            
            newContact.lastCallInfo = saveinfoviewcontroller.calltext
            var dateformat = NSDateFormatter()
            dateformat.dateStyle = .ShortStyle
            //dateformat.timeStyle = .ShortStyle
            var special = dateformat.stringFromDate(saveinfoviewcontroller.specialDate)
            if (newContact.specialDates == "") {
                newContact.specialDates = special
            }
            else {
                newContact.specialDates = "\(newContact.specialDates)\n\(special)"
            }
            
            localdatabase.editContact(newContact)
        }
    }
}