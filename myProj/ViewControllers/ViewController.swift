//
//  ViewController.swift
//  myProj
//
//  Created by Michael Ardizzone on 2/17/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import UIKit
import ImagePicker
import CoreLocation

class ViewController: UIViewController, PostViewDelegate, SelectedLocationDelegate {
    
    @IBOutlet var selectedImageView: UIImageView!
    let locationManager = CLLocationManager()
    var locationLongitude : Double?
    var locationLatitude : Double?
    var localVenueNames = [String]()
    var selectedLocation : String?
    let imagePickerController = ImagePickerController()

    

    @IBOutlet var currentLocationLabel: UILabel!
    
    @IBOutlet var headlineTextField: UITextView!
    
    let consoleView = Bundle.main.loadNibNamed("coolestDawgs", owner: self, options: nil)?.first as! PostView

    func photoTapped() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func postPressed() {
        print("not implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headlineTextField.becomeFirstResponder()
        
        if let userSelectedLocation = selectedLocation {
            currentLocationLabel.text = userSelectedLocation
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        //setupButtons
        consoleView.cancelButton.layer.borderWidth = 1.5
        consoleView.cancelButton.layer.cornerRadius = 15
        consoleView.cancelButton.layer.borderColor = UIColor(displayP3Red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
        
        consoleView.postButton.layer.borderWidth = 1.5
        consoleView.postButton.layer.cornerRadius = 15
        consoleView.postButton.layer.borderColor = UIColor(displayP3Red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
        consoleView.postDelegate = self
        
        headlineTextField.becomeFirstResponder()
        

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var locationPicker = segue.destination as! LocationPickerViewController
        locationPicker.delegate = self
        locationPicker.venues = localVenueNames
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = self.view.bounds.height - keyboardRectangle.height
            consoleView.frame = CGRect(x: 0, y: keyboardHeight - keyboardHeight*0.20, width: view.frame.width, height: keyboardHeight*0.20)
            self.view.addSubview(consoleView)
        }
    }

}

protocol PostViewDelegate {
    func photoTapped()
    func postPressed()
}

// MARK: - Location Methods
extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationLatitude = locations.first?.coordinate.latitude
        locationLongitude = locations.first?.coordinate.longitude
        Networking.getNearbyVenues(latitude: locationLatitude!, longitude: locationLongitude!, completionHandler: { response in
            if let neareastLocation = response.response.venues.first?.name {
                for item in response.response.venues {
                    self.localVenueNames.append(item.name)
                }
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if let selectedImage = images.first {
            selectedImageView.image = selectedImage
        }
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}

