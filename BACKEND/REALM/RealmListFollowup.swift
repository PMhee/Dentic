//
//  RealmListFollowup.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/3/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class RealmListFollowup:Object{
    var followup = List<RealmFollowup>()
    dynamic var date : Date!
    dynamic var patient : RealmPatient!
}
