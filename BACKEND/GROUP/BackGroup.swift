//
//  BackGroup.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/6/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackGroup{
    var color = Color()
    var helper = Helper()
    var realm = try! Realm()
    var group = try! Realm().objects(RealmGroup)
    var backPhysician = BackPhysician()
    func enumPhysician(success:NSDictionary) -> [RealmPhysician]{
        var physicians = [RealmPhysician]()
        if let array = success.value(forKey: "content") as? NSArray{
            for i in 0..<array.count{
                if let content = array[i] as? NSDictionary{
                    let physician = RealmPhysician()
                    if let ID = content.value(forKey: "_id") as? NSDictionary{
                        if let id = ID.value(forKey: "$id") as? String{
                            physician.id = id
                        }
                    }
                    if let email = content.value(forKey: "email") as? String{
                        physician.email = email
                    }
                    if let firstname = content.value(forKey: "firstname") as? String{
                        physician.name = firstname
                    }
                    if let middlename = content.value(forKey: "middlename") as? String{
                        physician.name = physician.name + " " + middlename
                    }
                    if let lastname = content.value(forKey: "lastname") as? String{
                        physician.name = physician.name + " " + lastname
                    }
                    if let gender = content.value(forKey: "gender") as? String{
                        physician.gender = gender
                    }
                    if let phoneno = content.value(forKey: "phoneno") as? String{
                        physician.telephone = phoneno
                    }
                    if let picurl = content.value(forKey: "picurl") as? String{
                        physician.picurl = picurl
                    }
                    if let userid = content.value(forKey: "userid") as? Int{
                        physician.userid = userid
                    }
                    
                    physicians.append(physician)
                }
            }
        }
        return physicians
    }
    func enumPhysician(success:NSDictionary,group:RealmGroup){
        var physicians = [RealmPhysician]()
        if let array = success.value(forKey: "content") as? NSArray{
            for i in 0..<array.count{
                if let content = array[i] as? NSDictionary{
                    let physician = RealmPhysician()
                    if let ID = content.value(forKey: "_id") as? NSDictionary{
                        if let id = ID.value(forKey: "$id") as? String{
                            physician.id = id
                        }
                    }
                    if let email = content.value(forKey: "email") as? String{
                        physician.email = email
                    }
                    if let firstname = content.value(forKey: "firstname") as? String{
                        physician.name = firstname
                    }
                    if let middlename = content.value(forKey: "middlename") as? String{
                        physician.name = physician.name + " " + middlename
                    }
                    if let lastname = content.value(forKey: "lastname") as? String{
                        physician.name = physician.name + " " + lastname
                    }
                    if let gender = content.value(forKey: "gender") as? String{
                        physician.gender = gender
                    }
                    if let phoneno = content.value(forKey: "phoneno") as? String{
                        physician.telephone = phoneno
                    }
                    if let picurl = content.value(forKey: "picurl") as? String{
                        physician.picurl = picurl
                    }
                    if let userid = content.value(forKey: "userid") as? Int{
                        physician.userid = userid
                    }
                    
                    physicians.append(physician)
                }
            }
        }
    }
    func enumMembers(success:NSDictionary) -> [RealmPhysician]{
        var physicians = [RealmPhysician]()
        if let dic = success.value(forKey: "content") as? NSDictionary{
            if let array = dic.value(forKey: "members") as? NSArray{
                for i in 0..<array.count{
                    if let user = array[i] as? NSDictionary{
                        if let content = user.value(forKey: "user") as? NSDictionary{
                            let physician = RealmPhysician()
                            if let ID = content.value(forKey: "_id") as? NSDictionary{
                                if let id = ID.value(forKey: "$id") as? String{
                                    physician.id = id
                                }
                            }
                            if let email = content.value(forKey: "email") as? String{
                                physician.email = email
                            }
                            if let firstname = content.value(forKey: "firstname") as? String{
                                physician.name = firstname
                            }
                            if let middlename = content.value(forKey: "middlename") as? String{
                                physician.name = physician.name + " " + middlename
                            }
                            if let lastname = content.value(forKey: "lastname") as? String{
                                physician.name = physician.name + " " + lastname
                            }
                            if let gender = content.value(forKey: "gender") as? String{
                                physician.gender = gender
                            }
                            if let phoneno = content.value(forKey: "phoneno") as? String{
                                physician.telephone = phoneno
                            }
                            if let picurl = content.value(forKey: "picurl") as? String{
                                physician.picurl = picurl
                            }
                            if let userid = content.value(forKey: "userid") as? Int{
                                physician.userid = userid
                            }
                            
                            physicians.append(physician)
                        }
                    }
                }
            }
        }
        return physicians
    }
    func collectGroup(success:NSDictionary){
        if let array = success.value(forKey: "content") as? NSArray{
            try! Realm().write {
                for i in 0..<array.count{
                    if let content = array[i] as? NSDictionary{
                        var group = RealmGroup()
                        var idd = ""
                        if let ID = content.value(forKey: "_id") as? NSDictionary{
                            if let id = ID.value(forKey: "$id") as? String{
                                if self.getGroup(id: id) != nil{
                                    group = self.getGroup(id: id)!
                                }
                                group.id = id
                                idd = id
                            }
                        }
                        if let groupname = content.value(forKey: "groupname") as? String{
                            group.groupname = groupname
                        }
                        if let groupname = content.value(forKey: "groupdescription") as? String{
                            group.groupdescription = groupname
                        }
                        if let grouptype = content.value(forKey: "grouptype") as? Int{
                            group.grouptype = grouptype
                        }
                        if let picurl = content.value(forKey: "picurl") as? String{
                            group.picurl = picurl
                            self.helper.saveLocalProfilePic(picurl:picurl, id: group.id)
                        }
                        if let selected = content.value(forKey: "selected") as? Bool{
                            group.didSelect = selected
                        }
                        group.opdtag.removeAll()
                        if let opdtag = content.value(forKey: "opdtag") as? NSArray{
                            for i in 0..<opdtag.count{
                                let tag = RealmStatus()
                                tag.name = opdtag[i] as! String
                                group.opdtag.append(tag)
                            }
                        }
                        if self.getGroup(id: idd) == nil{
                            try! Realm().add(group)
                        }
                    }
                }
            }
        };
    }
    func collectPhysician(success:NSDictionary){
        try! realm.write {
            if let content = success.value(forKey: "content") as? NSDictionary{
                var group = RealmGroup()
                if let ID = content.value(forKey: "_id") as? NSDictionary{
                    if let id = ID.value(forKey: "$id") as? String{
                        if self.getGroup(id: id) != nil{
                            group = self.getGroup(id: id)!
                        }
                        group.id = id
                    }
                }
                if let groupdescription = content.value(forKey: "groupdescription") as? String{
                    group.groupdescription = groupdescription
                }
                if let groupname = content.value(forKey: "groupname") as? String{
                    group.groupname = groupname
                }
                if let grouptype = content.value(forKey: "grouptype") as? Int{
                    group.grouptype = grouptype
                }
                group.opdtag.removeAll()
                if let opdtag = content.value(forKey: "opdtag") as? NSArray{
                    for i in 0..<opdtag.count{
                        let tag = RealmStatus()
                        tag.name = opdtag[i] as! String
                        group.opdtag.append(tag)
                    }
                }
                group.physicians.removeAll()
                if let members = content.value(forKey: "members") as? NSArray{
                    for i in 0..<members.count{
                        var groupMember = RealmGroupMember()
                        if let member = members[i] as? NSDictionary{
                            var idd = ""
                            if let ID = member.value(forKey: "_id") as? NSDictionary{
                                if let id = ID.value(forKey: "$id") as? String{
                                    if self.backPhysician.getPhysician(id: id) != nil{
                                        groupMember = self.findGroupMember(id: id)!
                                    }
                                    groupMember.id = id
                                    idd = id
                                }
                            }
                            if let approvebyuserid = member.value(forKey: "approvebyuserid") as? String{
                                groupMember.approvebyuserid = approvebyuserid
                            }
                            if let approvetime = member.value(forKey: "approvetime") as? String{
                                groupMember.approvetime = self.helper.StringToDate(date: approvetime)
                            }
                            if let groupdocid = member.value(forKey: "groupdocid") as? String{
                                groupMember.groupdocid = groupdocid
                            }
                            if let invitebyuserid = member.value(forKey: "invitebyuserid") as? String{
                                groupMember.invitebyuserid = invitebyuserid
                            }
                            if let invitetime = member.value(forKey: "invitetime") as? String{
                                groupMember.invitetime = self.helper.StringToDate(date: invitetime)
                            }
                            if let requesttime = member.value(forKey: "requesttime") as? String{
                                groupMember.requesttime = self.helper.StringToDate(date: requesttime)
                            }
                            if let role = member.value(forKey: "role") as? String{
                                groupMember.role = role
                            }
                            if let user = member.value(forKey: "user") as? NSDictionary{
                                var physician = RealmPhysician()
                                var iddd = ""
                                if let ID = user.value(forKey: "_id") as? NSDictionary{
                                    if let id = ID.value(forKey: "$id") as? String{
                                        if self.backPhysician.getPhysician(id: id) != nil{
                                            physician = self.backPhysician.getPhysician(id: id)!
                                        }
                                        groupMember.physicianid = id
                                        physician.id = id
                                        iddd = id
                                    }
                                    if let email = user.value(forKey: "email") as? String{
                                        physician.email = email
                                    }
                                    if let firstname = user.value(forKey: "firstname") as? String{
                                        physician.name = firstname
                                    }
                                    if let gender = user.value(forKey: "gender") as? String{
                                        physician.gender = gender
                                    }
                                    physician.groupid.removeAll()
                                    if let groupids = user.value(forKey: "groupids") as? NSArray{
                                        for i in 0..<groupids.count{
                                            if let id = groupids[i] as? String{
                                                var groupArray = RealmGroupArray()
                                                groupArray.groupid = id
                                                physician.groupid.append(groupArray)
                                            }
                                        }
                                    }
                                    if let lastname = user.value(forKey: "lastname") as? String{
                                        physician.name = physician.name + " " + lastname
                                    }
                                    if let phoneno = user.value(forKey: "phoneno") as? String{
                                        physician.phoneno = phoneno
                                    }
                                    if let picurl = user.value(forKey: "picurl") as? String{
                                        physician.picurl = picurl
                                        self.helper.saveLocalProfilePic(picurl: picurl, id: physician.id)
                                    }
                                    if let userid = user.value(forKey: "userid") as? Int{
                                        physician.userid = userid
                                    }
                                    if self.backPhysician.getPhysician(id: physician.id) == nil{
                                        try! realm.add(physician)
                                    }
                                }
                            }
                            group.physicians.append(groupMember)
                        }
                    }
                }
                if self.getGroup(id: group.id) == nil{
                    try! realm.add(group)
                }
            }
        }
    }
    func enumMyGroup(success:NSDictionary) -> [Group]{
        var groups = [Group]()
        if let array = success.value(forKey: "content") as? NSArray{
            for i in 0..<array.count{
                if let content = array[i] as? NSDictionary{
                    var group = Group()
                    if let ID = content.value(forKey: "_id") as? NSDictionary{
                        if let id = ID.value(forKey: "$id") as? String{
                            group.id = id
                        }
                    }
                    if let groupname = content.value(forKey: "groupname") as? String{
                        group.groupname = groupname
                    }
                    if let groupname = content.value(forKey: "groupdescription") as? String{
                        group.groupdescription = groupname
                    }
                    if let grouptype = content.value(forKey: "grouptype") as? Int{
                        group.grouptype = grouptype
                    }
                    if let picurl = content.value(forKey: "picurl") as? String{
                        group.picurl = picurl
                    }
                    groups.append(group)
                }
            }
        }
        return groups
    }
    func enumCoverCusForm(json:NSDictionary) -> [CustomForm]{
        var cusForm = [CustomForm]()
        if let array = json.value(forKey: "content") as? NSArray{
            for i in 0..<array.count{
                if let content = array[i] as? NSDictionary{
                    let form = CustomForm()
                    if let cusID = (content.value(forKey: "_id") as! NSDictionary).value(forKey: "$id") as? String{
                        form.id = cusID
                    }
                    if let title = content.value(forKey: "name") as? String{
                        form.title = title
                    }
                    if let des = content.value(forKey: "description") as? String{
                        form.des = des
                    }
                    if let title = content.value(forKey: "name") as? String{
                        form.title = title
                    }
                    if let color = content.value(forKey: "color") as? String{
                        form.color = self.color.frontEndColor(color: color)
                    }
                    if let icon = content.value(forKey: "picurl") as? String{
                        form.icon = icon
                    }
                    if let formula = content.value(forKey: "formula") as? NSArray{
                        for i in 0..<formula.count{
                            let f = CustomFormFormula()
                            f.formula = formula[i] as! String
                            form.formula.append(f)
                        }
                    }
                    if let updateTime = content.value(forKey: "updatetime") as? String{
                        form.updateTime = self.helper.StringToDate(date: updateTime)
                    }
                    if let owneruserid = content.value(forKey: "owneruserid") as? String{
                        form.owneruserid = owneruserid
                    }
                    if let perm = content.value(forKey: "perm") as? String{
                        form.perm = perm
                    }
                    cusForm.append(form)
                    
                }
                
            }
        }
        return cusForm
    }
    func initStatus(success:NSDictionary){
        try! Realm().write {
            realm.delete(realm.objects(RealmStatus.self))
            if let array = success.value(forKey: "content") as? NSArray{
                for i in 0..<array.count{
                    let status = RealmStatus()
                    if let name = array[i] as? String{
                        status.name = name
                    }
                    if i == 0{
                        status.color = self.color.flatRedLight
                    }else if i == 1{
                        status.color = self.color.flatGreenLight
                    }else if i == 2{
                        status.color = self.color.flatYellowDark
                    }else{
                        status.color = self.color.flatBlackDark
                    }
                    realm.add(status)
                }
            }
        }
    }
    func findGroupMember(id:String) -> RealmGroupMember?{
        return try! realm.objects(RealmGroupMember.self).filter(NSPredicate(format:"id == %@",id)).first
    }
    func getGroup(id:String) ->RealmGroup?{
        return try! Realm().objects(RealmGroup.self).filter(NSPredicate(format: "id == %@", id)).first
    }
}
