//
//  RealmGroup.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/15/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class RealmGroup:Object{
    dynamic var groupname : String = ""
    dynamic var id : String = ""
    dynamic var picurl : String = ""
    dynamic var groupdescription : String = ""
    dynamic var grouptype : Int = 0
    dynamic var didSelect : Bool = true
    var physicians = List<RealmPhysician>()
    var customform = List<CustomForm>()
    var opdtag = List<RealmStatus>()
}
