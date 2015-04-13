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
            databaseURL = "https://re-fresh.herokuapp.com"
        }
    }
    
    //Underlying function that is responsible for communicating with the server
    //callback function is the code that gets executed after the HTTP request is completed
    //This either means that it will be called during the error or it will called after a succesful
    //call and it will be executed.
    private func HTTPsendRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            println("Actually in HTTPsendRequst")
            
            //completion handler is what gets called after request finishes. It uses
            //callback as an error handler or way to actually deal with the request
            let task = NSURLSession.sharedSession().dataTaskWithRequest(
                request,
                completionHandler:
                {
                    data, response, error in
                    println("In completion handler")
                    if error != nil {
                        callback("", error.localizedDescription)//1) callback as error handler
                    } else {
                        //2) callback as actual processing code
                        callback(
                            NSString(data: data, encoding: NSUTF8StringEncoding)! as String,
                            nil
                        )
                    }
            })
            println("Gets past let task in HTTPsendRequest")
            task.resume()//actually sending over the HTTP request
            println("get's past task.resume")
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
        println("HTTPGet request")
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
    
    //The regular call back function when the client does not need the data belonging in the HTTP request
    private func regCallBack(data: String, error: String?) -> Void
    {
        if error != nil {
            println(error)
        }
        else {
            println(data)
        }
        
    }
    
    //Add the serverUser to the server data base. If contact already exists then simply the information on the server
    func putContactToServer(contacts:[Contacts], status: Int)
    {
        var contactsPhoneNumbers = [String]()
        for contact in contacts {
            contactsPhoneNumbers.append(contact.phoneNumber)
        }
        
        let jsonObject:[String: AnyObject] = ["contacts": contactsPhoneNumbers, "status": status]

        HTTPJSON("POST", url: databaseURL + "/db/\(yourPhoneNumber)", jsonObj: jsonObject, callback: regCallBack)
    }
    
    //Add or change the contacts of the server user to the specified argument
    func changeContactsOnServer(contacts:[Contacts])
    {
        var contactsPhoneNumbers = [String]()
        for contact in contacts {
            contactsPhoneNumbers.append(contact.phoneNumber)
        }
        
        let jsonObject:[String:[AnyObject]] = ["contacts": contactsPhoneNumbers]
        
        HTTPJSON("PUT", url: databaseURL + "/db/contacts/\(yourPhoneNumber)", jsonObj: jsonObject, callback: regCallBack)
    }

    //Changing the status of the person you have initialized your serverUser to
    func changeStatus(status: Int)
    {
        let jsonObject:[String:Int] = ["status":status]
        HTTPJSON("PUT", url: databaseURL + "/db/status/\(yourPhoneNumber)", jsonObj: jsonObject, callback: regCallBack)
    }

    //Deleting the user from your server
    func deleteUserFromServer()
    {
        HTTPDelete(databaseURL + "/db/\(yourPhoneNumber)", callback: regCallBack)
    }
    
    //Getting the status of otherPerson
    func getStatusOfAnotherUser(otherPerson: Contacts, callback: (Int, Contacts) -> Void)
    {
        println("gets inside getStatuOfAnotherUser")
        var otherPersonPhoneNumber = otherPerson.phoneNumber
        //You must supply a callback function - doing so as a closure
        HTTPGet(databaseURL + "/db/\(otherPersonPhoneNumber)/\(yourPhoneNumber)") {
            (data: String, error: String?) -> Void in
            println("Callback within HTTP request")
            if error != nil {
                println(error)
            } else {
                if (data.toInt() == nil) {println (error)}
                else {callback(data.toInt()!, otherPerson)}
            }
        }
    }
    
    
}