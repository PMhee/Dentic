//
//  GroupHomeViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 5/19/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class GroupHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    struct Setting {
        var title : String = ""
        var des : String = ""
        var pic : String = ""
    }
    var animation = UIViewAnimation()
    var patients = try! Realm().objects(RealmPatient.self)
    var sidebarState = 0
    var helper = Helper()
    var group = RealmGroup()
    var back = BackPatient()
    var api = APIGroup()
    var backSystem = BackSystem()
    var backGroup = BackGroup()
    var backPhysician = BackPhysician()
    var setting_group = [Setting]()
    var index = 0
    
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var img_add: UIImageView!
    
    @IBAction func btn_add_action(_ sender: UIButton) {
        if self.sidebarState == 0 {
            let storyboard = UIStoryboard(name: "SearchGroupMember", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchGroupMember") as! SearchGroupMemberViewController
            let navigationController = UINavigationController(rootViewController: vc)
            vc.groupid = self.group.id
            vc.group = self.group
            navigationController.navigationBar.barTintColor = UIColor(netHex:0xB798B1)
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
            self.present(navigationController, animated: true, completion: nil)
        }else{
            self.performSegue(withIdentifier: "add_patient", sender: self)
        }
    }
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet var gesture: UIGestureRecognizer!
    @IBOutlet weak var vw_change_name: UIView!
    @IBOutlet weak var tf_group_name: UITextField!
    @IBOutlet weak var tf_group_description: UITextField!
    @IBAction func btn_confirm_action(_ sender: UIButton) {
        self.animation.animateBotToTop(view: self.vw_change_name, y: -220, duration: 0.5, success: {(success) in
            self.vw_filter.isHidden = true
        })
        self.tf_group_description.resignFirstResponder()
        self.tf_group_name.resignFirstResponder()
        self.api.editGroupName(groupname: self.tf_group_name.text!, groupdescription: self.tf_group_description.text!, groupid: self.group.id, success: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                if let groupname = content.value(forKey: "groupname") as? String{
                    self.lb_group_name.text = groupname
                }
                if let groupdescription = content.value(forKey: "groupdescription") as? String{
                    self.lb_group_description.text = groupdescription
                }
            }
        }, failure: {(error) in
        })
    }
    
    
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var btn_patient: UIButton!
    @IBOutlet weak var btn_member: UIButton!
    @IBOutlet weak var lb_patients_number: UILabel!
    @IBOutlet weak var lb_members_number: UILabel!
    @IBOutlet weak var lb_group_description: UILabel!
    @IBOutlet weak var lb_group_name: UILabel!
    @IBOutlet weak var img_icon_group: UIImageView!
    @IBOutlet weak var btn_setting: UIButton!
    @IBOutlet weak var lb_title: UILabel!
    
    @IBAction func btn_setting_action(_ sender: UIButton) {
        self.sidebarState = 2
        self.btn_member.backgroundColor = UIColor(netHex: 0xECECEC)
        self.btn_patient.backgroundColor = UIColor(netHex: 0xECECEC)
        self.btn_setting.backgroundColor = UIColor.white
        self.lb_title.text = "Setting"
        self.tableView.reloadData()
        self.btn_add.isHidden = true
        self.img_add.isHidden = true
    }
    @IBAction func btn_member_action(_ sender: UIButton) {
        self.sidebarState = 0
        self.btn_member.backgroundColor = UIColor.white
        self.btn_patient.backgroundColor = UIColor(netHex: 0xECECEC)
        self.btn_setting.backgroundColor = UIColor(netHex: 0xECECEC)
        self.tableView.reloadData()
        self.lb_title.text = "Member"
        self.btn_add.isHidden = false
        self.img_add.isHidden = false
    }
    @IBAction func btn_patient_action(_ sender: UIButton) {
        self.sidebarState = 1
        self.btn_patient.backgroundColor = UIColor.white
        self.btn_member.backgroundColor = UIColor(netHex: 0xECECEC)
        self.btn_setting.backgroundColor = UIColor(netHex: 0xECECEC)
        self.tableView.reloadData()
        self.lb_title.text = "Patient"
        self.btn_add.isHidden = false
        self.img_add.isHidden = false
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.img_icon_group.layer.cornerRadius = 40
        self.img_icon_group.layer.masksToBounds = true
        self.setSetting()
        self.act.isHidden = true
        self.act.startAnimating()
        self.view.addGestureRecognizer(self.gesture)
        // Do any additional setup after loading the view.
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !self.vw_change_name.isHidden{
            if self.helper.inBound(x: touch.location(in: self.vw_change_name).x, y: touch.location(in: self.vw_change_name).y, view: self.vw_change_name){
                return false
            }else{
                self.animation.animateBotToTop(view: self.vw_change_name, y: -230, duration: 0.5, success: {(success) in
                    self.vw_filter.isHidden = true
                })
                return true
            }
        }else{
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func setSetting(){
        var set1 = Setting()
        set1.title = "Group Name"
        set1.des = "Change the group name and group description"
        set1.pic = "group-setting-name.png"
        self.setting_group.append(set1)
        var set2 = Setting()
        set2.title = "Group Picture"
        set2.des = "Change the group picture"
        set2.pic = "group-setting-pic.png"
        self.setting_group.append(set2)
        //        var set3 = Setting()
        //        set3.title = "Group OPD Tag"
        //        set3.des = "Change the group opd tag for using as patient tag"
        //        set3.pic = "group-setting-tag.png"
        //        self.setting_group.append(set3)
        var set4 = Setting()
        set4.title = "Leave Group"
        set4.des = "Leave from this group"
        set4.pic = "group-setting-leave.png"
        //self.setting_group.append(set4)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.helper.loadLocalProfilePic(id: self.group.id, image: self.img_icon_group)
        self.patients = self.back.getPatientFromGroup(id: self.group.id)
        self.patients = self.patients.sorted(byProperty: "name",ascending:true)
        self.tableView.reloadData()
        self.lb_members_number.text = String(self.group.physicians.count)
        self.lb_patients_number.text = String(self.patients.count)
        self.lb_group_name.text = self.group.groupname
        self.lb_group_description.text = self.group.groupdescription
        self.btn_add.layer.cornerRadius = 25
        self.btn_add.layer.masksToBounds = true
        self.api.listMemberInGroup(sessionid: self.backSystem.getSessionid(), groupid: self.group.id, success: {(success) in
            self.backGroup.collectPhysician(success: success)
            self.lb_members_number.text = String(self.group.physicians.count)
            if self.sidebarState == 0{
                self.tableView.reloadData()
            }
        }, failure: {(error) in
            print(error)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = UIImage()
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.vw_filter.isHidden = false
        self.act.isHidden = false
        self.act.startAnimating()
        self.api.uploadGrPic(groupdocid: self.group.id, image: image, success: {(success) in
            self.act.isHidden = true
            self.vw_filter.isHidden = true
            self.img_icon_group.image = image
        }, failure: {(error) in
            
        })
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.sidebarState == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let pic = cell.viewWithTag(1) as! UIImageView
            let lb = cell.viewWithTag(2) as! UILabel
            let hn = cell.viewWithTag(3) as! UILabel
            self.helper.loadLocalProfilePic(id: self.patients[indexPath.row].localid, image: pic)
            lb.text = self.patients[indexPath.row].name
            hn.text = self.patients[indexPath.row].HN
            hn.isHidden = false
            pic.layer.cornerRadius = 20
            pic.layer.masksToBounds = true
            return cell
        }else if self.sidebarState == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "setting", for: indexPath)
            let pic = cell.viewWithTag(1) as! UIImageView
            let lb = cell.viewWithTag(2) as! UILabel
            let hn = cell.viewWithTag(3) as! UILabel
            lb.text = self.setting_group[indexPath.row].title
            hn.text = self.setting_group[indexPath.row].des
            pic.image = UIImage(named:self.setting_group[indexPath.row].pic)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let pic = cell.viewWithTag(1) as! UIImageView
            let lb = cell.viewWithTag(2) as! UILabel
            let hn = cell.viewWithTag(3) as! UILabel
            self.helper.loadLocalProfilePic(id: self.group.physicians[indexPath.row].physicianid, image: pic)
            lb.text = self.backPhysician.getPhysician(id: self.group.physicians[indexPath.row].physicianid)?.name
            hn.text = self.group.physicians[indexPath.row].role
            pic.layer.cornerRadius = 20
            pic.layer.masksToBounds = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.sidebarState == 2{
            if indexPath.row == 0{
                self.vw_filter.isHidden = false
                self.animation.animateTopToBot(view: self.vw_change_name, y: 230, duration: 1, success: {(success) in
                    
                })
                self.tf_group_name.text = self.lb_group_name.text!
                self.tf_group_description.text = self.lb_group_description.text!
            }else if indexPath.row == 1{
                self.openGallery()
            }else if indexPath.row == 2{
                //                self.vw_filter.isHidden = false
                //                self.stepper.value = Double(self.segment_opdtag.numberOfSegments)
                //                if self.segment_opdtag.numberOfSegments > 0 {
                //                    self.tf_opdtag.text = self.segment_opdtag.titleForSegment(at: 0)
                //                }
                //                self.animation.animateTopToBot(view: self.vw_opdtag_edit, y: 240, duration: 1, success: {(success) in
                //                })
            }else if indexPath.row == 3{
                
            }
        }else if self.sidebarState == 1{
            self.index = indexPath.row
            self.performSegue(withIdentifier: "patient", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.sidebarState == 2{
            return false
        }else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if self.sidebarState == 0{
                self.api.deleteMember(sessionid: self.backSystem.getSessionid(), groupid: self.group.id, userid: (self.backPhysician.getPhysician(id: self.group.physicians[indexPath.row].physicianid)?.userid)! , success: {(success) in
                    print(success)
                }, failure: {(error) in
                
                })
            }else{
                
            }
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sidebarState == 1{
            return self.patients.count
        }else if self.sidebarState == 2{
            return self.setting_group.count
        }else{
            return self.group.physicians.count
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "patient" {
            if let des = segue.destination as? DentistClinicalViewController{
                des.patient = self.patients[self.index]
            }
        }else if segue.identifier == "add_patient"{
            if let des = segue.destination as? PatientProfileViewController{
                des.isCreate = true
                des.groupName = self.group.groupname
                des.groupID = self.group.id
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
