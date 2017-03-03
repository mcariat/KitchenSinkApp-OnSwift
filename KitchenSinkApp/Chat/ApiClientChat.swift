//
//  ApiClientChat.swift
//  KitchenSinkApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ApiCLientChat{
    let baseURL : String = "https://stormy-lake-95733.herokuapp.com/messages"
    lazy var data = NSMutableData()
    var contactsTab: [ContactData] = []
    weak var delegate: MessageDataLoad!
    
    func getData(){
        let url: URL = URL(string: baseURL)!
        print(url)
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                self.contactsTab = []
                if let parsedData = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any],
                    let responseData = parsedData["response"] as? [[String: Any]]{
                    for dataJson in responseData {
                        var exist = false
                        if let to = dataJson["to"] as? String,
                            let message = dataJson["message"] as? String,
                            let from = dataJson["from"] as? String{
                            let messageData = MessageData(message: message, from: from)
                            for contact in self.contactsTab{
                                if ((contact.to == to && contact.from == from) || (contact.to == from && contact.from == to)){
                                    contact.listMessages.append(messageData)
                                    exist = true
                                }
                            }
                            if !exist{
                                let contact = ContactData(to: to, from: from)
                                contact.listMessages.append(messageData)
                                self.contactsTab.append(contact)
                            }
                        }
                    }
                    
                }else{
                    print(error)
                }
            }
            self.delegate.reloadTableView()
            }.resume()
    }
    
    func PostData(to: String, from: String, message: String){
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(from, forKey: "from")
        para.setValue(message, forKey: "message")
        para.setValue(to, forKey: "to")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: para, options: [])
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
        print(jsonString)
        request.httpBody = jsonString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            self.delegate.reloadTableView()
        }
        task.resume()
    }
    
}

@objc protocol MessageDataLoad{
    func reloadTableView()
}

class ContactData{
    var name: String
    var to: String
    var from: String
    var listMessages: [MessageData] = []
    
    init(to: String, from: String) {
        self.name = "\(from) avec \(to)"
        self.to = to
        self.from = from
    }
    
}

class MessageData{
    var message : String
    var from : String
    
    init(message : String, from : String) {
        self.message = message
        self.from = from
    }
    
}
