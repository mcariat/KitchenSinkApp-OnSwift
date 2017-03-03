//
//  ChatViewController.swift
//  KitchenSinkApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class allConversationTableView: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageDataLoad {
    
    var listOfConversations: [Int] = []
    var apiClientChat: ApiCLientChat = ApiCLientChat()
    @IBOutlet var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiClientChat.delegate = self
        apiClientChat.getData()
        
    }
    
    func reloadTableView(){
        DispatchQueue.main.async(){
            self.contactTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiClientChat.contactsTab.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        cell.labelNameOfConversation.text = apiClientChat.contactsTab[indexPath.row].name
        cell.setNbOfMsg(nbMsg: apiClientChat.contactsTab[indexPath.row].listMessages.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "listMsgueSegue", sender: indexPath)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listMsgueSegue"{
            let secondViewController = segue.destination as! ListMsgViewController
            let contact = apiClientChat.contactsTab[(contactTableView.indexPathForSelectedRow?.row)!]
            secondViewController.listOfMessages = contact
        }else if segue.identifier == "SendMsgToNewContact"{
            let secondViewController = segue.destination as! SendToNewContactViewController
            secondViewController.setApiClientChat(apiClientChat: apiClientChat)
        }
    }
    
}

class ConversationCell : UITableViewCell{
    @IBOutlet weak var labelNbMsg: UILabel!
    @IBOutlet weak var labelNameOfConversation: UILabel!
    
    func setNbOfMsg(nbMsg: Int){
        labelNbMsg.text = "=> \(nbMsg) Msg"
    }
    
}
