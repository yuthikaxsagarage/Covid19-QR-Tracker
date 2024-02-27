//
//  InspectionViewController.swift
//  Covid19_Tracker
//
//  Created by Harshana Rathnamalala on 6/3/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//


import UIKit
import CoreLocation
import RealmSwift
 


class InspectionViewController: UIViewController , CLLocationManagerDelegate, recieve1{
    
    @IBOutlet weak var qridinspection: UITextField!
    @IBOutlet weak var ilocation: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var remarksTextField: UITextField!
    let realm = try! Realm()
    var selectedPatient: Patient?
    let locationManager = CLLocationManager()
    var qrId: String?
    var location: String?
    var qrIdIns: String?
    func passDataBack1(data: String) {
        qrId = data
        qridinspection.text = qrId
    }
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        loadDataOfPatient()
        if let count  = selectedPatient?.remarks.count {
            print(count)
        }
    }
    
    @IBAction func location_tapped1(_ sender: Any) {
        getCurrentLocation()
        ilocation.text = location
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
            
        ilocation.text = "latitude = \(Double(round(locValue.latitude*1000)/1000)), longitude = \(Double(round(locValue.longitude*1000)/1000))"
      }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_check"{
            let secondview = segue.destination as! CameraViewController
            secondview.delegate1 = self
        }
        
    }
    // need to unwrapping
    @IBAction func submitInspectionButton(_ sender: UIButton) {
        if (qrIdIns == qridinspection.text && location == ilocation.text) {
            if let patient = self.selectedPatient {
                do {
                    try self.realm.write {
                        let remark = Remark()
                        remark.remark = remarksTextField!.text!
                        remark.dateCreated = Date()
                        patient.remarks.append(remark)
                        navigationController?.popViewController(animated: true)
                    }
                } catch {
                    print("error: \(error)")
                }
            }
        } else {
            let alert = UIAlertController(title: "Alert!", message: "Incorrect QR and/or location. Please check the location and scan the QR code which sticked on the door", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadDataOfPatient() {
        nameTextField.text = selectedPatient!.name
        addressTextField.text = selectedPatient!.address
        nicTextField.text = selectedPatient!.nic
        qrIdIns = selectedPatient!.qrId
        location = "latitude = \(round(Double(selectedPatient!.latitude)!*1000)/1000), longitude = \(round(Double(selectedPatient!.longitide)!*1000)/1000)"
        
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
    
    //MARK: -keyboard animation
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    @IBAction func remarkEditBegins(_ sender: UITextField) {
        animateViewMoving(up: true, moveValue: 180)
    }
    @IBAction func remarkEditEnd(_ sender: UITextField) {
        animateViewMoving(up: false, moveValue: 180)
    }
}
    
        
  


