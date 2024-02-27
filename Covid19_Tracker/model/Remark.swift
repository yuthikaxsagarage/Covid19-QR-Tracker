//
//  Remark.swift
//  Covid19_Tracker
//
//  Created by Harshana Rathnamalala on 6/3/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//

import Foundation
import RealmSwift

class Remark: Object {
    @objc dynamic var remark: String = ""
    @objc dynamic var dateCreated: Date?
    var parentPatient = LinkingObjects(fromType: Patient.self, property: "remarks")
}
