//
//  FourSquareTableViewController.swift
//  myProj
//
//  Created by Michael Ardizzone on 2/19/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import UIKit

class FourSquareTableViewController: UITableViewController, UISearchResultsUpdating   {

    var array = ["One", "Two", "Three", "Four", "Five", "Six"]
    var filteredArray = [String]()
    var searchController = UISearchController()
    var resultController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: resultController)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        resultController.tableView.delegate = self
        resultController.tableView.delegate = self
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredArray = array.filter( { (array : String) -> Bool in
            if array.contains(searchController.searchBar.text!) {
                return true
            } else {
                return false
            }
        })
        resultController.tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resultController.tableView {
            return filteredArray.count
        } else {
            return array.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == resultController.tableView {
            cell.textLabel?.text = filteredArray[indexPath.row]
        } else {
            cell.textLabel?.text = array[indexPath.row]
        }
        return cell
    }
    
}
