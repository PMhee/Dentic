//
//  BackRepresent.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/15/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackRepresent{
    var realm = try! Realm()
    func findHashtag(tag:String) ->Results<MeshTag>{
        return realm.objects(MeshTag.self).filter(NSPredicate(format: "tag contains[c] %@ And followupid != %@", tag,""))
    }
    func getFollowupByID(id:String) ->RealmFollowup{
        return realm.objects(RealmFollowup.self).filter(NSPredicate(format: "id == %@", id)).first!
    }
}
