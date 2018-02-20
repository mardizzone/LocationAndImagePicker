//
//  LocationPickerViewController.swift
//  myProj
//
//  Created by Michael Ardizzone on 2/19/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import UIKit

class LocationPickerViewController: UIViewController {
    
    var venues = [String]()
    var selectedVenue = ""
    
    var delegate : SelectedLocationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(venues)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venue")
        cell?.textLabel?.text = venues[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVenue = venues[indexPath.row]
        let locationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "locationVC") as! ViewController
        self.delegate = locationVC
        locationVC.selectedLocation = selectedVenue
        self.present(locationVC, animated: true, completion: nil)
        
    }
    
}

protocol SelectedLocationDelegate {
    var selectedLocation : String? {get set}
}
