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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var localdatabase = LocalDatabase()
        localdatabase.initializeDatabase()
        contacts = localdatabase.returnContactList()!
//        setupContactArray()
    }
    
    // Data setup
    func setupContactArray() {
        // Clear the array. (Start from scratch.)
        contacts.removeAll(keepCapacity: true)
        
        // Create a contact.
        var friend1 = Contacts(firstname: "Paul", lastname: "Chang", callfrequency: 3, lastcalldate: "03/01/2015", lastcallinfo: "Talked about COS 333 project.", specialdates: "null", Status: 2, phonenumber: "9172825940")
        
        // Add it to the array
        contacts.append(friend1)
        
        // Create another contact.
        var friend2 = Contacts(firstname: "Malena", lastname: "de la Fuente", callfrequency: 2, lastcalldate: "03/02/2015", lastcallinfo: "Talked about the weather.", specialdates: "null", Status: 2, phonenumber: "7654041348")
        
        // Add it to the array
        contacts.append(friend2)
        
        // Create another contact.
        var friend3 = Contacts(firstname: "Yolanda", lastname: "Yeh", callfrequency: 1, lastcalldate: "03/03/2015", lastcallinfo: "Talked about life.", specialdates: "null", Status: 0, phonenumber: "7654041348")
        
        // Add it to the array
        contacts.append(friend3)
        
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
    
    // Display all contacts
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("NowContactCell", forIndexPath: indexPath) as! NowContactCell
        
        let contact = contacts[indexPath.row] as Contacts
        cell.nameLabel.text = contact.firstName

        var availableImage = UIImage(named: "available.png")
        var notAvailableImage = UIImage(named: "not_available.png")
        
        var serverUser = ServerUser(yourContactInfo: contact, serverConnection: true)
        contact.status =
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
        }
    }
}