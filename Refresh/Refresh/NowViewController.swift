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
        setupContactArray()
    }
    
    // MARK: - Data setup
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
        friend1.status = "available"
        
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
        friend2.status = "available"
        
        // Add it to the array
        contacts.append(friend2)
        
        // Create another contact.
        var friend3 = Contacts()
        friend3.firstName = "Yolanda"
        friend3.lastName = "Yeh"
        friend3.callFrequency = 3
        friend3.lastCallDate = "03/03/2015"
        friend3.lastCallInfo = "Talked about life."
        friend3.specialDates = "null"
        friend1.status = "notavailable"
        
        // Add it to the array
        contacts.append(friend3)
        
        // Sort the contacts array by callFrequency
        contacts.sort { $0.callFrequency < $1.callFrequency }
    }

    // Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as UITableViewCell
        
        let contact = contacts[indexPath.row] as Contacts
        cell.textLabel?.text = contact.firstName

        var availableImage = UIImage(named: "available.png")
        var notAvailableImage = UIImage(named: "not_available.png")
        if contact.status == "available" {
            cell.imageView?.image = availableImage
        }
        else {
            cell.imageView?.image = notAvailableImage
        }
        
        
        return cell
    }
}