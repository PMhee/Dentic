//
//  SearchViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/3/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var patient = [RealmPatient]()
    var back = BackPatient()
    var helper = Helper()
    var index = 0
    var MAX_SEARCH : CGFloat = 0
    @IBAction func tf_seacrh_change(_ sender: UITextField) {
        self.patient = [RealmPatient]()
        self.patient = self.back.searchPatient(name: sender.text!)
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.cons_height.constant = self.tableView.contentSize.height
        if self.cons_height.constant > self.MAX_SEARCH{
            self.cons_height.constant = self.MAX_SEARCH
        }
    }
    @IBOutlet weak var cons_height: NSLayoutConstraint!
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var vw_search: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf_search.becomeFirstResponder()
        self.tf_search.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        // Do any additional setup after loading the view.
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.MAX_SEARCH = self.view.frame.height - keyboardSize.height - 50
            //self.cons_height_searchMeshtag.constant = self.MAX_SEARCH_MESHTAG
            //self.cons_tableView_meshtag.constant = self.MAX_SEARCH_MESHTAG
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pic = cell.viewWithTag(1) as! UIImageView
        let lb = cell.viewWithTag(2) as! UILabel
        let hn = cell.viewWithTag(3) as! UILabel
        self.helper.loadLocalProfilePic(id: self.patient[indexPath.row].localid, image: pic)
        pic.layer.cornerRadius = 22
        pic.layer.masksToBounds = true
        lb.text = self.patient[indexPath.row].name
        hn.text = self.patient[indexPath.row].HN
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patient.count
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tf_search.resignFirstResponder()
        self.index = indexPath.row
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "select", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select"{
            if let des = segue.destination as? DentistClinicalViewController{
                des.patient = self.patient[self.index]
                des.isFirst = true
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
