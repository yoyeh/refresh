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

    var contacts:[Contacts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var localdatabase = LocalDatabase()
        contacts = localdatabase.returnContactList()!
//        setupContactArray()
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
        friend1.phoneNumber = "9172825940"
        
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
        friend2.phoneNumber = "7654041348"
        
        // Add it to the array
        contacts.append(friend2)
        
        // Create another contact.
        var friend3 = Contacts()
        friend3.firstName = "Yolanda"
        friend3.lastName = "Yeh"
        friend3.callFrequency = 1
        friend3.lastCallDate = "03/03/2015"
        friend3.lastCallInfo = "Talked about life."
        friend3.specialDates = "null"
        friend1.status = 0
        
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
        var cell = tableView.dequeueReusableCellWithIdentifier("NowContactCell", forIndexPath: indexPath) as NowContactCell
        
        let contact = contacts[indexPath.row] as Contacts
        cell.nameLabel.text = contact.firstName

        var availableImage = UIImage(named: "available.png")
        var notAvailableImage = UIImage(named: "not_available.png")
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