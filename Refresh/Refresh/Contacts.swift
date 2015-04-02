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
    
    var phoneNumber = "null"
    
    var contactDetails:String {
        var details = "Name: \(firstName)  \(lastName)\n\n"
        details += "Call Frequnecy\n \(callFrequency)\n\n"
        details += "Last Call\n \(lastCallDate)\n \(lastCallInfo)\n\n"
        details += "Special Dates\n \(specialDates)\n\n"

        return details
    }
}