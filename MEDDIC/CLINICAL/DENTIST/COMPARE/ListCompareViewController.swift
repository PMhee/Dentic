//
//  SearchUIViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 5/14/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class ListCompareViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    var MAX_HEIGHT : CGFloat = 0
    var listSearchPatient = [RealmPatient]()
    var listAllPatient = try! Realm().objects(RealmPatient.self)
    var back = BackPatient()
    var helper = Helper()
    var index = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cons_height: NSLayoutConstraint!
    @IBOutlet weak var tf_search: UITextField!
    
    @IBAction func tf_search_change(_ sender: UITextField) {
        self.listAllPatient = self.back.getListPatient(name: sender.text!, hn: sender.text!)
        self.listAllPatient = self.listAllPatient.sorted(byProperty: "name",ascending:true).filter(NSPredicate(format: "name != %@ AND name != %@", "","  "))
        self.setTableHeight()
    }
    func setTableHeight(){
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        if self.MAX_HEIGHT < self.tableView.contentSize.height {
            self.cons_height.constant = self.MAX_HEIGHT
        }else{
            self.cons_height.constant = self.tableView.contentSize.height
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        // Do any additional setup after loading the view.s
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.layoutIfNeeded()
            if (self.navigationController?.navigationBar.isHidden)!{
                self.MAX_HEIGHT = self.view.frame.height - keyboardSize.height - (self.navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height
            }else{
                self.MAX_HEIGHT = self.view.frame.height - keyboardSize.height
            }
            self.setTableHeight()
            //self.cons_height_searchMeshtag.constant = self.MAX_SEARCH_MESHTAG
            //self.cons_tableView_meshtag.constant = self.MAX_SEARCH_MESHTAG
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tf_search.becomeFirstResponder()
        self.listAllPatient = self.listAllPatient.sorted(byProperty: "name",ascending:true).filter(NSPredicate(format: "name != %@ AND name != %@", "","  "))
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        self.cons_height.constant = self.view.frame.height
        self.tableView.reloadData()
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
        self.cons_height.constant = self.view.frame.height
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAllPatient.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.listAllPatient[indexPath.row].comparePic.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            let lb_name = cell.viewWithTag(2) as! UILabel
            let img_show = cell.viewWithTag(3) as! UIImageView
            let vw_filter = cell.viewWithTag(4)
            let lb_number = cell.viewWithTag(5) as! UILabel
            self.helper.loadLocalProfilePic(id: self.listAllPatient[indexPath.row].localid, image: img)
            lb_name.text = self.listAllPatient[indexPath.row].name
            self.helper.loadLocalProfilePic(id: self.listAllPatient[indexPath.row].comparePic[0].id, image: img_show)
            if self.listAllPatient[indexPath.row].comparePic.count > 1{
                vw_filter?.isHidden = false
                lb_number.isHidden = false
                lb_number.text = String(self.listAllPatient[indexPath.row].comparePic.count-1)+"+"
            }else{
                vw_filter?.isHidden = true
                lb_number.isHidden = true
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nopic", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            let lb_name = cell.viewWithTag(2) as! UILabel
            self.helper.loadLocalProfilePic(id: self.listAllPatient[indexPath.row].localid, image: img)
            lb_name.text = self.listAllPatient[indexPath.row].name
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.index = indexPath.row
        self.tf_search.resignFirstResponder()
        self.performSegue(withIdentifier: "select", sender: self)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select"{
            if let des = segue.destination as? ShowPatientCompareViewController{
                des.patient = self.listAllPatient[self.index]
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
