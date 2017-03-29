//
//  SelectFormTypeViewController.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/1/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class CustomFormQuestionViewController: UIViewController,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    var section = CustomFormSection()
    var api = APIAddCustomForm()
    var checked = false
    var color = Color()
    let sectionInsets = UIEdgeInsets(top: 5, left:5, bottom: 5, right: 5)
    let sectionInset = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
    var type : String = ""
    var question : String = ""
    var required = false
    var index : Int!
    var edit = false
    var isEdit = false
    var listDelete = [Bool]()
    var cusForm = CustomForm()
    var inType = false
    var back = BackCustomForm()
    var helper = Helper()
    var inSelecting = false
    var colorIndex = 0
    var colors = [Int]()
    var sectionIndex = 0
    var system = BackSystem()
    var ui = UILoading()
    var sectionno : Int = 0
    @IBOutlet weak var cons_question_top: NSLayoutConstraint!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var vw_question: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_layout: UIView!
    @IBOutlet weak var vw_selection: UIView!
    @IBOutlet weak var btn_checkBox: UIButton!
    @IBOutlet weak var lb_section_name: UILabel!
    @IBOutlet weak var lb_section_description: UILabel!
    @IBOutlet weak var vw_section: UIView!
    @IBOutlet weak var vw_top_section: UIView!
    @IBOutlet weak var lb_name_section: UILabel!
    @IBOutlet weak var tf_name_section: UITextField!
    @IBOutlet weak var lb_section_section: UILabel!
    @IBOutlet weak var tf_description_section: UITextField!
    @IBOutlet weak var lb_desction_section: UILabel!
    @IBOutlet weak var collectionColor: UICollectionView!
    @IBOutlet weak var btn_confirm_section: UIButton!
    @IBOutlet weak var btn_cancel_section: UIButton!
    @IBAction func btn_confirm_section_action(_ sender: UIButton) {
        self.api.updateCFSection(sessionid: self.system.getSessionid(), sectionid: self.section.id, cusformid: self.cusForm.id, sectionno:String(self.sectionno) , name: self.tf_name_section.text!, description: self.tf_description_section.text!, color: self.colors[self.colorIndex], success: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                if let updatetime = content.value(forKey: "updatetime") as? String{
                    self.back.updateTime(updatetime: updatetime, cusform: self.cusForm)
                }
            }
            self.back.updateSection(title: self.tf_name_section.text!, des: self.tf_description_section.text!, color: self.colors[self.colorIndex], section: self.section)
            self.vw_filter.isHidden = true
            self.vw_section.isHidden = true
            self.vw_top.backgroundColor = UIColor(netHex:self.section.colorMain)
            self.lb_section_name.text = self.section.sectionName
            self.lb_section_description.text = self.section.des
            self.lb_section_name.textColor = self.color.letterColor(color: self.section.colorMain)
            self.lb_section_description.textColor = self.color.letterColor(color: self.section.colorMain)
            self.navigationController?.navigationBar.barTintColor = UIColor(netHex:self.cusForm.section[self.sectionIndex].colorMain)
            if self.color.isBlack(color: self.section.colorMain){
                self.btn_eye.setImage(UIImage(named:"eye-dark.png"), for: .normal)
                self.btn_calculator.setImage(UIImage(named:"calculator-dark.png"), for: .normal)
            }else{
                self.btn_eye.setImage(UIImage(named:"eye-white.png"), for: .normal)
                self.btn_calculator.setImage(UIImage(named:"calculator-white.png"), for: .normal)
            }
            self.collectionView.reloadData()
        }, failure: {(error) in
            
        })
    }
    @IBAction func btn_cancel_section_action(_ sender: UIButton) {
        self.vw_filter.isHidden = true
        self.vw_section.isHidden = true
    }
    @IBAction func tf_name_secion_change(_ sender: UITextField) {
        if sender.text == ""{
            self.lb_name_section.isHidden = false
        }else{
            self.lb_name_section.isHidden = true
        }
    }
    @IBAction func tf_description_section_action(_ sender: UITextField) {
        if sender.text == ""{
            self.lb_desction_section.isHidden = false
        }else{
            self.lb_desction_section.isHidden = true
        }
    }
    @IBAction func btn_top_action(_ sender: UIButton) {
        self.vw_filter.isHidden = false
        self.vw_section.isHidden = false
        self.vw_top_section.backgroundColor = UIColor(netHex: self.section.colorMain)
        self.lb_section_section.textColor = self.color.letterColor(color: self.section.colorMain)
        self.tf_name_section.text = self.section.sectionName
        self.tf_description_section.text = self.section.des
        if self.section.sectionName == ""{
            self.lb_name_section.isHidden = true
        }else{
            self.lb_name_section.isHidden = false
        }
        if self.section.des == ""{
            self.lb_desction_section.isHidden = true
        }else{
            self.lb_desction_section.isHidden = false
        }
        for i in 0..<colors.count{
            if self.section.colorMain == colors[i]{
                self.colorIndex = i
                break
            }
        }
    }
    
    @IBOutlet weak var btn_calculator: UIButton!
    @IBOutlet weak var btn_eye: UIButton!
    var formTitle = ["Checkboxes","Dropdown","Multiple choice","Linear Scale","Multiple choice grid","Free text","Number Text","Date-Time","Picture","Video-Link"]
    var formImage = ["checkbox","drop","multiple","slider","grid","text","number","calendar","pictures","video"]
    @IBOutlet weak var tf_type: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img_selection: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var img_question: UIImageView!
    @IBOutlet weak var lb_question_title: UILabel!
    @IBOutlet weak var tv_question_des: UITextView!
    @IBOutlet var gesture: UITapGestureRecognizer!
    
    @IBAction func btn_calculator_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "calculator", sender: self)
    }
    @IBAction func eye_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "eye", sender: self)
    }
    @IBAction func btn_select_action(_ sender: UIButton) {
        self.tableView.reloadData()
        self.tableView.isHidden = false
    }
    @IBAction func btn_cancel(_ sender: UIButton) {
        self.tableView.isHidden = true
        self.vw_selection.isHidden = true
        self.vw_question.isHidden = true
        self.vw_filter.isHidden = true
        self.checked = false
        self.tv_question_des.resignFirstResponder()
    }
    @IBAction func btn_next_action(_ sender: UIButton) {
        self.inSelecting = false
        switch self.tf_type.text! {
        case "Checkboxes":
            self.vw_selection.isHidden = true
            self.vw_filter.isHidden = true
            self.performSegue(withIdentifier: "next", sender: self)
        case "Dropdown":
            self.vw_selection.isHidden = true
            self.vw_filter.isHidden = true
            self.performSegue(withIdentifier: "next", sender: self)
        case "Multiple choice":
            self.vw_selection.isHidden = true
            self.vw_filter.isHidden = true
            self.performSegue(withIdentifier: "next", sender: self)
        case "Linear Scale":
            self.vw_selection.isHidden = true
            self.vw_filter.isHidden = true
            self.performSegue(withIdentifier: "next", sender: self)
        case "Multiple choice grid":
            self.vw_selection.isHidden = true
            self.vw_filter.isHidden = true
            self.performSegue(withIdentifier: "multiple", sender: self)
        case "Free text":
            self.vw_selection.isHidden = true
            self.vw_question.isHidden = false
            self.type = "text"
            self.lb_question_title.text = "Free Text"
            self.img_question.image = UIImage(named: self.type)
            self.tv_question_des.text = ""
        case "Number Text":
            self.vw_selection.isHidden = true
            self.vw_question.isHidden = false
            self.type = "number"
            self.lb_question_title.text = "Number Text"
            self.img_question.image = UIImage(named: self.type)
            self.tv_question_des.text = ""
        case "Date-Time":
            self.vw_selection.isHidden = true
            self.vw_question.isHidden = false
            self.type = "calendar"
            self.lb_question_title.text = "Date-Time"
            self.img_question.image = UIImage(named: self.type)
            self.tv_question_des.text = ""
        case "Picture":
            self.vw_selection.isHidden = true
            self.vw_question.isHidden = false
            self.type = "pictures"
            self.lb_question_title.text = "Picture"
            self.img_question.image = UIImage(named: self.type)
            self.tv_question_des.text = ""
        case "Video-Link":
            self.vw_selection.isHidden = true
            self.vw_question.isHidden = false
            self.type = "video"
            self.lb_question_title.text = "Video-Link"
            self.img_question.image = UIImage(named: self.type)
            self.tv_question_des.text = ""
        default:
            print("error")
        }
    }
    @IBAction func btn_checkBox_action(_ sender: UIButton) {
        if !checked{
            self.checked = !self.checked
            btn_checkBox.backgroundColor = UIColor.darkGray
            self.required = true
        }else{
            self.checked = !self.checked
            btn_checkBox.backgroundColor = UIColor.white
            self.required = false
        }
    }
    @IBAction func btn_question_done(_ sender: UIButton) {
        self.checked = false
        if self.edit{
            if self.tv_question_des.text! == ""{
                let alertController = UIAlertController(title: "Error", message: "Please Fill Question field", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                self.api.updateCFQuestion(sessionid: self.system.getSessionid(), questionid: self.section.form[self.index].id, sectionid: self.section.id, questiontype: self.type, questionno: String(self.index), question: self.tv_question_des.text!, rows: [], columns: [], required: self.required, color: self.section.colorMain, success: {(success) in
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        if let updatetime = content.value(forKey: "updatetime") as? String{
                            self.back.updateTime(updatetime: updatetime, cusform: self.cusForm)
                        }
                    }
                    self.back.updateQuestion(q: self.tv_question_des.text!, type: self.type, require: self.required,option:[],grid:[], question: self.section.form[self.index])
                    self.edit = false
                    self.tableView.isHidden = true
                    self.vw_selection.isHidden = true
                    self.vw_question.isHidden = true
                    self.vw_filter.isHidden = true
                    self.collectionView.reloadData()
                    self.tv_question_des.resignFirstResponder()
                }, failure: {(error) in
                    self.ui.showErrorNav(error: "Internet connection error", view: self.view)
                })
            }
        }else{
            if self.tv_question_des.text! == ""{
                let alertController = UIAlertController(title: "Error", message: "Please Fill Question field", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                self.api.createCFQuestion(sessionid: self.system.getSessionid(), sectionid: self.section.id, questiontype: self.type, questionno: String(self.section.form.count), question: self.tv_question_des.text!, rows: [], columns: [], required: self.required, success: {(success) in
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        if let ID = content.value(forKey: "_id") as? NSDictionary{
                            if let id = ID.value(forKey: "$id") as? String{
                                if let content = success.value(forKey: "content") as? NSDictionary{
                                    if let updatetime = content.value(forKey: "updatetime") as? String{
                                        self.back.updateTime(updatetime: updatetime, cusform: self.cusForm)
                                    }
                                }
                                self.back.createQuestion(q: self.tv_question_des.text!, type: self.type, require: self.required, option: [], grid: [], section: self.section,id:id)
                                self.tableView.isHidden = true
                                self.vw_selection.isHidden = true
                                self.vw_question.isHidden = true
                                self.vw_filter.isHidden = true
                                self.collectionView.reloadData()
                                self.tv_question_des.resignFirstResponder()
                            }
                        }
                    }
                }, failure: {(error) in
                    self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
                })
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.gesture.delegate = self
        self.tf_description_section.delegate = self
        self.tf_name_section.delegate = self
        self.tv_question_des.delegate = self
        self.view.addGestureRecognizer(self.gesture)
        // Do any additional setup after loading the view.
    }
    func setUI(){
        self.vw_top.backgroundColor = UIColor(netHex:self.section.colorMain)
        self.lb_section_name.text = self.section.sectionName
        self.lb_section_description.text = self.section.des
        self.lb_section_name.textColor = self.color.letterColor(color: self.section.colorMain)
        self.lb_section_description.textColor = self.color.letterColor(color: self.section.colorMain)
        if self.color.isBlack(color: self.section.colorMain){
            self.btn_eye.setImage(UIImage(named:"eye-dark.png"), for: .normal)
            self.btn_calculator.setImage(UIImage(named:"calculator-dark.png"), for: .normal)
        }else{
            self.btn_eye.setImage(UIImage(named:"eye-white.png"), for: .normal)
            self.btn_calculator.setImage(UIImage(named:"calculator-white.png"), for: .normal)
        }
        self.btn_checkBox.layer.cornerRadius = 10
        self.btn_checkBox.layer.masksToBounds = true
        self.btn_checkBox.layer.borderWidth = 2
        self.btn_checkBox.layer.borderColor = UIColor.darkGray.cgColor
        self.tv_question_des.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0).cgColor
        self.tv_question_des.layer.borderWidth = 1
        self.tv_question_des.layer.cornerRadius = 3
        self.tv_question_des.layer.masksToBounds = true
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "add.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(addNew), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:20, height:20)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        self.btn_cancel_section.layer.cornerRadius = 2
        self.btn_cancel_section.layer.masksToBounds = true
        self.btn_cancel_section.layer.borderWidth = 1
        self.btn_cancel_section.layer.borderColor = UIColor(netHex: 0x27916F).cgColor
        self.btn_confirm_section.layer.cornerRadius = 2
        self.btn_confirm_section.layer.masksToBounds = true
    }
    func addNew(sender:UIButton){
        self.tf_type.text = ""
        self.img_selection.isHidden = true
        self.required = false
        self.btn_checkBox.backgroundColor = UIColor.white
        self.inSelecting = true
        self.vw_selection.isHidden = false
        self.vw_filter.isHidden = false
        self.index = self.section.form.count
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUI()
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex:self.cusForm.section[self.sectionIndex].colorMain)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.colors = self.color.listColor()
        self.collectionView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        img.image = UIImage(named: self.formImage[indexPath.row])
        let title = cell.viewWithTag(2) as! UILabel
        title.text = self.formTitle[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formTitle.count
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tf_type.text = self.formTitle[indexPath.row]
        self.img_selection.image = UIImage(named: self.formImage[indexPath.row])
        self.tableView.isHidden = true
        self.img_selection.isHidden = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next"{
            if let des = segue.destination as? CustomFormInitQuestionViewController{
                des.section = self.section
                des.require = self.required
                des.cusForm = self.cusForm
                des.questionno = self.index
                switch self.tf_type.text! {
                case "Checkboxes":
                    des.type = "checkbox"
                case "Dropdown":
                    des.type = "drop"
                case "Multiple choice":
                    des.type = "multiple"
                case "Linear Scale":
                    des.type = "slider"
                case "Multiple choice grid":
                    des.type = "grid"
                case "Free text":
                    des.type = "text"
                case "Date-Time":
                    des.type = "calendar"
                case "Picture":
                    des.type = "pictures"
                case "Video-Link":
                    des.type = "video"
                default:
                    print("error")
                }
            }
        }else if segue.identifier == "edit"{
            if let des = segue.destination as? CustomFormInitQuestionViewController{
                des.section = self.section
                des.edit = true
                des.id = self.index
                des.questionno = self.index
                des.cusForm = self.cusForm
                des.require = self.required
                des.question = self.section.form[self.index]
                des.type = self.section.form[self.index].type
            }
        }else if segue.identifier == "multiple"{
            if let des = segue.destination as? CustomFormMultipleGridViewController{
                des.section = self.section
                des.required = self.required
                des.cusForm = self.cusForm
            }
        }else if segue.identifier == "multiple_edit"{
            if let des = segue.destination as? CustomFormMultipleGridViewController{
                des.section = self.section
                des.edit = true
                des.required = self.required
                des.id = self.index
                des.cusForm = self.cusForm
                des.question = self.section.form[self.index]
            }
        }//else if segue.identifier == "eye"{
            //            if let des = segue.destination as? ShowCustomFormViewController{
            //                des.section = self.sectionIndex
            //                des.form = self.cusForm
            //                des.isCreate = true
            //                des.isCustomForm = false
            //            }
            //        }else if segue.identifier == "back"{
            //            if let des = segue.destination as? SectionViewController{
            //                des.customForm = self.cusForm
            //            }
            //}
        else if segue.identifier == "calculator"{
            if let des = segue.destination as? CustomFormEquationViewController{
                des.cusForm = self.cusForm
                des.isSection = false
                des.section = self.section
                des.sectionIndex = self.sectionIndex
            }
        }else if segue.identifier == "eye"{
            if let des = segue.destination as? ShowCustomFormViewController{
                des.cusForm = self.cusForm
                des.sectionIndex = self.sectionIndex
                des.isView = true
            }
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if inSelecting{
            if self.helper.inBound(x: touch.location(in: self.vw_selection).x, y: touch.location(in: self.vw_selection).y, view: self.vw_selection){
                return false
            }else{
                self.inSelecting = false
                self.checked = false
                self.tableView.isHidden = true
                self.vw_selection.isHidden = true
                self.vw_filter.isHidden = true
                return true
            }
        }
        if inType{
            inType = false
            self.tv_question_des.resignFirstResponder()
            return true
        }else{
            return false
        }
        return false
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath)
            cell.backgroundColor = UIColor(netHex: self.colors[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let vw = cell.viewWithTag(1)
            vw?.backgroundColor = UIColor(netHex: self.section.colorMain)
            let number = cell.viewWithTag(2) as! UILabel
            number.text = String(indexPath.row+1)
            let pic = cell.viewWithTag(3) as! UIImageView
            pic.image = UIImage(named: self.section.form[indexPath.row].type)
            let question = cell.viewWithTag(4) as! UILabel
            question.text = self.section.form[indexPath.row].question
            let curveView = cell.viewWithTag(5)
            curveView?.layer.cornerRadius = 5
            curveView?.layer.masksToBounds = true
            curveView?.backgroundColor = UIColor(netHex: self.section.colorMain)
            let vw_select = cell.viewWithTag(6)
            vw_select?.layer.borderWidth = 1
            vw_select?.layer.cornerRadius = 2
            vw_select?.layer.masksToBounds = true
            if self.isEdit{
                vw_select?.isHidden = false
            }else{
                vw_select?.isHidden = true
            }
            let star = cell.viewWithTag(8) as! UIImageView
            if self.section.form[indexPath.row].required{
                star.isHidden = false
            }else{
                star.isHidden = true
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return self.colors.count
        }else{
            return Int(self.section.form.count)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1{
            return CGSize(width:50,height:50)
        }else{
            let paddingSpace = sectionInsets.left * (2 + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / 3
            return CGSize(width: widthPerItem, height: widthPerItem+20)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 1{
            return sectionInset
        }else{
            return sectionInsets
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1{
            return sectionInset.left
        }else{
            return sectionInsets.left
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            self.colorIndex = indexPath.row
            self.vw_top_section.backgroundColor = UIColor(netHex: self.colors[self.colorIndex])
        }else{
            if self.isEdit{
                if !self.listDelete[indexPath.row]{
                    self.listDelete[indexPath.row] = true
                    self.collectionView.reloadData()
                }else{
                    self.listDelete[indexPath.row] = false
                    self.collectionView.reloadData()
                }
            }else{
                self.index = indexPath.row
                switch self.section.form[self.index].type {
                case "checkbox":
                    self.vw_selection.isHidden = true
                    self.vw_filter.isHidden = true
                    self.performSegue(withIdentifier: "edit", sender: self)
                case "drop":
                    self.vw_selection.isHidden = true
                    self.vw_filter.isHidden = true
                    self.performSegue(withIdentifier: "edit", sender: self)
                case "multiple":
                    self.vw_selection.isHidden = true
                    self.vw_filter.isHidden = true
                    self.performSegue(withIdentifier: "edit", sender: self)
                case "slider":
                    self.vw_selection.isHidden = true
                    self.vw_filter.isHidden = true
                    self.performSegue(withIdentifier: "edit", sender: self)
                case "grid":
                    self.vw_selection.isHidden = true
                    self.vw_filter.isHidden = true
                    self.performSegue(withIdentifier: "multiple_edit", sender: self)
                case "text":
                    self.edit = true
                    self.vw_selection.isHidden = true
                    self.vw_question.isHidden = false
                    self.type = "text"
                    self.lb_question_title.text = "Free Text"
                    self.img_question.image = UIImage(named: self.type)
                    self.required = self.back.getQuestionRequired(section: self.section, index: self.index)
                    self.tv_question_des.text = self.back.getQuestionText(section: self.section, index: self.index)
                    self.vw_filter.isHidden = false
                case "number":
                    self.edit = true
                    self.vw_selection.isHidden = true
                    self.vw_question.isHidden = false
                    self.type = "number"
                    self.lb_question_title.text = "Number Text"
                    self.img_question.image = UIImage(named: self.type)
                    self.required = self.back.getQuestionRequired(section: self.section, index: self.index)
                    self.tv_question_des.text = self.back.getQuestionText(section: self.section, index: self.index)
                    self.vw_filter.isHidden = false
                case "calendar":
                    self.edit = true
                    self.vw_selection.isHidden = true
                    self.vw_question.isHidden = false
                    self.type = "calendar"
                    self.lb_question_title.text = "Date-Time"
                    self.img_question.image = UIImage(named: self.type)
                    self.required = self.back.getQuestionRequired(section: self.section, index: self.index)
                    self.tv_question_des.text = self.back.getQuestionText(section: self.section, index: self.index)
                    self.vw_filter.isHidden = false
                case "pictures":
                    self.edit = true
                    self.vw_selection.isHidden = true
                    self.vw_question.isHidden = false
                    self.type = "pictures"
                    self.lb_question_title.text = "Picture"
                    self.img_question.image = UIImage(named: self.type)
                    self.required = self.back.getQuestionRequired(section: self.section, index: self.index)
                    self.tv_question_des.text = self.back.getQuestionText(section: self.section, index: self.index)
                    self.vw_filter.isHidden = false
                case "video":
                    self.edit = true
                    self.vw_selection.isHidden = true
                    self.vw_question.isHidden = false
                    self.type = "video"
                    self.lb_question_title.text = "Video-Link"
                    self.img_question.image = UIImage(named: self.type)
                    self.required = self.back.getQuestionRequired(section: self.section, index: self.index)
                    self.tv_question_des.text = self.back.getQuestionText(section: self.section, index: self.index)
                    self.vw_filter.isHidden = false
                default:
                    print("error")
                }
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.inType = true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.inType = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.inType = true
        if textView.tag == 1000{
            self.cons_question_top.constant -= 100
        }else{
            if textView.text == "Edit description"{
                textView.text = ""
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.inType = false
        if textView.tag == 1000{
            self.cons_question_top.constant += 100
        }
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if inType{
            inType = false
            self.tv_question_des.resignFirstResponder()
            return true
        }else{
            return false
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
