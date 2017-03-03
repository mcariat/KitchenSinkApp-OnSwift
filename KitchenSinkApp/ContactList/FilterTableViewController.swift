//
//  FilterTableViewController.swift
//  KitchenSinkApp
//
//  Created by Student on 28/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class FilterTableViewController : UITableViewController{
    
    var typeOfCell = ["All","Phone","Mail"]
    weak var delegate: setFilter!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .none{
            cell.accessoryType = .checkmark
        }
        
        delegate.setFilter(typeFilter: typeOfCell[indexPath.row])
        DispatchQueue.main.async(execute: {self.dismiss(animated: true, completion: nil)})
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark{
            cell.accessoryType = .none
        }
    }
}

class filterViewController: UIViewController{
    var delegate: ContactViewListController? = nil
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "afficherTableView"{
            let secondViewController = segue.destination as! FilterTableViewController
            secondViewController.delegate = delegate
        }
    }
}


