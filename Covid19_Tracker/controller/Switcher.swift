//
//  Switcher.swift
//  Covid19_Tracker
//
//  Created by Hasara Yaddehige on 6/1/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//


import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        
        var rootVC : UIViewController?
        
        print(variable.status)
        
        
        if(variable.status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainvc") as! mainViewController
            
       
            
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
}

struct variable {
    static var status = false
}
