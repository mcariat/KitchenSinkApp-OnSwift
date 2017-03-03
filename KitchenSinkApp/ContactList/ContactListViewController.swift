//
//  ContactListViewController.swift
//  KitchenSinkApp
//
//  Created by Student on 27/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import Contacts

class ContactViewListController: UIViewController, UITableViewDelegate, UITableViewDataSource, setFilter{
    
    @IBOutlet weak var contactTable: UITableView!
    var contactList = [CNContact]()
    var filtered : [CNContact]!
    var displayedContact : [CNContact] {
        if let data = filtered {
            return data
        } else {
            return contactList
        }
    }
    var typeFilter: String = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllContact()
    }
    
    func reloadTable(){
        getAllContact()
        filtered = nil
        for contact in contactList{
            if (contact.emailAddresses.count == 0 && typeFilter == "Mail"){
                if filtered == nil{
                    filtered = [CNContact]()
                }
                self.filtered.append(contact)
            }else if (contact.phoneNumbers.count == 0 && typeFilter == "Phone"){
                if filtered == nil{
                    filtered = [CNContact]()
                }
                self.filtered.append(contact)
            }
        }
        contactTable.reloadData()
    }
    
    func setFilter(typeFilter: String) {
        self.typeFilter = typeFilter
        self.reloadTable()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let contact = displayedContact[indexPath.row]
        cell.labelName.text = "\(contact.givenName) \(contact.familyName)"
        if (contact.emailAddresses.count == 0){
            cell.imageContact.image = #imageLiteral(resourceName: "mailIcon")
        }else if (contact.phoneNumbers.count == 0){
            cell.imageContact.image = #imageLiteral(resourceName: "phoneIcon")
        }
        
        return cell
    }
    
    func getAllContact(){
        contactList = []
        let contactStore = CNContactStore()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactNamePrefixKey,
                    CNContactEmailAddressesKey,
                    CNContactPhoneNumbersKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
         do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                if (contact.emailAddresses.count == 0){
                    self.contactList.append(contact)
                }else if (contact.phoneNumbers.count == 0){
                    self.contactList.append(contact)
                }
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        contactTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterMenu"{
            let secondViewController = segue.destination as! filterViewController
            secondViewController.delegate = self
        }else if segue.identifier == "setMailOrPhone"{
            let secondViewController = segue.destination as! SetMailOrPhone
            secondViewController.delegate = self
            secondViewController.contact = contactList[(contactTable.indexPathForSelectedRow?.row)!]
        }
    }
}

@objc protocol setFilter{
    func setFilter(typeFilter: String)
    func reloadTable()
}

class ContactCell: UITableViewCell{
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageContact : UIImageView!
    @IBOutlet weak var labelName: UILabel!
}
