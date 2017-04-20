//
//  RecentPatientViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/17/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class PatientViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITabBarControllerDelegate,UIGestureRecognizerDelegate {
    var ui = UITable()
    var uiLoading = UILoading()
    var api = APIPatient()
    var apiPhysician = APIPhysician()
    var backSystem = BackSystem()
    var back = BackPatient()
    var helper = Helper()
    var patients = try! Realm().objects(RealmPatient.self)
    var color = Color()
    var isDownloading = false
    var isLoading = false
    var isNew = false
    var index = 0
    var json = try! Realm().objects(RealmJSON.self)
    //var pat = try! Realm().objects(RealmPatient.self)
    var inGroup = false
    var apiGroup = APIGroup()
    var group = try! Realm().objects(RealmGroup.self)
    var backGroup = BackGroup()
    var listGroup = [String]()
    var selectionGroup = [String]()
    
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var btn_add_patient: UIButton!
    @IBOutlet weak var vw_filter_download: UIView!
    @IBOutlet weak var act_group: UIActivityIndicatorView!
    @IBOutlet weak var tableViewGroup: UITableView!
    @IBOutlet weak var vw_group: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var vw_new_record: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBAction func btn_newRecord_action(_ sender: UIButton) {
        self.vw_new_record.isHidden = true
        self.isNew = true
        self.act.isHidden = false
        self.act.startAnimating()
        self.loadUpdatedRecent()
        self.tableView.contentOffset.y = -64
    }
    
    @IBAction func btn_add_patient(_ sender: UIButton) {
        self.performSegue(withIdentifier: "add", sender: self)
    }
    @IBAction func btn_group_action(_ sender: UIBarButtonItem) {
        self.vw_group.isHidden = false
        self.vw_filter.isHidden = false
        self.inGroup = true
        self.selectionGroup = [String]()
        //        self.apiGroup.listMyGroup(sessionid: self.backSystem.getSessionid(), success: {(success) in
        //            self.backGroup.collectGroup(success: success)
        //            self.listGroup = [String]()
        //            for i in 0..<self.group.count{
        //                if self.group[i].didSelect{
        //                    self.listGroup.append(self.group[i].id)
        //                }else{
        //                    self.listGroup.append("xxx")
        //                }
        //            }
        //
        //            self.tableViewGroup.reloadData()
        //        }, failure: {(error) in
        //
        //        })
        self.tableViewGroup.reloadData()
    }
    
    @IBAction func btn_select_action(_ sender: UIButton) {
        self.vw_filter.isHidden = false
        self.act_group.isHidden = false
        self.act_group.startAnimating()
        self.vw_filter_download.isHidden = false
        for i in 0..<self.listGroup.count{
            if self.listGroup[i] != "xxx"{
                self.selectionGroup.append(self.listGroup[i])
            }
        }
        var closeEnable = true
        for i in 0..<self.selectionGroup.count{
            if !self.back.searchAvailablePatientGroup(id: self.selectionGroup[i]){
                closeEnable = false
                self.apiGroup.listPatientInGroup(sessionid: self.backSystem.getSessionid(), groupid: self.selectionGroup[i], success: {(success) in
                    self.back.loadPatientDataFromGroup(success: success)
                    self.vw_filter.isHidden = true
                    self.act_group.isHidden = true
                    self.vw_group.isHidden = true
                    self.vw_filter_download.isHidden = true
                    self.patients = self.back.sortPatientByName()
                    self.tableView.reloadData()
                }, failure: {(error) in
                    print(error)
                })
            }else if i==self.selectionGroup.count-1 && closeEnable{
                self.vw_filter.isHidden = true
                self.act_group.isHidden = true
                self.vw_group.isHidden = true
                self.vw_filter_download.isHidden = true
                self.patients = self.back.sortPatientByName()
                self.tableView.reloadData()
            }
        }
        if selectionGroup.count == 0 {
            self.vw_filter.isHidden = true
            self.act_group.isHidden = true
            self.vw_group.isHidden = true
            self.vw_filter_download.isHidden = true
            self.patients = self.back.sortPatientByName()
            self.tableView.reloadData()
            
        }
        self.apiPhysician.updatePatientGroup(sessionid: self.backSystem.getSessionid(), groupids: self.listGroup, success: {(success) in
            
        }, failure: {(error) in
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        self.act.isHidden = true
        self.setUI()
        self.view.addGestureRecognizer(self.gesture)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollTop), name: NSNotification.Name("patientTabbar"), object: nil)
        // Do any additional setup after loading the view.
    }
    func scrollTop(notification:NSNotification){
        if tableView.numberOfRows(inSection: 0) != 0 {
            self.tableView.scrollToRow(at: IndexPath(row:0,section:0), at: .top, animated: true)
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.inGroup{
            if self.helper.inBound(x: touch.location(in: self.vw_group).x, y: touch.location(in: self.vw_group).y, view: self.vw_group){
                return false
            }else{
                self.vw_group.isHidden = true
                self.vw_filter.isHidden = true
                self.inGroup = false
                return true
            }
        }else{
            return false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.act_group.isHidden = true
        self.patients = self.back.sortPatientByName()
        self.tableView.reloadData()
        self.listGroup = [String]()
        for i in 0..<self.group.count{
            if self.group[i].didSelect{
                self.listGroup.append(self.group[i].id)
            }else{
                self.listGroup.append("xxx")
            }
        }
        //self.loadUpdatedRecent()
        //        self.api.listUpdatedRecents(sessionid: self.backSystem.getSessionid(), updatetime: self.helper.dateToString(date: self.patients[0].lastfuupdatetime) , success: {(success) in
        //            if let array = success.value(forKey: "content") as? NSArray{
        //                self.vw_new_record.isHidden = false
        //            }
        //        }, failure: {(error) in
        //
        //        })
        //        if json.count == 0{
        //            self.loadNewRecent()
        //        }else{
        //            if self.back.getRecentString() == ""{
        //                self.loadNewRecent()
        //            }else{
        //                self.setTable()
        //                self.api.listUpdatedRecents(sessionid: self.backSystem.getSessionid(), updatetime: self.back.getLastFuDate(json: self.back.getRecentDic(jsonString: self.back.getRecentString())) , success: {(success) in
        //                    self.back.loadPatientData(dic: success)
        //                    if self.back.isUpdatedRecentPatient(dic: success){
        //                        self.vw_new_record.isHidden = false
        //                    }
        //                }, failure: {(error) in
        //                    print(error)
        //                    self.uiLoading.showErrorNav(error: "Internet connection problem", view: self.view)
        //                })
        //            }
        //        }
    }
    func loadNewRecent(){
        self.act.isHidden = false
        self.act.startAnimating()
        self.api.searchRecents(sessionid: self.backSystem.getSessionid(), success: {(success) in
            self.back.loadPatientData(dic: success)
            self.act.isHidden = true
            self.back.recentPatientJSON(dic: success)
        }, failure: {(error) in
            print(error)
            self.uiLoading.showErrorNav(error: "Internet connection problem", view: self.view)
            self.act.isHidden = true
        })
    }
    func loadUpdatedRecent(){
        if self.patients.count > 0 {
            self.api.listUpdatedRecents(sessionid: self.backSystem.getSessionid(), updatetime: self.helper.dateToString(date: self.patients[0].lastfuupdatetime) , success: {(success) in
                self.back.loadPatientData(dic: success)
                self.back.sortPatientByName()
                self.tableView.reloadData()
                self.vw_new_record.isHidden = true
                self.tableView.contentOffset.y = 0
                self.act.isHidden = true
            }, failure: {(error) in
                
            })
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        if self.helper.isConnectedToNetwork(){
        //            if scrollView.contentOffset.y <= -100{
        //                self.isDownloading = true
        //                self.act.isHidden = false
        //                self.act.startAnimating()
        //                if !self.isLoading{
        //                    self.loadUpdatedRecent()
        //                }
        //            }
        //            if self.isDownloading{
        //                if scrollView.contentOffset.y >= -100{
        //                    scrollView.contentOffset.y = -100
        //                }
        //            }
        //        }
    }
    func setUI(){
        self.vw_new_record.layer.cornerRadius = 15
        self.vw_new_record.layer.masksToBounds = true
        self.ui.shadow(vw_layout: self.vw_new_record)
        self.btn_add_patient.layer.cornerRadius = 25
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return self.group.count
        }else{
            return self.patients.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "group", for: indexPath)
            let img_group = cell.viewWithTag(1) as! UIImageView
            let lb_group_name = cell.viewWithTag(2) as! UILabel
            let lb_tick = cell.viewWithTag(3) as! UILabel
            lb_group_name.text = self.group[indexPath.row].groupname
            lb_tick.isHidden = true
            if self.group[indexPath.row].didSelect{
                lb_tick.isHidden = false
            }
            //            for i in 0..<self.listGroup.count{
            //                if self.listGroup[i] == self.group[indexPath.row].id{
            //                    lb_tick.isHidden = false
            //                    break
            //                }
            //            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecentPatientTableViewCell
            self.ui.shadow(vw_layout: cell.vw_layout)
            self.helper.loadLocalProfilePic(id: self.patients[indexPath.row].localid,image:cell.img_profile)
            cell.img_profile.layer.cornerRadius = 2
            cell.img_profile.layer.masksToBounds = true
            cell.lb_name.text = self.patients[indexPath.row].name
            cell.lb_HN.text = self.patients[indexPath.row].HN
            cell.lb_gender_age.text = self.patients[indexPath.row].gender+" "+self.patients[indexPath.row].age
            if self.patients[indexPath.row].group?.groupname != nil{
                cell.lb_group.text = self.patients[indexPath.row].group?.groupname
            }else{
                //cell.lb_group.text = self.patients[indexPath.row].group.groupname
            }
            if self.patients[indexPath.row].lastfuupdatetime != nil{
                cell.lb_lastfudate.text = self.helper.showDate(date: self.patients[indexPath.row].lastfuupdatetime)
            }else{
                cell.lb_lastfudate.text = ""
            }
            if self.patients[indexPath.row].status == ""{
                cell.lb_status.text = ""
            }else{
                cell.lb_status.text = self.patients[indexPath.row].status
            }
            cell.lb_meshtag.text = ""
            for i in 0..<self.patients[indexPath.row].meshtag.count{
                if i == 0 {
                    cell.lb_meshtag.text = cell.lb_meshtag.text!+"#"+self.patients[indexPath.row].meshtag[i].tag
                }else{
                    cell.lb_meshtag.text = cell.lb_meshtag.text!+"\n"+"#"+self.patients[indexPath.row].meshtag[i].tag
                }            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            try! Realm().write {
                self.group[indexPath.row].didSelect = !self.group[indexPath.row].didSelect
            }
            if self.listGroup[indexPath.row] == "xxx"{
                self.listGroup[indexPath.row] = self.group[indexPath.row].id
            }else{
                self.listGroup[indexPath.row] = "xxx"
            }
            self.tableViewGroup.reloadData()
        }else{
            self.index = indexPath.row
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: "select", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select"{
            if let des = segue.destination as? DentistClinicalViewController{
                des.patient = self.back.findPatient(id: self.patients[self.index].localid).first!
                des.isFirst = true
            }
        }else if segue.identifier == "add"{
            if let des = segue.destination as? PatientProfileViewController{
                des.isCreate = true
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
