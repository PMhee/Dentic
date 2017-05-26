//
//  SearchUIViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 5/14/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class SearchUIViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
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
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tf_search.text! == ""{
            return 0
        }else{
            return self.listAllPatient.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        let lb_name = cell.viewWithTag(2) as! UILabel
        let lb_hn = cell.viewWithTag(3) as! UILabel
        self.helper.loadLocalProfilePic(id: self.listAllPatient[indexPath.row].localid, image: img)
        lb_name.text = self.listAllPatient[indexPath.row].name
        lb_hn.text = self.listAllPatient[indexPath.row].HN
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.tf_search.resignFirstResponder()
        self.performSegue(withIdentifier: "patient", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "patient"{
            if let des = segue.destination as? DentistClinicalViewController{
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
