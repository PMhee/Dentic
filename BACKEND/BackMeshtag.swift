//
//  BackMeshtag.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/15/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackMeshtag{
    func downloadMeshtag(success:NSDictionary){
        try! Realm().write{
            if let array = success.value(forKey: "content") as? NSArray{
                for i in 0..<array.count{
                    if let content = array[i] as? NSDictionary{
                        if let name = content.value(forKey: "name") as? String{
                            if self.findMeshtag(id: name) == nil{
                                var mt = RealmMeshtag()
                                mt.tag = name
                                try! Realm().add(mt)
                            }
                        }
                    }
                }
            }
        }
    }
    func findMeshtag(id:String) ->RealmMeshtag?{
        return try! Realm().objects(RealmMeshtag.self).filter(NSPredicate(format: "tag == %@", id)).first
    }
    func getMeshtag(id:String) -> Results<RealmMeshtag>{
        return try! Realm().objects(RealmMeshtag.self).filter(NSPredicate(format: "tag contains[c] %@", id))
    }
}
