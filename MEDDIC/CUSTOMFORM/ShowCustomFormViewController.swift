//
//  ShowCustomFormViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/26/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class ShowCustomFormViewController: UIViewController,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    struct Pic {
        var section = 0
        var question = 0
        var img = UIImage()
    }
    var isUpdate = false // for add more customform
    var fudocid : String = ""
    var isAns = false
    var isView = false
    var link : String!
    var pickerArray = [String]()
    var answer = List<CustomFormSectionAns>()
    var images = [Pic]()
    let sectionInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
    var cusForm = CustomForm()
    var color = Color()
    var isTyping = false
    var helper = Helper()
    var sectionIndex = 0
    var uiTable = UITable()
    var isPic = false
    var questionIndex = 0
    var isPicker = false
    var isFirst = false
    var isGridFirst = false
    var keyboardHeight : CGFloat = 0
    var keyboardUp = false
    var system = BackSystem()
    var vw_tf : UITextField!
    var patient = RealmPatient()
    var api = APIAddCustomForm()
    @IBOutlet weak var cons_y: NSLayoutConstraint!
    
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var btn_done: UIBarButtonItem!
    @IBAction func segment_change(_ sender: UISegmentedControl) {
        self.sectionIndex = self.segment.selectedSegmentIndex
        self.tableView.reloadData()
    }
    @IBAction func btn_next_action(_ sender: UIButton) {
    }
    @IBOutlet weak var segment: UISegmentedControl!
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.vw_filter.isHidden = true
        self.vw_datePicker.isHidden = true
    }
    
    @IBAction func btn_done_action(_ sender: UIBarButtonItem) {
        if isView || isAns{
        }else{
            for i in 0..<self.answer.count{
                var found = false
                for j in 0..<self.answer[i].answer.count{
                    if self.answer[i].answer[j].type == "grid"{
                        for k in 0..<self.answer[i].answer[j].answerGrid.count{
                            if !self.answer[i].answer[j].answerGrid[k].requiredChecked{
                                self.sectionIndex = i
                                self.tableView.reloadData()
                                self.tableView.scrollToRow(at: IndexPath(row:j+1,section:0), at: .top, animated: true)
                                self.segment.selectedSegmentIndex = i
                                found = true
                                break
                            }
                        }
                    }else{
                        if !self.answer[i].answer[j].requiredChecked{
                            self.sectionIndex = i
                            self.tableView.reloadData()
                            self.tableView.scrollToRow(at: IndexPath(row:j+1,section:0), at: .top, animated: true)
                            self.segment.selectedSegmentIndex = i
                            found = true
                            break
                        }
                    }
                }
                if found{
                    break
                }
                if self.images.count > 0 {
                    if i == self.answer.count-1{
                        self.act.isHidden = false
                        self.act.startAnimating()
                        self.vw_filter.isHidden = false
                        self.api.updateCfAnswer(sessionid:self.system.getSessionid() , cfanswerid: "", form: self.cusForm, answer: self.answer,pictures:self.images,eflag:"0",patientid:self.patient.id,fudocid: self.fudocid, success: {(success) in
                            if let content = success.value(forKey: "content") as? NSDictionary{
                                if let cfanswerid = content.value(forKey: "cfanswerid") as? String{
                                    for i in 0..<self.images.count{
                                        if i == self.images.count-1{
                                            self.api.answerQuestion(sessionid: self.system.getSessionid(), cfanswerid: cfanswerid, eflag: "1", image: self.images[i], cusform: self.cusForm, success: {(success) in
                                                print(success)
                                                self.navigationController?.popViewController(animated: true)
                                                self.navigationController?.popViewController(animated: true)
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inFuProgress"), object: nil,userInfo:nil)
                                            }, failure: {(error) in
                                                
                                            })
                                            
                                        }else{
                                            self.api.answerQuestion(sessionid: self.system.getSessionid(), cfanswerid: cfanswerid, eflag: "0", image: self.images[i], cusform: self.cusForm, success: {(success) in
                                                self.navigationController?.popViewController(animated: true)
                                                self.navigationController?.popViewController(animated: true)
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inFuProgress"), object: nil,userInfo:nil)
                                            }, failure: {(error) in
                                                
                                            })
                                        }
                                    }
                                }
                            }
                        }, failure: {(error) in
                          print("error")
                        })
                    }
                    
                }else{
                    if i == self.answer.count-1{
                        self.act.isHidden = false
                        self.act.startAnimating()
                        self.vw_filter.isHidden = false
                        self.api.updateCfAnswer(sessionid:self.system.getSessionid() , cfanswerid: "", form: self.cusForm, answer: self.answer,pictures:self.images,eflag:"1",patientid:self.patient.id,fudocid: self.fudocid, success: {(success) in
                            print(success)
                            self.navigationController?.popViewController(animated: true)
                            self.navigationController?.popViewController(animated: true)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inFuProgress"), object: nil,userInfo:nil)
                        }, failure: {(error) in
                            print("error")
                        })
                    }
                }
                
            }
        }
    }
    @IBAction func btn_confirm_action(_ sender: UIButton) {
        try! Realm().write{
            if self.isPicker{
                self.answer[self.sectionIndex].answer[self.questionIndex].answer = self.pickerArray[self.picker.selectedRow(inComponent: 0)]
                self.answer[self.sectionIndex].answer[self.questionIndex].requiredChecked = true
            }else{
                self.answer[self.sectionIndex].answer[self.questionIndex].answer = self.helper.dateToStringOnlyDate(date: self.datePicker.date)
                self.answer[self.sectionIndex].answer[self.questionIndex].requiredChecked = true
            }
        }
        self.tableView.reloadData()
        self.vw_filter.isHidden = true
        self.vw_datePicker.isHidden = true
    }
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var vw_datePicker: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var gesture: UIGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gesture.delegate = self
        self.view.addGestureRecognizer(self.gesture)
        NotificationCenter.default.addObserver(self, selector: #selector(checkTyping), name: NSNotification.Name(rawValue:"isTyping"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showVideo), name: NSNotification.Name(rawValue:"showVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        self.picker.dataSource = self
        self.picker.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex:self.cusForm.color)
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex:0x587EBF)
    }
    func showVideo(notification:Notification){
        self.link = notification.userInfo?["link"] as! String
        self.performSegue(withIdentifier: "video", sender: self)
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            self.cons_y.constant += self.keyboardHeight - 50
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            self.cons_y.constant -= self.keyboardHeight - 50
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.act.isHidden = true
        if isView || isAns{
            self.btn_done.tintColor = UIColor(netHex: 0xBFBFBF)
            //self.tableView.isUserInteractionEnabled = false
        }
        if !isPic{
            self.gensegment()
            //self.uiTable.shadow(vw_layout: self.tableView)
            self.images = [Pic]()
            if self.cusForm.section.count > 0 {
                self.btn_cancel.layer.cornerRadius = 2
                self.btn_cancel.layer.masksToBounds = true
                self.btn_cancel.layer.borderColor = UIColor(netHex:self.cusForm.section[self.sectionIndex].colorMain).cgColor
                self.btn_cancel.layer.borderWidth = 1
                self.btn_cancel.setTitleColor(UIColor(netHex:self.cusForm.section[self.sectionIndex].colorMain), for: .normal)
                self.btn_confirm.layer.cornerRadius = 2
                self.btn_confirm.layer.masksToBounds = true
                self.btn_confirm.backgroundColor = UIColor(netHex: self.cusForm.section[self.sectionIndex].colorMain)
            }
            if !self.isAns{
                try! Realm().write{
                    //try! Realm().delete(answer)
                    for i in 0..<self.cusForm.section.count{
                        let answer = CustomFormSectionAns()
                        self.answer.append(answer)
                        for j in 0..<self.cusForm.section[i].form.count{
                            let ans = CustomFormAnswer()
                            if self.cusForm.section[i].form[j].type == "pictures"{
                                var pic = Pic()
                                pic.section = i
                                pic.question = j
                                pic.img = UIImage(named: "pictures.png")!
                                self.images.append(pic)
                            }else if self.cusForm.section[i].form[j].type == "grid"{
                                for k in 0..<self.cusForm.section[i].form[j].choice.count{
                                    let grid = CustomFormAnswer()
                                    ans.answerGrid.append(grid)
                                }
                            }
                            if self.cusForm.section[i].form[j].required{
                                ans.requiredChecked = false
                            }else{
                                ans.requiredChecked = true
                            }
                            ans.type = self.cusForm.section[i].form[j].type
                            self.answer[i].answer.append(ans)
                        }
                    }
                }
            }
        }
    }
    func gensegment(){
        self.segment.removeAllSegments()
        if self.cusForm.section.count > 0 {
            for i in 0..<self.cusForm.section.count{
                self.segment.insertSegment(withTitle: String(i+1), at: i, animated: false)
            }
            self.segment.selectedSegmentIndex = self.sectionIndex
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerArray[row]
    }
    func checkTyping(notification:NSNotification){
        self.isTyping = notification.userInfo?["isTyping"] as! Bool
        self.vw_tf = notification.userInfo?["textfield"] as! UITextField
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cusForm.section.count == 0 {
            return 1
        }else{
            return self.cusForm.section[self.sectionIndex].form.count+1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SectionTitleTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.vw_top.backgroundColor = UIColor(netHex:self.cusForm.color)
            self.helper.downloadImageFrom(link: self.cusForm.icon, contentMode: .scaleAspectFill, img: cell.img_icon)
            cell.lb_title.text = self.cusForm.title
            cell.lb_description.text = self.cusForm.des
            if self.cusForm.section.count > 0 {
                cell.lb_sectionname.text = self.cusForm.section[self.sectionIndex].sectionName
                cell.lb_sectiondescription.text = self.cusForm.section[self.sectionIndex].des
            }
            return cell
        }else{
            let idx = indexPath.row-1
            if self.cusForm.section[self.sectionIndex].form[idx].type == "text"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! TextFieldTableViewCell
                //Answer
                if isAns{
                    cell.isUserInteractionEnabled = false
                }
                if self.answer[self.sectionIndex].answer.count > idx{
                cell.tf_answer.text = self.answer[self.sectionIndex].answer[idx].answer
                cell.answer = self.answer[self.sectionIndex].answer[idx]
                }
                if cell.tf_answer.text! == ""{
                    cell.lb_answer.isHidden = true
                }else{
                    cell.lb_answer.isHidden = false
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_number.text = String(indexPath.row)
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_number.text = cell.lb_number.text!+"*"
                }
                cell.setDelegate()
                cell.tf_answer.keyboardType = .default
                cell.lb_answer.textColor = UIColor(netHex:self.cusForm.section[self.sectionIndex].colorMain)
                return cell
            }else if self.cusForm.section[self.sectionIndex].form[idx].type == "number"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! TextFieldTableViewCell
                //Answer
                if isAns{
                    cell.isUserInteractionEnabled = false
                }
                if self.answer[self.sectionIndex].answer.count > idx{
                cell.tf_answer.text = self.answer[self.sectionIndex].answer[idx].answer
                cell.answer = self.answer[self.sectionIndex].answer[idx]
                }
                if cell.tf_answer.text! == ""{
                    cell.lb_answer.isHidden = true
                }else{
                    cell.lb_answer.isHidden = false
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_number.text = String(indexPath.row)
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_number.text = cell.lb_number.text!+"*"
                }
                cell.setDelegate()
                cell.tf_answer.keyboardType = .decimalPad
                cell.lb_answer.textColor = UIColor(netHex:self.cusForm.section[self.sectionIndex].colorMain)
                return cell
            }else if self.cusForm.section[self.sectionIndex].form[idx].type == "checkbox"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "checkbox", for: indexPath) as! CheckboxTableViewCell
                //Answer
                if isAns{
                    cell.isUserInteractionEnabled = false
                }
                if self.answer[self.sectionIndex].answer.count > idx{
                cell.answer = self.answer[self.sectionIndex].answer[idx]
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_number.text = String(indexPath.row)
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_number.text = cell.lb_number.text!+"*"
                }
                var opt = [CustomFormOption]()
                for i in 0..<self.cusForm.section[self.sectionIndex].form[idx].option.count{
                    var op = CustomFormOption()
                    op.checked = self.cusForm.section[self.sectionIndex].form[idx].option[i].checked
                    op.question = self.cusForm.section[self.sectionIndex].form[idx].option[i].question
                    opt.append(op)
                }
                cell.option = opt
                cell.setDelegate()
                cell.tableView.layoutIfNeeded()
                cell.cons_tableView.constant = cell.tableView.contentSize.height
                
                return cell
            }else if self.cusForm.section[self.sectionIndex].form[idx].type == "multiple"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "multiple", for: indexPath) as! MultipleTableViewCell
                //Answer
                if isAns{
                    cell.isUserInteractionEnabled = false
                }
                if self.answer[self.sectionIndex].answer.count > idx{
                cell.answer = self.answer[self.sectionIndex].answer[idx]
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_no.text = String(indexPath.row)
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_no.text = cell.lb_no.text!+"*"
                }
                var opt = [CustomFormOption]()
                for i in 0..<self.cusForm.section[self.sectionIndex].form[idx].option.count{
                    let op = CustomFormOption()
                    op.checked = self.cusForm.section[self.sectionIndex].form[idx].option[i].checked
                    op.question = self.cusForm.section[self.sectionIndex].form[idx].option[i].question
                    opt.append(op)
                }
                cell.option = opt
                cell.setDelegate()
                cell.tableView.layoutIfNeeded()
                cell.cons_table.constant = cell.tableView.contentSize.height
                return cell
            }else if self.cusForm.section[self.sectionIndex].form[idx].type == "pictures"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "pictures", for: indexPath) as! PictureTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                //Answer
                if isAns{
                    cell.isUserInteractionEnabled = false
                    self.helper.downloadImageFrom(link: self.answer[self.sectionIndex].answer[idx].answer, contentMode: .scaleAspectFill, img: cell.img_picture)
                }else{
                    for i in 0..<self.images.count{
                        if self.images[i].section == self.sectionIndex && self.images[i].question == idx{
                            cell.img_picture.image = self.images[i].img
                            break
                        }
                    }
                }
                if self.answer[self.sectionIndex].answer.count > idx{
                cell.answer = self.answer[self.sectionIndex].answer[idx]
                }
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_number.text = String(indexPath.row)
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_number.text = cell.lb_number.text!+"*"
                }
                cell.btn_picture.tag = idx
                cell.btn_picture.addTarget(self, action: #selector(addPicture), for: .touchUpInside)
                return cell
            }else if self.cusForm.section[self.sectionIndex].form[idx].type == "slider"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "slider", for: indexPath) as! SliderTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                //Answer
                if isAns{
                    cell.isUserInteractionEnabled = false
                }
                if self.answer[self.sectionIndex].answer.count > idx{
                cell.answer = self.answer[self.sectionIndex].answer[idx]
                }
                if self.answer[self.sectionIndex].answer[idx].answer != ""{
                    cell.slider.value = Float(Int(Double(self.answer[self.sectionIndex].answer[idx].answer)!))
                    cell.lb_value.text = self.answer[self.sectionIndex].answer[idx].answer
                }
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_number.text = String(indexPath.row)
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_number.text = cell.lb_number.text!+"*"
                }
                cell.slider.tintColor = UIColor(netHex: self.cusForm.section[self.sectionIndex].colorMain)
                cell.lb_min.text = self.cusForm.section[self.sectionIndex].form[idx].option[0].point
                cell.lb_max.text = self.cusForm.section[self.sectionIndex].form[idx].option[1].point
                cell.slider.minimumValue = Float(Int(Double(self.cusForm.section[self.sectionIndex].form[idx].option[0].point)!))
                cell.slider.maximumValue = Float(Int(Double(self.cusForm.section[self.sectionIndex].form[idx].option[1].point)!))
                if cell.answer.answer == ""{
                    cell.slider.value = cell.slider.minimumValue
                    cell.lb_value.text = self.cusForm.section[self.sectionIndex].form[idx].option[0].point
                }
                return cell
            }else if self.cusForm.section[self.sectionIndex].form[idx].type == "calendar"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "calendar", for: indexPath) as! DateTableViewCell
                //Answer
                if self.answer[self.sectionIndex].answer.count > idx{
                if self.answer[self.sectionIndex].answer[idx].answer != ""{
                    cell.lb_date.text = self.answer[self.sectionIndex].answer[idx].answer
                }else{
                    cell.lb_date.text = "Select Date-Time"
                }
                }
                if isAns{
                    cell.isUserInteractionEnabled = false
                    cell.lb_date.text = self.helper.dateToStringOnlyDate(date: self.helper.StringtoDOB(date: self.answer[self.sectionIndex].answer[idx].answer))
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_number.text = String(indexPath.row)
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_number.text = cell.lb_number.text!+"*"
                }
                
                return cell
            }else if self.cusForm.section[self.sectionIndex].form[idx].type == "drop"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "drop", for: indexPath) as! DropTableViewCell
                if isAns{
                    cell.isUserInteractionEnabled = false
                        cell.lb_answer.text =  self.cusForm.section[self.sectionIndex].form[idx].option[Int(self.answer[self.sectionIndex].answer[idx].answer)!].question
                    
                    
                    
                }else{
                if self.answer[self.sectionIndex].answer.count > idx{
                if self.answer[self.sectionIndex].answer[idx].answer != ""{
                    cell.lb_answer_hover.isHidden = false
                    cell.lb_answer.text = self.answer[self.sectionIndex].answer[idx].answer
                }else{
                    cell.lb_answer.text = "Select your answer"
                    cell.lb_answer_hover.isHidden = true
                }
                }
                }
                cell.lb_answer_hover.textColor = UIColor(netHex: self.cusForm.section[self.sectionIndex].colorMain)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_number.text = String(indexPath.row)
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_number.text = cell.lb_number.text!+"*"
                }
                return cell
            }else if self.cusForm.section[self.sectionIndex].form[idx].type == "video"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "video", for: indexPath) as! VideoTableViewCell
                //Answer
                if isAns{
                    cell.isUserInteractionEnabled = false
                    cell.tf_answer.text = self.answer[self.sectionIndex].answer[idx].answer
                    cell.downloadYoutube()
                }
                if self.answer[self.sectionIndex].answer.count > idx{
                cell.answer = self.answer[self.sectionIndex].answer[idx]
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_number.text = String(indexPath.row)
                cell.setDelegate()
                cell.tableView = self.tableView
                
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_number.text = cell.lb_number.text!+"*"
                }
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "grid", for: indexPath) as! GridTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.lb_question.text = self.cusForm.section[self.sectionIndex].form[idx].question
                cell.lb_number.text = String(indexPath.row)
                self.uiTable.shadow(vw_layout: cell.vw_layout)
                if self.cusForm.section[self.sectionIndex].form[idx].required{
                    cell.lb_number.text = cell.lb_number.text!+"*"
                }
                var col = [CustomFormOption]()
                for i in 0..<self.cusForm.section[self.sectionIndex].form[idx].option.count{
                    var op = CustomFormOption()
                    op.checked = self.cusForm.section[self.sectionIndex].form[idx].option[i].checked
                    op.question = self.cusForm.section[self.sectionIndex].form[idx].option[i].question
                    col.append(op)
                }
                var row = [CustomFormGridOption]()
                for i in 0..<self.cusForm.section[self.sectionIndex].form[idx].choice.count{
                    var op = CustomFormGridOption()
                    op.question = self.cusForm.section[self.sectionIndex].form[idx].choice[i].question
                    row.append(op)
                }
                if self.answer[self.sectionIndex].answer.count > idx{
                cell.answer = self.answer[self.sectionIndex].answer[idx]
                }
                cell.column = col
                cell.row = row
                cell.setDelegate()
                cell.tableQuestion.layoutIfNeeded()
                cell.tableRow.layoutIfNeeded()
                if isAns{
                    cell.tableQuestion.isUserInteractionEnabled = false
                    cell.tableRow.isUserInteractionEnabled = false
                }
                cell.cons_question_height.constant = cell.tableQuestion.contentSize.height
                cell.cons_ans_height.constant = cell.tableRow.contentSize.height
                //cell.cons_scrollView_height.constant = cell.tableQuestion.contentSize.height
                cell.cons_traling.constant = CGFloat(col.count*100)
                cell.cons_height_row.constant = cell.tableRow.contentSize.height
                return cell
            }
        }
    }
    func addPicture(sender:UIButton){
        self.isPic = true
        self.questionIndex = sender.tag
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
        for i in 0..<self.images.count{
            if self.images[i].section == self.sectionIndex && self.images[i].question == self.questionIndex{
                self.images[i].img = image
                break
            }
        }
        try! Realm().write {
            self.answer[self.sectionIndex].answer[self.questionIndex].requiredChecked = true
        }
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
        if self.cusForm.section[self.sectionIndex].form[indexPath.row-1].type == "calendar"{
            if self.answer[self.sectionIndex].answer[indexPath.row-1].answer != ""{
                self.datePicker.date = self.helper.stringToDateOnlyDate(date: self.answer[self.sectionIndex].answer[indexPath.row-1].answer)
            }else{
                self.datePicker.date = Date()
            }
            self.questionIndex = indexPath.row-1
            self.vw_filter.isHidden = false
            self.vw_datePicker.isHidden = false
            self.picker.isHidden = true
            self.datePicker.isHidden = false
            self.isPicker = false
        }else if self.cusForm.section[self.sectionIndex].form[indexPath.row-1].type == "drop"{
            self.pickerArray = [String]()
            for i in 0..<self.cusForm.section[self.sectionIndex].form[indexPath.row-1].option.count{
                self.pickerArray.append(self.cusForm.section[self.sectionIndex].form[indexPath.row-1].option[i].question)
            }
            self.questionIndex = indexPath.row-1
            self.picker.reloadAllComponents()
            self.picker.isHidden = false
            self.vw_filter.isHidden = false
            self.vw_datePicker.isHidden = false
            self.datePicker.isHidden = true
            self.isPicker = true
        }
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.isTyping{
            if self.helper.inBound(x: touch.location(in: self.vw_tf).x, y: touch.location(in: self.vw_tf).y, view: self.vw_tf){
                
                return false
            }else{
                self.vw_tf.resignFirstResponder()
                return true
            }
            
        }
        return false
    }
    func back_action(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "video"{
            if let des = segue.destination as? WebviewVideoViewController{
                des.link = self.link
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
