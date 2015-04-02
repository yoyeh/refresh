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
        friend1.callFrequency = 2
        friend1.lastCallDate = "03/01/2015"
        friend1.lastCallInfo = "Talked about COS 333 project."
        friend1.specialDates = "null"
        
        // Add it to the array
        contacts.append(friend1)
        
        // Create another contact.
        var friend2 = Contacts()
        friend2.firstName = "Malena"
        friend2.lastName = "de la Fuente"
        friend2.callFrequency = 3
        friend2.lastCallDate = "03/02/2015"
        friend2.lastCallInfo = "Talked about the weather."
        friend2.specialDates = "null"
        
        // Add it to the array
        contacts.append(friend2)
        
        // Sort the array by the model year
        contacts.sort { $0.callFrequency > $1.callFrequency }
    }
    
    // MARK: - Segues
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                let contact = contacts[indexPath.row]
//                (segue.destinationViewController as VehicleDetailViewController).detailVehicle = vehicle
//            }
//        }
//    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reusableCell", forIndexPath: indexPath) as UITableViewCell
        
        let contact = contacts[indexPath.row] as Contacts
        cell.textLabel?.text = contact.firstName
        return cell
    }
}