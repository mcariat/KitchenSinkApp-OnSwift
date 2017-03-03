//
//  TriTableView.swift
//  KitchenSinkApp
//
//  Created by Student on 20/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class TriViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var textField: UITextField!
    var listData : [String] = ["Matthieu","Manon","Marin","Marion","Richard","Claude","Pierre","Simon","Frederique","Jean"]
    var filtered : [String]?
    var displayedData : [String] {
        if let data = filtered {
            return data
        } else {
            return listData
        }
    }
    var resultSearchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.delegate = self
        tableView.tableHeaderView = resultSearchController.searchBar
        
        tableView.setContentOffset(CGPoint(x: 0 ,y: resultSearchController.searchBar.bounds.height), animated: false)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        
        if searchText.isEmpty {
            filtered = nil
        } else {
            filtered = listData.filter({ (text) -> Bool in
                return text.lowercased().contains(searchText)
            })
        }
        
        self.tableView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        filtered = nil
        
        self.tableView.reloadData()
    }
    
    @IBAction func addObject(_ sender: AnyObject) {
        if(textField.text != ""){
            listData.append(textField.text!)
            textField.text = ""
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView,  numberOfRowsInSection section: Int)-> Int {
        return displayedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView") as! cellView
        
        cell.textView.text = displayedData[indexPath.row]
    
        return cell
    }
    
}


class cellView: UITableViewCell{
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var textView: UITextView!
}
