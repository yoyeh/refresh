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
    private func afterPhoneCall(contact : Contacts, startTime : NSTimeInterval)
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
    
    private func saveInfo(contact : Contacts)
    {
        var localdatabase = LocalDatabase()
        localdatabase.initializeDatabase()
        
        var date = NSDate()
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = .ShortStyle
        
        contact.lastDateFormatted = date
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