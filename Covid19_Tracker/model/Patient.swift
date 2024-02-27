//
//  Patient.swift
//  Covid19_Tracker
//
//  Created by Harshana Rathnamalala on 6/3/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//

import Foundation
import RealmSwift

class Patient: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var nic: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var qrId: String = ""
    @objc dynamic var latitude: String = ""
    @objc dynamic var longitide: String = ""
    @objc dynamic var dateCreated: Date?
    let remarks = List<Remark>()

}
