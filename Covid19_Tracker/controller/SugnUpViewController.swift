//
//  SugnUpViewController.swift
//  Covid19_Tracker
//
//  Created by Hasara Yaddehige on 5/9/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class SugnUpViewController: UIViewController {
    
    

    @IBOutlet weak var FirstName: UITextField!
    
    
    @IBOutlet weak var LastName: UITextField!
    
    @IBOutlet weak var identification_number: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var phi: UITextField!
    
    @IBOutlet weak var district: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var Signup: UIButton!
    
    @IBOutlet weak var error_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }
    //check the fields
   
    
    func ValidateFields() -> String? {
        
        if FirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            LastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill all the fields"
            
        }
        
        let cleaned = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if validPassword(cleaned) == false {
            
            return "Please use a stronger password of 8 characters, which contains special character and a number"
        }
        
        return nil
    }

    
    @IBAction func Signup_tapped(_ sender: Any) {
        
        let error_message = ValidateFields()
           
        if error_message != nil{
            
            error_label.text = error_message!
            error_label.alpha = 1
        }
        else{
            
            let firstName_new = FirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName_new = LastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email_new = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password_new = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phi_new = phi.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let district_new = district.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email_new, password: password_new) { (Result, Error) in
               
                if Error != nil {
//
              
                self.error_label.text = "Error creating a user"

                }
                else{
                    
                    print(firstName_new, lastName_new)
                
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["first" : firstName_new, "last" : lastName_new,"district" :district_new,"phi":phi_new, "uid" : Result!.user.uid]){(Error) in
                        
                        if Error != nil{
                            
                            self.error_label.text = "Error in Connection"
                        }
                }
            
                
                Switcher.updateRootVC()
                let newViewObject = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController //LoginPageViewController is my login view file, and identifier also has the same name.
                self.navigationController?.pushViewController(newViewObject, animated: true)

                }
            
        }
            
          
        
    }
    
    
    }

}

func validPassword(_ password : String) -> Bool{
      
      let testpassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.[a-z])(?=.*[$@#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
      return testpassword.evaluate(with: password)
  }
