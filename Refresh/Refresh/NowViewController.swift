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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Called right before view appears each time
    override func viewWillAppear(animated: Bool) {
        localdatabase.initializeDatabase()
        contacts = localdatabase.returnContactList()!
        sortContacts()
        
        self.tableView.reloadData()
    }
    
    // Sort contacts
    func sortContacts() {
        // Sort the contacts array by callFrequency
        contacts.sort { $0.callFrequency > $1.callFrequency }
        
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
    
    func statusCallback(statusFromServer: Int, contact: Contacts) {
        contact.status = statusFromServer
        println("----------------")
        println("phonenumber in callback: \(contact.phoneNumber)")
        println("status in callback: \(contact.status)")
    }
    
    // Display all contacts
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("NowContactCell", forIndexPath: indexPath) as! NowContactCell
        
        let contact = contacts[indexPath.row] as Contacts
        cell.nameLabel.text = contact.firstName

        var availableImage = UIImage(named: "available.png")
        var notAvailableImage = UIImage(named: "not_available.png")
        
        var serverUser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
        
        println("----------------")
        println("phonenumber: \(contact.phoneNumber)")
        println("status: \(contact.status)")
        
        
        serverUser.getStatusOfAnotherUser(contact, callback: statusCallback)
        
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
        
        var localdatabase = LocalDatabase()
        localdatabase.initializeDatabase()
        var date = NSDate()
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = .ShortStyle
        
        if let url = NSURL(string: "tel://\(phoneNumber)") {
            contact.lastCallDate = dateformatter.stringFromDate(date)
            localdatabase.editContact(contact)
            UIApplication.sharedApplication().openURL(url)
        }
    }
}