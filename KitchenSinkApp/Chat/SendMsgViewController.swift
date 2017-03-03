//
//  File.swift
//  KitchenSinkApp
//
//  Created by Student on 26/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class SendToNewContactViewController: UIViewController{
    @IBOutlet weak var textInputTo: UITextField!
    @IBOutlet weak var textInputFrom: UITextField!
    @IBOutlet weak var textInputMessage: UITextView!
    var apiClientChat: ApiCLientChat? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setApiClientChat(apiClientChat : ApiCLientChat){
        self.apiClientChat = apiClientChat
    }
    
    
    
    @IBAction func clicToSend(){
        if(textInputTo.text != "" && textInputFrom.text != "" && textInputMessage.text != ""){
            apiClientChat?.PostData(to: textInputTo.text!, from: textInputFrom.text!, message: textInputMessage.text)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
