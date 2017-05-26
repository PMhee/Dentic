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
    var physicians = List<RealmGroupMember>()
    var customform = List<CustomForm>()
    var opdtag = List<RealmStatus>()
}
class RealmGroupMember:Object{
    dynamic var id : String = ""
    dynamic var approvebyuserid : String = ""
    dynamic var approvetime : Date!
    dynamic var groupdocid : String = ""
    dynamic var invitebyuserid : String = ""
    dynamic var invitetime : Date!
    dynamic var requesttime : Date!
    dynamic var role : String = ""
    dynamic var physicianid : String = ""
}
class RealmGroupArray:Object{
    dynamic var groupid : String = ""
}
