//
//  HomeViewController.swift
//  Covid19_Tracker
//
//  Created by Harshana Rathnamalala on 5/7/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class HomeViewController: SwipeTableViewController {
    
    var patientList: Results<Patient>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.navigationItem.hidesBackButton = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return patientList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let patient = patientList?[indexPath.row] {
            cell.textLabel?.text = patient.name
            cell.detailTextLabel?.text = patient.address
        }
        return cell
    }
    
    //MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "inspection_identifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! InspectionViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPatient = patientList?[indexPath.row]
        }
    }
    
//MARK: - load Patients
    func loadData() {
        patientList = realm.objects(Patient.self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
//MARK: - Delete person
    override func deleteItem(at indexPath: IndexPath) {
        if let person = self.patientList?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(person)
                }
            } catch {
                print("error while deleting: \(error)")
            }
        }
    }
   

}
