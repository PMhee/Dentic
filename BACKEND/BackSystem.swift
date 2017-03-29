//
//  BackSystem.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/16/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
class BackSystem{
    let realm = try! Realm()
    func collectLoginUser(success:NSDictionary){
        try! realm.write {
            let physician = RealmPhysician()
            if let sessionid = success.value(forKey: "content") as? String{
                physician.sessionid = sessionid
            }
            if realm.objects(RealmPhysician.self).count == 0{
                realm.add(physician)
            }else{
                realm.objects(RealmPhysician.self).first?.sessionid = physician.sessionid
            }
        }
    }
    func getSessionid() -> String{
        return (realm.objects(RealmPhysician.self).first?.sessionid)!
    }
}
