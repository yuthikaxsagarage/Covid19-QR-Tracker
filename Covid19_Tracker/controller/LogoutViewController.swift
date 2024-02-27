//
//  LogoutViewController.swift
//  Covid19_Tracker
//
//  Created by Hasara Yaddehige on 6/2/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//

import UIKit
import Firebase
class LogoutViewController: UITableViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var phi: UILabel!
    
    @IBOutlet weak var district: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDocument()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }
    

    @IBAction func logout_tapped(_ sender: Any) {
        variable.status = false
        Switcher.updateRootVC()
        let newViewObject = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController //LoginPageViewController is my login view file, and identifier also has the same name.
        self.navigationController?.pushViewController(newViewObject, animated: true)

    }
    private func getDocument() {
        //Get sspecific document from current user
        let docRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")

        // Get data
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            } else if querySnapshot!.documents.count != 1 {
                print("More than one documents or none")
            } else {
                let document = querySnapshot!.documents.first
                let dataDescription = document?.data()
                guard let firstname = dataDescription?["first"] else { return }
                self.name.text = firstname as? String
                guard let lastname = dataDescription?["last"] else { return }
                self.name.text?.append(" ")
                self.name.text?.append(lastname as! String)
                guard let district = dataDescription?["district"] else { return }
                         self.district.text = district as? String
                guard let phi = dataDescription?["phi"] else { return }
                         self.phi.text = phi as? String
            }
        }
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
