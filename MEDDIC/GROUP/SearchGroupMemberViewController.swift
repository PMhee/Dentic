//
//  SearchUIViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 5/14/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class SearchGroupMemberViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    var MAX_HEIGHT : CGFloat = 0
    var listSearchPatient = [RealmPatient]()
    var helper = Helper()
    var index = 0
    var api = APIGroup()
    var groupid : String = ""
    var system = BackSystem()
    var back = BackGroup()
    var members = [RealmPhysician]()
    var selected_members = [RealmPhysician]()
    var inSelected = false
    var group = RealmGroup()
    var backPhysician = BackPhysician()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cons_height: NSLayoutConstraint!
    @IBOutlet weak var tf_search: UITextField!
    
    @IBOutlet weak var btn_doctor: UIButton!
    @IBAction func btn_cancel_action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var btn_invited: UIButton!
    @IBAction func btn_invited_action(_ sender: UIButton) {
        self.inSelected = true
        self.tableView.reloadData()
        self.btn_invited.setTitleColor(UIColor.black, for: .normal)
        self.btn_doctor.setTitleColor(UIColor.lightGray, for: .normal)
    }
    @IBAction func btn_doctor_action(_ sender: UIButton) {
        self.inSelected = false
        self.tableView.reloadData()
        self.btn_invited.setTitleColor(UIColor.lightGray, for: .normal)
        self.btn_doctor.setTitleColor(UIColor.black, for: .normal)
    }
    @IBAction func tf_search_change(_ sender: UITextField) {
        self.api.listPhysician(keyword: sender.text!, sessionid: system.getSessionid(), success: {(success) in
            self.members = self.back.enumPhysician(success: success)
            self.tableView.reloadData()
        }, failure: {(error) in
            
        })
        //self.listAllPatient = self.back.getListPatient(name: sender.text!, hn: sender.text!)
        
    }
    @IBAction func btn_done_action(_ sender: UIBarButtonItem) {
        for i in 0..<self.selected_members.count{
        self.api.addMember(sessionid: self.system.getSessionid(), groupid: self.groupid, userid:self.selected_members[i].userid , role: "member", success: {(success) in
            if i == self.selected_members.count-1{
                self.dismiss(animated: true, completion: nil)
            }
        }, failure: {(error) in
        
        })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        for i in 0..<self.group.physicians.count{
            self.selected_members.append(self.backPhysician.getPhysician(id: (self.group.physicians[i].physicianid))!)
        }
        self.tableView.reloadData()
        self.btn_invited.setTitle("Invited(\(self.selected_members.count))", for: .normal)
        // Do any additional setup after loading the view.s
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.layoutIfNeeded()
            self.cons_height.constant = self.view.frame.height - 114 - keyboardSize.height
            //self.cons_height_searchMeshtag.constant = self.MAX_SEARCH_MESHTAG
            //self.cons_tableView_meshtag.constant = self.MAX_SEARCH_MESHTAG
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tf_search.becomeFirstResponder()
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tf_search.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.cons_height.constant = self.view.frame.height - 114
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.inSelected{
            return self.selected_members.count
        }else{
            if self.tf_search.text == ""{
                return 0
            }else{
                return self.members.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        let lb_name = cell.viewWithTag(2) as! UILabel
        let lb_tick = cell.viewWithTag(3) as! UILabel
        img.layer.cornerRadius = 18
        img.layer.masksToBounds = true
        if self.inSelected{
            lb_tick.isHidden = true
            self.helper.downloadImageFrom(link: self.selected_members[indexPath.row].picurl, contentMode: .scaleAspectFill, img: img)
            lb_name.text = self.selected_members[indexPath.row].name
        }else{
            self.helper.downloadImageFrom(link: self.members[indexPath.row].picurl, contentMode: .scaleAspectFill, img: img)
            lb_name.text = self.members[indexPath.row].name
            var found = false
            for i in 0..<self.selected_members.count{
                if self.members[indexPath.row].id == self.selected_members[i].id{
                    found = true
                    break
                }
            }
            if found{
                lb_tick.isHidden = false
            }else{
                lb_tick.isHidden = true
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cons_height.constant = self.view.frame.height - 114
        self.index = indexPath.row
        self.tf_search.resignFirstResponder()
        if self.inSelected{
            self.selected_members.remove(at: indexPath.row)
            self.btn_invited.setTitle("Invited(\(self.selected_members.count))", for: .normal)
            self.tableView.reloadData()
        }else{
            var found = false
            var idx = 0
            for i in 0..<self.selected_members.count{
                if self.selected_members[i].id == self.members[indexPath.row].id{
                    found = true
                    idx = i
                    break
                }
            }
            if found{
                self.selected_members.remove(at: idx)
                self.tableView.reloadData()
                self.btn_invited.setTitle("Invited(\(self.selected_members.count))", for: .normal)
            }else{
                self.selected_members.append(self.members[indexPath.row])
                self.tableView.reloadData()
                self.btn_invited.setTitle("Invited(\(self.selected_members.count))", for: .normal)
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
