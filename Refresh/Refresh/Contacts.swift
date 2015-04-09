//
//  Contacts.swift
//  Refresh
//
//  Created by Yolanda Yeh on 4/1/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation

class Contacts {
    var firstName = "null"
    var lastName = "null"
    var callFrequency = 0
    var lastCallDate = "null"
    var lastCallInfo = "null"
    var specialDates = "null"
    
    var status = 1 // status: [0] unavailable [1] unknown [2] available
    var phoneNumber = "null"
    
    var fullName:String {
        return "\(firstName) \(lastName)"
    }
    
    var contactDetails:String {
        var details = "Name\n\(firstName) \(lastName)\n\n"
        details += "Call Frequency\n\(callFrequency)\n\n"
        details += "Last Call\n\(lastCallDate)\n\(lastCallInfo)\n\n"
        details += "Special Dates\n\(specialDates)\n\n"

        return details
    }
}