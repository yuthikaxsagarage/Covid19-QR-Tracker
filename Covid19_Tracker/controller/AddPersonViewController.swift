//
//  AddPersonViewController.swift
//  Covid19_Tracker
//
//  Created by Harshana Rathnamalala on 5/7/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift
 


class AddPersonViewController: UIViewController , CLLocationManagerDelegate, recieve{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var lblocation: UITextField!
    @IBOutlet weak var qrid: UITextField!
    
    var latitude: Double?
    var longitude: Double?
    let realm = try! Realm()
    var location: String?
    func passDataBack(data: String) {
        qrid.text = data
    }
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    

    @IBAction func addPatient(_ sender: UIButton) {
        let patient = Patient()
        if let name = self.nameTextField.text {
            patient.name = name
        }
        if let address = self.addressTextField.text {
            patient.address = address
        }
        if let nic = self.nicTextField.text {
            patient.nic = nic
        }
        if let qr = self.qrid.text {
            patient.qrId = qr
        }
        if let lan = latitude {
            patient.latitude = String(lan)
        }
        if let lon = longitude {
            patient.longitide = String(lon)
        }
        patient.dateCreated = Date()
        if ((nameTextField.text) != "" && (addressTextField.text) != "" && (nicTextField.text) != ""
            && (qrid.text) != "" && (location) != nil) {
            self.saveData(patient: patient)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Alert!", message: "Empty field identified. Please make sure to fill all fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        
    }
    
    @IBAction func location_tapped(_ sender: Any) {
         getCurrentLocation()
    }
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        latitude = locValue.latitude
        longitude = locValue.longitude
    
        location = "latitude = \(round((latitude)!*1000)/1000), longitude = \(round((longitude)!*1000)/1000)"
        lblocation.text = location
      
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "qrsegue"{
            let secondview = segue.destination as! CameraViewController
            secondview.delegate = self
        }
        
    }
    
//MARK: - Realm functions
    func saveData(patient: Patient) {
        do {
            try realm.write{
                realm.add(patient)
                print("user added")
            }
        } catch {
            print("Erro: \(error)")
        }
    }
}

    
        
  

