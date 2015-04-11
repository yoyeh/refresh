//
//  RefreshNetwork.swift
//  Refresh
//
//  Created by Paul  Chang on 4/6/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation

//ServerUser refers to a user that wants to interact with the server
class ServerUser
{
    private var yourPhoneNumber:String
    private var databaseURL = "http://localhost:5000"
    
    init(yourContactInfo: Contacts, serverConnection: Bool) {
        yourPhoneNumber = yourContactInfo.phoneNumber
        if serverConnection {
            println("gets into here")
            databaseURL = "https://re-fresh.herokuapp.com"
            println(databaseURL)
        }
    }
    
    //Underlying function that is responsible for communicating with the server
    private func HTTPsendRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            let task = NSURLSession.sharedSession().dataTaskWithRequest(
                request,
                completionHandler: {
                    data, response, error in
                    if error != nil {
                        callback("", error.localizedDescription)
                    } else {
                        callback(
                            NSString(data: data, encoding: NSUTF8StringEncoding)! as String,
                            nil
                        )
                    }
            })
            task.resume()
    }
    
    //value will be in JSON format
    private func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }
        }
        return ""
    }
    
    //HTTP Get request
    private func HTTPGet(url: String, callback: (String, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        HTTPsendRequest(request, callback: callback)
    }
    
    //HTTP Delete request
    private func HTTPDelete(url: String, callback: (String, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "DELETE"
        HTTPsendRequest(request, callback: callback)
    }

    //verb specifies the HTTP verb associated with the data you are sending in JSON format
    private func HTTPJSON(verb: String, url: String,
        jsonObj: AnyObject,
        callback: (String, String?) -> Void) {
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = verb
            request.addValue("application/json",
            forHTTPHeaderField: "Content-Type")
            let jsonString = JSONStringify(jsonObj)
            let data: NSData = jsonString.dataUsingEncoding(
                NSUTF8StringEncoding)!
            request.HTTPBody = data
            HTTPsendRequest(request, callback: callback)
    }
    
    
    //Add the serverUser to the server data base. contacts refers to the
    //contacts of the user
    func addContactToServer(contacts:[Contacts])
    {
        //println(status)
        var contactsPhoneNumbers = [String]()
        for contact in contacts {
            contactsPhoneNumbers.append(contact.phoneNumber)
        }
        let jsonObject:[String:[AnyObject]] = ["contacts": contactsPhoneNumbers]
        HTTPJSON("POST", url: databaseURL + "/db/\(yourPhoneNumber)", jsonObj: jsonObject) {
            (data: String, error: String?) -> Void in
            if error != nil {
                println(error)
            } else {
                println(data)
            }
        }
        sleep(1)
    }
    
    //Add or change the contacts of the server user to the specified argument
    func changeContactsOnServer(contacts:[Contacts])
    {
        //println(status)
        var contactsPhoneNumbers = [String]()
        for contact in contacts {
            contactsPhoneNumbers.append(contact.phoneNumber)
        }
        let jsonObject:[String:[AnyObject]] = ["contacts": contactsPhoneNumbers]
        HTTPJSON("PUT", url: databaseURL + "/db/contacts/\(yourPhoneNumber)", jsonObj: jsonObject){
            (data: String, error: String?) -> Void in
            if error != nil {
                println(error)
            } else {
                println(data)
            }
        }
        sleep(1)
    }

    //Changing the status of the person you have initialized your
    func changeStatus(status: Int)
    {
        //println(status)
        let jsonObject:[String:Int] = ["status":status]
        HTTPJSON("PUT", url: databaseURL + "/db/status/\(yourPhoneNumber)", jsonObj: jsonObject){
            (data: String, error: String?) -> Void in
            if error != nil {
                println(error)
            } else {
                println(data)
            }
        }
        sleep(1)
    }
    
    //Getting the status of otherPerson - initialize the RefreshNetowrk
    //object using your own phonenumber.
    func getStatusOfAnotherUser(otherPerson: Contacts) -> String
    {
        var otherPersonPhoneNumber = otherPerson.phoneNumber
        var active: String = ""
        //You must supply a callback function
        HTTPGet(databaseURL + "/db/\(otherPersonPhoneNumber)/\(yourPhoneNumber)") {
            (data: String, error: String?) -> Void in
            if error != nil {
                println(error)
            } else {
                //println("We are printing the data")
                //println(data)
                active = data
            }
        }
        sleep(1)
        return active
    }
    
    //Deleting the user from your server
    func deleteUserFromServer()
    {
        //You must supply a callback function
        HTTPDelete(databaseURL + "/db/\(yourPhoneNumber)") {
            (data: String, error: String?) -> Void in
            if error != nil {
                println(error)
            } else {
                println("Succesively deleted user from the server")
            }
        }
        sleep(1)
    }
}