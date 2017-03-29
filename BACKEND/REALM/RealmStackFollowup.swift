//
//  RealmStack.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/7/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class RealmStackFollowup:Object{
    var meshtag = List<MeshTag>()
    dynamic var followup : RealmFollowup!
    dynamic var patientid : String = ""
    dynamic var isUpdate = false
}
