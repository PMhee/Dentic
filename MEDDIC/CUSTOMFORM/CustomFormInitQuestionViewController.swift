//
//  CheckBoxViewController.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/1/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class CustomFormInitQuestionViewController: UIViewController,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDelegate {
    var form = [CustomFormOption]()
    var type : String!
    var section = CustomFormSection()
    var require :Bool!
    var edit = false
    var id : Int = 0
    var color = Color()
    var sectionIndex : Int = 0
    var api = APIAddCustomForm()
    var cusForm = CustomForm()
    var back = BackCustomForm()
    var question = CustomFormForm()
    var system = BackSystem()
    var ui = UILoading()
    var questionno = 0
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var lb_no: UILabel!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var vw_question: UIView!
    @IBOutlet weak var tf_question: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func tf_question_begin(_ sender: UITextField) {
        vw_question.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
    }
    
    @IBOutlet weak var cons_top: NSLayoutConstraint!
    func addNew(sender: UIButton) {
        self.view.endEditing(true)
        var found = false
        for i in 0..<self.form.count{
            if self.form[i].question != ""{
                found = true
                break
            }
        }
        if self.type == "slider" {
            
            found = true
        }
        if edit{
            if self.tf_question.text! == ""{
                let alertController = UIAlertController(title: "Error", message: "Please Fill Question field", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else if !found {
                let alertController = UIAlertController(title: "Error", message: "Please Fill atleast 1 Option field", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else if self.type == "slider" && Int(self.form[0].question)! >= Int(self.form[1].question)!{
                let alertController = UIAlertController(title: "Error", message: "Max must be greater than min", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                var f = [CustomFormOption]()
                for i in 0..<form.count{
                    if form[i].question == ""{
                    }else{
                        let option = CustomFormOption()
                        option.question = form[i].question
                        if form[i].point != ""{
                            option.point = form[i].point
                        }else{
                            option.point = "1"
                        }
                        f.append(option)
                    }
                }
                var ff = [CustomFormOption]()
                for i in 0..<form.count{
                    if form[i].question != ""{
                        ff.append(form[i])
                    }
                }
                self.api.updateCFQuestion(sessionid: self.system.getSessionid(), questionid: self.question.id, sectionid: self.section.id, questiontype: self.type, questionno: String(self.questionno), question: self.tf_question.text!, rows: [], columns:ff, required: self.require, color: self.section.colorMain, success: {(success) in
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        if let updatetime = content.value(forKey: "updatetime") as? String{
                            self.back.updateTime(updatetime: updatetime, cusform: self.cusForm)
                        }
                    }
                self.back.updateQuestion(q: self.tf_question.text!, type: self.type, require: self.require,option:self.form,grid:[], question: self.question)
                self.navigationController?.popViewController(animated: false)
                }, failure: {(error) in
                    self.ui.showErrorNav(error: "Internet connection error", view: self.view)
                })
            }
        }else{
                if self.tf_question.text! == ""{
                    let alertController = UIAlertController(title: "Error", message: "Please Fill Question field", preferredStyle: UIAlertControllerStyle.alert)
                    let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(noAction)
                    self.present(alertController, animated: true, completion: nil)
                }else if !found {
                    let alertController = UIAlertController(title: "Error", message: "Please Fill atleast 1 Option field", preferredStyle: UIAlertControllerStyle.alert)
                    let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(noAction)
                    self.present(alertController, animated: true, completion: nil)
                }else if self.type == "slider" && Int(self.form[0].question)! >= Int(self.form[1].question)!{
                    let alertController = UIAlertController(title: "Error", message: "Max must be greater than min", preferredStyle: UIAlertControllerStyle.alert)
                    let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(noAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    var ff = [CustomFormOption]()
                    for i in 0..<form.count{
                        if form[i].question != ""{
                            ff.append(form[i])
                        }
                    }
                    self.api.createCFQuestion(sessionid: self.system.getSessionid(), sectionid: self.section.id, questiontype: self.type, questionno: String(self.section.form.count), question: self.tf_question.text!, rows: [], columns: ff, required: self.require, success: {(success) in
                            print(success)
                        if let content = success.value(forKey: "content") as? NSDictionary{
                            if let ID = content.value(forKey: "_id") as? NSDictionary{
                                if let id = ID.value(forKey: "$id") as? String{
                                    if let content = success.value(forKey: "content") as? NSDictionary{
                                        if let updatetime = content.value(forKey: "updatetime") as? String{
                                            self.back.updateTime(updatetime: updatetime, cusform: self.cusForm)
                                        }
                                    }
                                    self.back.createQuestion(q: self.tf_question.text!, type: self.type, require: self.require, option: self.form, grid: [], section: self.section,id:id)
                        self.navigationController?.popViewController(animated: false)
                                }
                            }
                        }
                    }, failure: {(error) in
                    self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
                    })
                   
                    }
        }
    }
    @IBAction func btn_view_action(_ sender: UIButton) {
    }
    @IBAction func tf_question_end(_ sender: UITextField) {
        vw_question.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gesture.delegate = self
        self.view.addGestureRecognizer(self.gesture)
        self.tf_question.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex:self.section.colorMain)
        if self.color.isBlack(color: self.section.colorMain){
            self.navigationController?.navigationBar.tintColor = UIColor.black
        }else{
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
        let button: UIButton = UIButton()
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(addNew), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:0, y:0, width:50, height:40)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if edit{
            if self.type == "slider"{
                self.lb_question.isHidden = false
                self.lb_no.text! = String(self.id+1)
                self.tf_question.text! = self.question.question
                self.form = [CustomFormOption]()
                for i in 0..<self.question.option.count{
                    let o = CustomFormOption()
                    o.question = self.question.option[i].question
                    o.point = self.question.option[i].point
                    self.form.append(o)
                }
                self.tableView.reloadData()
            }else{
                self.lb_question.isHidden = false
                self.lb_no.text! = String(self.id+1)
                self.tf_question.text! = self.question.question
                self.form = [CustomFormOption]()
                for i in 0..<self.question.option.count{
                    let o = CustomFormOption()
                    o.question = self.question.option[i].question
                    o.point = self.question.option[i].point
                    self.form.append(o)
                }
                let f = CustomFormOption()
                f.question = ""
                f.point = ""
                self.form.append(f)
                self.tableView.reloadData()
            }
        }else{
            self.lb_no.text! = String(self.section.form.count+1)
            var f = CustomFormOption()
            if self.type == "slider"{
                f.question = ""
                f.point = ""
                self.form.append(f)
                var f1 = CustomFormOption()
                f1.question = ""
                f1.point = ""
                self.form.append(f1)
            }else if self.type == "text" || self.type == "calendar" || self.type == "pictures" || self.type == "video"{
            }
            else{
                f.question = ""
                f.point = ""
                self.form.append(f)
            }
            self.tf_question.becomeFirstResponder()
            self.tableView.reloadData()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.type == "slider"{
            
            return true
        }else{
            if textField.tag >= 1 {
                if textField.tag % 2 != 0 {
                    if (textField.tag/2)+1 == self.form.count {
                        var f = CustomFormOption()
                        f.question = ""
                        f.point = ""
                        self.form.append(f)
                        self.tableView.reloadData()
                    }
                }else{
                    if (textField.tag/2) == self.form.count {
                        var f = CustomFormOption()
                        f.question = ""
                        f.point = ""
                        self.tableView.reloadData()
                    }
                }
            }
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.type == "slider"{
        }else{
            if textField.tag > 6 && textField.tag != 1000 {
                if textField.tag % 2 == 0 {
                    self.cons_top.constant -= CGFloat(70 * (textField.tag/2 - 4))+90
                }else{
                    print(self.cons_top.constant)
                    self.cons_top.constant -= CGFloat(70 * ((textField.tag/2)+1 - 4))+90
                    print(self.cons_top.constant)
                }
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.type == "slider" && textField.tag != 1000{
            self.form[textField.tag-10].point = textField.text!
            self.form[textField.tag-10].question = textField.text!
        }else{
            if textField.tag > 6  && textField.tag != 1000{
                if textField.tag % 2 == 0 {
                    self.cons_top.constant += CGFloat(70 * (textField.tag/2 - 4))+90
                }else{
                    self.cons_top.constant += CGFloat(70 * ((textField.tag/2)+1 - 4))+90
                }
            }
            if textField.tag == 1000{
                if textField.text! == ""{
                    self.lb_question.isHidden = true
                }else{
                    self.lb_question.isHidden = false
                }
            }else{
                if textField.tag >= 1 {
                    if textField.tag % 2 != 0 {
                        self.form[textField.tag/2].question = textField.text!
                    }else{
                        self.form[(textField.tag/2)-1].point = textField.text!
                    }
                }
            }
        }
    }
    @IBAction func tf_question_change(_ sender: UITextField) {
        if sender.text! == ""{
            self.lb_question.isHidden = true
        }else{
            self.lb_question.isHidden = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.type == "slider"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Slider", for: indexPath)
            let tf = cell.viewWithTag(1) as! UITextField
            if indexPath.row == 0 {
                tf.text! = self.form[indexPath.row].point
                tf.placeholder = "MIN"
                tf.tag = 10
            }else{
                tf.text! = self.form[indexPath.row].point
                tf.placeholder = "MAX"
                tf.tag = 11
            }
            tf.delegate = self
            tf.keyboardType = UIKeyboardType.numberPad
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CusFormTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let lb = cell.tf_option as UITextField
            lb.text = self.form[indexPath.row].question
            lb.tintColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
            let score = cell.tf_score as UITextField
            score.text = self.form[indexPath.row].point
            lb.tag = ((indexPath.row+1)*2)-1
            score.tag = ((indexPath.row+1)*2)
            score.delegate = self
            lb.delegate = self
            let img = cell.img_type as! UIImageView
            img.image = UIImage(named:self.type)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if self.type == "slider"{
            return false
        }else{
            if self.form.count != 1 {
                return true
            }else{
                return false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == .delete
        {
            form.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.count
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
