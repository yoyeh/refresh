//
//  NowViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 3/26/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit

var yourContactInformation = Contacts(firstname: "Main", lastname: "User", callfrequency: 5, lastcalldate: "null", lastcallinfo: "null", specialdates: "", Status: 0, phonenumber: "1112223333")


class NowViewController: UITableViewController {
    private var contacts:[Contacts] = []
    private var localdatabase = LocalDatabase()
    private var availableImage = UIImage(named: "available.png")
    private var notAvailableImage = UIImage(named: "unavailable.png")
    private var serverUser: ServerUser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
    private var statusUpdateTime:Double = 1

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Called right before view appears each time
    override func viewWillAppear(animated: Bool) {
        /*var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
        actInd.stopAnimating()*/
        
        localdatabase.initializeDatabase()
        contacts = localdatabase.returnContactList()!
        updateStatus()
        
        var statusUpdate = NSTimer.scheduledTimerWithTimeInterval(statusUpdateTime, target: self, selector: Selector("updateStatus"), userInfo: nil, repeats: true)
    }
    
    func updateStatus()
    {
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
    
    private var newContact : Contacts = Contacts()
    // Display all contacts
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("NowContactCell", forIndexPath: indexPath) as! NowContactCell
        
        let contact = contacts[indexPath.row] as Contacts
        cell.nameLabel.text = contact.firstName + " " + contact.lastName
        if contact.status == 2 {
            cell.statusImageView.image = availableImage
        }
        else {
            cell.statusImageView.image = notAvailableImage
        }

        return cell
    }
    
    private var startTime : NSTimeInterval = 0.0
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
    
    @IBAction func cancelToNowViewController(segue : UIStoryboardSegue)
    {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsed = currentTime - startTime
        var localdatabase = LocalDatabase()
        localdatabase.initializeDatabase()
        if elapsed >= 10 {
            
            var date = NSDate()
            var dateformatter = NSDateFormatter()
            dateformatter.dateStyle = .ShortStyle
            dateformatter.timeStyle = .ShortStyle
            
            newContact.lastCallDate = dateformatter.stringFromDate(date)
            
        } 
        
    }
    
    @IBAction func saveContactInfo(segue : UIStoryboardSegue)
    {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsed = currentTime - startTime
 
        if let saveinfoviewcontroller = segue.sourceViewController as? SaveInfoController {
           
            var localdatabase = LocalDatabase()
            localdatabase.initializeDatabase()
            if elapsed >= 10 {
                
                var date = NSDate()
                var dateformatter = NSDateFormatter()
                dateformatter.dateStyle = .ShortStyle
                dateformatter.timeStyle = .ShortStyle
                
                newContact.lastCallDate = dateformatter.stringFromDate(date)

            }
            
            newContact.lastCallInfo = saveinfoviewcontroller.calltext
            var dateformat = NSDateFormatter()
            dateformat.dateStyle = .ShortStyle
            dateformat.timeStyle = .ShortStyle
            var special = dateformat.stringFromDate(saveinfoviewcontroller.specialDate)
            if (newContact.specialDates == "")
            {
                newContact.specialDates = special
            }
            else
            {
            newContact.specialDates = "\(newContact.specialDates)\n\(special)"
            }
            localdatabase.editContact(newContact)
        }
    
    }
    
}