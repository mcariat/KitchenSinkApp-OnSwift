//
//  listMsgView.swift
//  KitchenSinkApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ListMsgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listOfMessages: ContactData? = nil
    
    @IBOutlet weak var MessageToSend: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listOfMessages?.listMessages.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! MessagesCell
        cell.textViewMessage.text = "\(listOfMessages!.listMessages[indexPath.row].from): \(listOfMessages!.listMessages[indexPath.row].message)"
        return cell
    }
    
    @IBAction func clicToSend(_ sender: AnyObject) {
        MessageToSend.text = ""
    }
    
}

class MessagesCell: UITableViewCell {
    @IBOutlet weak var textViewMessage: UITextView!
    
}
