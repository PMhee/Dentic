//
//  MultipleChoiceGridViewController.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/8/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class CustomFormMultipleGridViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var row = [CustomFormGridOption]()
    var column = [CustomFormOption]()
    var edit = false
    var id : Int!
    var back = BackCustomForm()
    var section = CustomFormSection()
    var required = false
    var color = Color()
    var cusForm = CustomForm()
    let api = APIAddCustomForm()
    var question = CustomFormForm()
    var system = BackSystem()
    var ui = UILoading()
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var cons_top: NSLayoutConstraint!
    @IBOutlet weak var tableView_column: UITableView!
    @IBOutlet weak var tableView_row: UITableView!
    @IBOutlet weak var lb_number: UILabel!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var tf_question: UITextField!
    @IBAction func tf_question_begin(_ sender: UITextField) {
        if sender.text! == ""{
            self.lb_question.isHidden = true
        }else{
            self.lb_question.isHidden = false
        }
    }
    @IBAction func tf_question_end(_ sender: UITextField) {
        if sender.text! == "" {
            self.lb_question.isHidden = true
        }else{
            self.lb_question.isHidden = false
        }
    }
    @IBAction func tf_question_change(_ sender: UITextField) {
        if sender.text! == ""{
            self.lb_question.isHidden = true
        }else{
            self.lb_question.isHidden = false
        }
    }
    @IBAction func segment_action(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.tableView_row.isHidden = false
            self.tableView_column.isHidden = true
        }else{
            self.tableView_row.isHidden = true
            self.tableView_column.isHidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf_question.delegate = self
        self.segment.tintColor = UIColor(netHex: self.section.colorMain)
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
        // Do any additional setup after loading the view.
    }
    func addNew(sender:UIButton){
        if self.edit{
            if self.tf_question.text! == ""{
                let alertController = UIAlertController(title: "Error", message: "Please Fill Question field", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else if self.column[0].question == "" {
                let alertController = UIAlertController(title: "Error", message: "Please Fill atleast 1 Column field", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else if self.row[0].question == "" {
                let alertController = UIAlertController(title: "Error", message: "Please Fill atleast 1 Row field", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                var col = [CustomFormOption]()
                for i in 0..<column.count{
                    if column[i].question != ""{
                        col.append(column[i])
                    }
                }
                var rol = [CustomFormGridOption]()
                for i in 0..<self.row.count{
                    if row[i].question != ""{
                        rol.append(row[i])
                    }
                }
                self.api.updateCFQuestion(sessionid: self.system.getSessionid(), questionid: self.question.id, sectionid: self.section.id, questiontype: "grid", questionno: String(self.id), question: self.tf_question.text!, rows: rol, columns:col, required: self.required, color: self.section.colorMain, success: {(success) in
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        if let updatetime = content.value(forKey: "updatetime") as? String{
                            self.back.updateTime(updatetime: updatetime, cusform: self.cusForm)
                        }
                    }
                self.back.updateQuestion(q: self.tf_question.text!, type: "grid", require: self.required, option: self.column, grid: self.row, question: self.question)
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
            }else if self.column[0].question == "" {
                let alertController = UIAlertController(title: "Error", message: "Please Fill atleast 1 Column field", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else if self.row[0].question == "" {
                let alertController = UIAlertController(title: "Error", message: "Please Fill atleast 1 Row field", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                var col = [CustomFormOption]()
                for i in 0..<column.count{
                    if column[i].question != ""{
                        col.append(column[i])
                    }
                }
                var rol = [CustomFormGridOption]()
                for i in 0..<self.row.count{
                    if row[i].question != ""{
                        rol.append(row[i])
                    }
                }
                self.api.createCFQuestion(sessionid: self.system.getSessionid(), sectionid: self.section.id, questiontype: "grid", questionno: String(self.section.form.count), question: self.tf_question.text!, rows: rol, columns: col, required: self.required, success: {(success) in
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        if let ID = content.value(forKey: "_id") as? NSDictionary{
                            if let id = ID.value(forKey: "$id") as? String{
                                if let content = success.value(forKey: "content") as? NSDictionary{
                                    if let updatetime = content.value(forKey: "updatetime") as? String{
                                        self.back.updateTime(updatetime: updatetime, cusform: self.cusForm)
                                    }
                                }
                    self.back.createQuestion(q: self.tf_question.text!, type: "grid", require: self.required, option: self.column, grid: self.row,section:self.section,id:id)
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
    override func viewDidLayoutSubviews() {
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if edit{
            self.lb_question.isHidden = false
            self.lb_number.text! = String(self.id!+1)
            self.tf_question.text! = self.question.question
            self.column = [CustomFormOption]()
            self.row = [CustomFormGridOption]()
            for i in 0..<self.question.option.count{
                let c = CustomFormOption()
                c.question = self.question.option[i].question
                c.point = self.question.option[i].point
                self.column.append(c)
            }
            for i in 0..<self.question.choice.count{
                let r = CustomFormGridOption()
                r.question = self.question.choice[i].question
                r.reverse = self.question.choice[i].reverse
                self.row.append(r)
            }
            var f = CustomFormOption()
            f.question = ""
            f.point = ""
            self.column.append(f)
            var g = CustomFormGridOption()
            g.question = ""
            g.reverse = false
            self.row.append(g)
            self.tableView_row.reloadData()
            self.tableView_column.reloadData()
        }else{
            self.lb_number.text! = String(self.section.form.count+1)
            row = [CustomFormGridOption]()
            var form = CustomFormGridOption()
            form.question = ""
            form.reverse = false
            row.append(form)
            column = [CustomFormOption]()
            var f = CustomFormOption()
            f.question = ""
            f.point = ""
            column.append(f)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag - 999 >= 0 {
            if textField.tag % 2 != 0 {
                if (textField.tag-999)/2 + 1 == self.row.count{
                    var f = CustomFormGridOption()
                    f.question = ""
                    f.reverse = false
                    self.row.append(f)
                    self.tableView_row.reloadData()
                    return true
                }
            }else{
                
            }
        }else{
            if textField.tag >= 1 {
                if textField.tag % 2 != 0 {
                    if (textField.tag/2)+1 == self.column.count {
                        var f = CustomFormOption()
                        f.question = ""
                        f.point = ""
                        self.column.append(f)
                        self.tableView_column.reloadData()
                    }
                }else{
                    if (textField.tag/2) == self.column.count {
                        var f = CustomFormOption()
                        f.question = ""
                        f.point = ""
                        self.column.append(f)
                        self.tableView_column.reloadData()
                    }
                }
            }
        }
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! RowTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let lb = cell.lb_row as UILabel
            lb.text = String(indexPath.row+1)
            let tf = cell.tf_option as UITextField
            tf.delegate = self
            tf.text = self.row[indexPath.row].question
            tf.tag = (indexPath.row*2)+999
            let btn = cell.btn_reverse as! UIButton
            if self.row[indexPath.row].reverse{
                btn.setImage(UIImage(named:"reverse_blue"), for: .normal)
            }
            btn.addTarget(self, action: #selector(clickReverse), for: .touchUpInside)
            btn.tag = (indexPath.row*2)+1000
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "column", for: indexPath) as! ColumnTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let lb = cell.lb_column as UILabel
            lb.text = String(indexPath.row+1)
            let tf = cell.tf_option as UITextField
            tf.delegate = self
            tf.text = self.column[indexPath.row].question
            tf.tag = ((indexPath.row+1)*2)-1
            let score = cell.tf_score as UITextField
            score.tag = ((indexPath.row+1)*2)
            score.delegate = self
            score.text = self.column[indexPath.row].point
            return cell
        }
    }
    func clickReverse(sender: UIButton){
        let rev : Int = sender.tag
        if self.row[(rev-1000)/2].reverse{
            self.row[(rev-1000)/2].reverse = false
            sender.setImage(UIImage(named:"reverse_grey.png"), for: .normal)
        }else{
            self.row[(sender.tag-1000)/2].reverse = true
            sender.setImage(UIImage(named:"reverse_blue.png"), for: .normal)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag >= 999 {
            if textField.tag >= 1003{
                self.cons_top.constant -= CGFloat(70 * ((textField.tag-999)/2 - 3))+90
            }
        }else{
            self.cons_top.constant -= CGFloat(70 * (textField.tag/2)-3)+90
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag >= 999 {
            if textField.tag >= 1003{
                self.cons_top.constant += CGFloat(70 * ((textField.tag-999)/2 - 3))+90
            }
            if textField.tag % 2 != 0 {
                self.row[(textField.tag-999)/2].question = textField.text!
            }
        }else{
            self.cons_top.constant += CGFloat(70 * (textField.tag/2) - 3)+90
            if textField.tag >= 1 {
                if textField.tag % 2 != 0 {
                    self.column[textField.tag/2].question = textField.text!
                }else{
                    self.column[(textField.tag/2)-1].point = textField.text!
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return self.row.count
        }else{
            return self.column.count
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if self.row.count != 1 || self.column.count != 1 {
            return true
        }else{
            return false
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == .delete
        {
            if tableView.tag == 1 {
                row.remove(at: indexPath.row)
                tableView_row.reloadData()
            }else{
                column.remove(at: indexPath.row)
                tableView_column.reloadData()
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
