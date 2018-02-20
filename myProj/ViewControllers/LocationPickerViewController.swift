//
//  LocationPickerViewController.swift
//  myProj
//
//  Created by Michael Ardizzone on 2/19/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import UIKit

class LocationPickerViewController: UIViewController {
    @IBOutlet var locationsTableView: UITableView!
    var venues = [String]()
    var selectedVenue = ""
    var delegate : SelectedLocationDelegate?
    var filteredData = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // go back to main view controller
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - TableView Methods
extension LocationPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            //set number of rows based on filtered results
            return filteredData.count
        } else {
            //set number of rows to the total number of venues
            return venues.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venue")
        let text : String?
        if isSearching {
            //show filtered results
            text = filteredData[indexPath.row]
        } else {
            //show all results
            text = venues[indexPath.row]
        }
        cell?.textLabel?.text = text
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //user selected a venue in the filtered results
        if isSearching {
            selectedVenue = filteredData[indexPath.row]
        } else {
            //user selected a venue in the non filtered results
            selectedVenue = venues[indexPath.row]
        }
        let locationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "locationVC") as! ViewController
        self.delegate = locationVC
        //pass selected venue to main view controller
        locationVC.selectedLocation = selectedVenue
        self.present(locationVC, animated: true, completion: nil)
    }
}

//MARK: - SearchBar Delegate
extension LocationPickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //set our isSearching variable if the user is manipulating the search field
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            locationsTableView.reloadData()
        } else {
            isSearching = true
            filteredData = venues.filter({ (venues: String) -> Bool in
                if venues.localizedCaseInsensitiveContains(searchBar.text!) {
                    return true
                } else {
                    return false
                }
            })
            locationsTableView.reloadData()
        }
    }
}


protocol SelectedLocationDelegate {
    var selectedLocation : String? {get set}
}
