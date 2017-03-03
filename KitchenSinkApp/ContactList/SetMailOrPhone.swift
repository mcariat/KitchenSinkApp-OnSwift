//
//  SetMailOrPhone.swift
//  KitchenSinkApp
//
//  Created by Student on 28/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import Contacts

class SetMailOrPhone : UIViewController{
    var delegate: setFilter!
    var contact : CNContact!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var typeOfRegister: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        fullNameLabel.text = "\(contact.givenName) \(contact.familyName)"
        if (contact.emailAddresses.count == 0){
            typeOfRegister.text = "Mail"
        }else if (contact.phoneNumbers.count == 0){
            typeOfRegister.text = "Phone"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
    }
    @IBAction func swipeToBack(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setValueToContact(_ sender: AnyObject) {
        let modifierContact = contact.mutableCopy() as! CNMutableContact
        let contactStore = CNContactStore()
        if (contact.emailAddresses.count == 0){
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: textField.text){
                let workEmail = CNLabeledValue(label:"Email", value:NSString(string: textField.text!))
                modifierContact.emailAddresses.append(workEmail)
                let updateRequest = CNSaveRequest()
                updateRequest.update(modifierContact)
                do{
                    try contactStore.execute(updateRequest)
                } catch{
                    print("\(error)")
                }
                delegate.reloadTable()
                self.dismiss(animated: true, completion: nil)
            }
        }else if (contact.phoneNumbers.count == 0){
            if textField.text != ""{
                let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: textField.text!))
                modifierContact.phoneNumbers.append(homePhone)
                let updateRequest = CNSaveRequest()
                updateRequest.update(modifierContact)
                do{
                    try contactStore.execute(updateRequest)
                } catch{
                    print("\(error)")
                }
                delegate.reloadTable()
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
}
