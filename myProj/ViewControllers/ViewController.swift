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

//We use this delegate to communicate between our custom view and our view controller
protocol PostViewDelegate {
    func photoTapped()
    func postPressed()
    func cancelTapped()
}

class ViewController: UIViewController, SelectedLocationDelegate {
    @IBOutlet var selectedImageView: UIImageView!
    @IBOutlet weak var changeLocationButton: UIButton!
    let locationManager = CLLocationManager()
    var locationLongitude : Double?
    var locationLatitude : Double?
    var localVenueNames = [String]()
    var selectedLocation : String?
    let imagePickerController = ImagePickerController()
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var bodyTextField: UITextView!
    @IBOutlet var headlineTextField: UITextView!
    let consoleView = Bundle.main.loadNibNamed("Console", owner: self, options: nil)?.first as! PostView
    
    override func viewWillAppear(_ animated: Bool) {
        //we want the keyboard to be visible at all times in this view controller
        headlineTextField.becomeFirstResponder()
        //set our location label
        if let userSelectedLocation = selectedLocation {
            currentLocationLabel.text = userSelectedLocation
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //setup ImagePicker
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        //setup Location Manager
        setUpLocationManager()
        //setup ConsoleView
        setupConsoleView()
        headlineTextField.becomeFirstResponder()
        //We want to know when the keyboard is shown in order to set our console view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationPicker = segue.destination as! LocationPickerViewController
        locationPicker.delegate = self
        //pass the venues to our location picker viewcontroller
        locationPicker.venues = localVenueNames
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = self.view.bounds.height - keyboardRectangle.height
            //place our console right above the keyboard
            consoleView.frame = CGRect(x: 0, y: keyboardHeight - keyboardHeight*0.20, width: view.frame.width, height: keyboardHeight*0.20)
            self.view.addSubview(consoleView)
        }
    }
}

// MARK: - Location Methods
extension ViewController : CLLocationManagerDelegate {
    func setUpLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationLatitude = locations.first?.coordinate.latitude
        locationLongitude = locations.first?.coordinate.longitude
        Networking.getNearbyVenues(latitude: locationLatitude!, longitude: locationLongitude!, completionHandler: { response in
            for item in response.response.venues {
                //get the local venues to present when the user taps on "Choose location"
                self.localVenueNames.append(item.name)
            }
            //enable the the change location button once are venues have been downloaded
            self.changeLocationButton.isEnabled = true
            self.changeLocationButton.pulsate()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - ImagePicker Delegate
extension ViewController: ImagePickerDelegate {
    func setupImagePicker() {
        imagePickerController.delegate = self
        //limit the user to only pick one image at a time
        imagePickerController.imageLimit = 1
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
      //required func, not implemented
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //set the image from the imagepicker into the imageview
        if let selectedImage = images.first {
            selectedImageView.image = selectedImage
        }
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        //dismiss imagePicker
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Postview Delegate
extension ViewController: PostViewDelegate {
    //We use this delegate to communicate between our custom view and our view controller
    func photoTapped() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func cancelTapped() {
        selectedImageView.image = nil
        bodyTextField.text = ""
        headlineTextField.text = ""
        currentLocationLabel.text = "Current Location"
    }
    
    func postPressed() {
        print("not implemented")
    }
    
    func setupConsoleView() {
        //this is the view with our post buttons and camera button
        consoleView.cancelButton.layer.borderWidth = 1.5
        consoleView.cancelButton.layer.cornerRadius = 15
        consoleView.cancelButton.layer.borderColor = UIColor(displayP3Red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
        consoleView.postButton.layer.borderWidth = 1.5
        consoleView.postButton.layer.cornerRadius = 15
        consoleView.postButton.layer.borderColor = UIColor(displayP3Red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
        consoleView.postDelegate = self
    }
}

