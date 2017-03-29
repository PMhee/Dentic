//
//  PatientProfileViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/22/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class PatientProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var isPhysician = false
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var cons_y: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var picker_image: UIPickerView!
    @IBOutlet weak var picker_payment: UIPickerView!
    @IBOutlet weak var picker_nation: UIPickerView!
    @IBOutlet weak var picker_gender: UIPickerView!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var vw_picker: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var picker_group: UIPickerView!
    @IBAction func btn_confirm_action(_ sender: UIButton) {
        switch self.state {
        case 0:
            self.patientInfo[2] = self.pickers[self.index]
        case 1:
            print(self.index)
            self.patientInfo[5] = self.pickers[self.index]
        case 2:
            self.patientInfo[8] = self.pickers[self.index]
        case 3:
            self.patientInfo[3] = self.helper.dateToStringOnlyDate(date: self.datePicker.date)
        case 4:
            self.selectedGroup = self.group[self.index]
            self.groupindex = self.index
            self.patientInfo[9] = self.pickers[self.index]
        default:
            if self.index == 0{
                self.openCamera()
            }else{
                self.openGallery()
            }
        }
        self.picker_payment.isHidden = true
        self.picker_gender.isHidden = true
        self.picker_nation.isHidden = true
        self.picker_image.isHidden = true
        self.datePicker.isHidden = true
        self.vw_picker.isHidden  = true
        self.vw_filter.isHidden = true
        self.tableView.reloadData()
    }
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.picker_payment.isHidden = true
        self.picker_gender.isHidden = true
        self.picker_nation.isHidden = true
        self.picker_image.isHidden = true
        self.datePicker.isHidden = true
        self.vw_picker.isHidden = true
        self.vw_filter.isHidden = true
    }
    var groupindex : Int = 0
    var group = try! Realm().objects(RealmGroup.self)
    var apiGroup = APIGroup()
    var isCreate = false
    var ui = UILoading()
    var system = BackSystem()
    var api = APIPatient()
    var dontUp = false
    var img : UIImage!
    var back = BackPatient()
    var inType = false
    var index = 0
    var state = 0
    var pickers = [String]()
    var profileField = [String]()
    var patient = RealmPatient()
    var patientInfo = [String]()
    var keyboardHeight : CGFloat = 0
    var helper = Helper()
    var selectedGroup = RealmGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initValue()
        self.act.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        let button: UIButton = UIButton()
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(confirm), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:40, height:40)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        self.setUI()
        self.gesture.delegate = self
        self.view.addGestureRecognizer(self.gesture)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isCreate{
            self.selectedGroup = self.patient.group!
        }else{
            self.selectedGroup = self.group[0]
        }
        if !isCreate && self.patient.dob != nil{
            self.datePicker.date = self.patient.dob
        }
    }
    func confirm(sender:UIButton){
        self.vw_filter.isHidden = false
        self.act.isHidden = false
        self.act.startAnimating()
        var phoneno = [String]()
        phoneno.append(self.patientInfo[7])
        if self.isCreate{
            self.api.newPatient(sessionID: self.system.getSessionid(), success: {(success) in
                var idd : String = ""
                var hn : String = ""
                if let content = success.value(forKey: "content") as? NSDictionary{
                    if let ID = content.value(forKey: "_id") as? NSDictionary{
                        if let id = ID.value(forKey: "$id") as? String{
                            idd = id
                        }
                    }
                    if let HN = content.value(forKey: "HN") as? String{
                        hn = HN
                    }
                }
                if self.patientInfo[1] != ""{
                    hn = self.patientInfo[1]
                }
                self.api.updatePatient(sessionID: self.system.getSessionid(), patientid: idd, HN: hn, name: self.patientInfo[0], gender: self.patientInfo[2], nationality: self.patientInfo[5], residentaddr: self.patientInfo[6], idno: self.patientInfo[4], dob: self.helper.dateToServer(date: self.datePicker.date), phoneno: [self.patientInfo[7]], medpayment: self.patientInfo[8], groupid: self.selectedGroup.id, success: {(success) in
                    self.back.updatePatientProfile(name: self.patientInfo[0], HN: hn, gender: self.patientInfo[2], DOB: self.patientInfo[3], passport: self.patientInfo[4], nation: self.patientInfo[5], address: self.patientInfo[6], telephone: self.patientInfo[7], payment: self.patientInfo[8],group:self.selectedGroup, patient: self.patient,isCreate:self.isCreate,id:idd)
                    if self.img != nil{
                        self.api.uploadPatientPic(sessionID: self.system.getSessionid(), patientid: idd, image: self.img, success: {(success) in
                            self.vw_filter.isHidden = true
                            self.act.isHidden = true
                            self.back.saveProfilePic(image: self.img, id: self.patient.id)
                            self.navigationController?.popViewController(animated: false)
                        }, failure: {(error) in
                            self.vw_filter.isHidden = true
                            self.act.isHidden = true
                            self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
                        })
                        
                    }else{
                        self.vw_filter.isHidden = true
                        self.act.isHidden = true
                        self.navigationController?.popViewController(animated: false)
                    }
                }, failure: {(error) in
                    self.vw_filter.isHidden = true
                    self.act.isHidden = true
                    self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
                })
                
                
                
            }, failure: {(error) in
                self.vw_filter.isHidden = true
                self.act.isHidden = true
                self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
            })
        }else{
            self.api.updatePatient(sessionID: self.system.getSessionid(), patientid: self.patient.id, HN: self.patientInfo[1], name: self.patientInfo[0], gender: self.patientInfo[2], nationality: self.patientInfo[5], residentaddr: self.patientInfo[6], idno: self.patientInfo[4], dob: self.helper.dateToServer(date: self.datePicker.date), phoneno: [self.patientInfo[7]], medpayment: self.patientInfo[8], groupid: self.selectedGroup.id, success: {(success) in
                self.back.updatePatientProfile(name: self.patientInfo[0], HN: self.patientInfo[1], gender: self.patientInfo[2], DOB: self.patientInfo[3], passport: self.patientInfo[4], nation: self.patientInfo[5], address: self.patientInfo[6], telephone: self.patientInfo[7], payment: self.patientInfo[8],group:self.selectedGroup, patient: self.patient,isCreate:self.isCreate,id:self.patient.id)
                if self.img != nil{
                    print(self.patient.id)
                    self.api.uploadPatientPic(sessionID: self.system.getSessionid(), patientid: self.patient.id, image: self.img, success: {(success) in
                        self.vw_filter.isHidden = true
                        self.act.isHidden = true
                        self.back.saveProfilePic(image: self.img, id: self.patient.id)
                        self.navigationController?.popViewController(animated: false)
                    }, failure: {(error) in
                        
                    })
                    
                }else{
                    self.vw_filter.isHidden = true
                    self.act.isHidden = true
                    self.navigationController?.popViewController(animated: false)
                }
            }, failure: {(error) in
                self.vw_filter.isHidden = true
                self.act.isHidden = true
                self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
            })
        }
        
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            if self.dontUp{
                
            }else{
                self.cons_y.constant = -self.keyboardHeight
            }
        }
    }
    
    func setUI(){
        self.btn_cancel.layer.masksToBounds = true
        self.btn_cancel.layer.cornerRadius = 2
        self.btn_cancel.layer.borderWidth = 1
        self.btn_cancel.layer.borderColor = UIColor(netHex: 0x1B5391).cgColor
        self.btn_confirm.layer.masksToBounds = true
        self.btn_confirm.layer.cornerRadius = 2
    }
    func initValue(){
        self.profileField = [String]()
        self.profileField.append("Name")
        self.profileField.append("HN")
        self.profileField.append("Gender")
        self.profileField.append("Date of birth")
        self.profileField.append("ID No/Passport No")
        self.profileField.append("Nationality")
        self.profileField.append("Address")
        self.profileField.append("Telephone")
        self.profileField.append("Med Payment")
        self.profileField.append("Group")
        self.patientInfo.append(self.patient.name)
        self.patientInfo.append(self.patient.HN)
        self.patientInfo.append(self.patient.gender)
        if self.patient.dob != nil{
            self.patientInfo.append(self.helper.dateToStringOnlyDate(date: self.patient.dob))
        }else{
            self.patientInfo.append("")
        }
        self.patientInfo.append(self.patient.nationalID)
        self.patientInfo.append(self.patient.nationality)
        self.patientInfo.append(self.patient.address)
        if self.patient.phoneno.count > 0 {
            self.patientInfo.append(self.patient.phoneno[0].phoneno)
        }else{
            var phone = phoneNo()
            phone.phoneno = ""
            self.patientInfo.append(phone.phoneno)
        }
        self.patientInfo.append(self.patient.medpayment)
        if !self.isCreate{
            self.patientInfo.append((self.patient.group?.groupname)!)
        }else{
            
            self.patientInfo.append(self.group[0].groupname)
        }
        self.tableView.reloadData()
    }
    func pickImage(){
        self.state = 5
        self.pickers = [String]()
        self.pickers.append("Camera ")
        self.pickers.append("Gallery")
        self.picker_image.reloadAllComponents()
        self.picker_image.isHidden = false
        self.vw_filter.isHidden = false
        self.vw_picker.isHidden = false
    }
    func pickNation(){
        self.state = 1
        self.pickers = [String]()
        self.pickers.append("TH 🇹🇭")
        self.pickers.append("other 🇪🇺")
        self.picker_nation.reloadAllComponents()
        switch self.patientInfo[5] {
        case "TH":
            self.picker_nation.selectRow(0, inComponent: 0, animated: false)
        case "TH 🇹🇭":
            self.picker_nation.selectRow(0, inComponent: 0, animated: false)
        case "other 🇪🇺":
            self.picker_nation.selectRow(1, inComponent: 0, animated: false)
        default:
            self.picker_nation.selectRow(0, inComponent: 0, animated: false)
        }
        self.picker_nation.isHidden = false
        self.vw_filter.isHidden = false
        self.vw_picker.isHidden = false
    }
    func pickGender(){
        self.state = 0
        self.pickers = [String]()
        self.pickers.append("X")
        self.pickers.append("M")
        self.pickers.append("F")
        self.picker_gender.reloadAllComponents()
        switch self.patientInfo[2] {
        case "X":
            self.picker_gender.selectRow(0, inComponent: 0, animated: false)
        case "M":
            self.picker_gender.selectRow(1, inComponent: 0, animated: false)
        case "F":
            self.picker_gender.selectRow(2, inComponent: 0, animated: false)
        default:
            self.picker_gender.selectRow(0, inComponent: 0, animated: false)
        }
        self.picker_gender.isHidden = false
        self.vw_filter.isHidden = false
        self.vw_picker.isHidden = false
    }
    func pickMedPayment(){
        self.state = 2
        self.pickers = [String]()
        self.pickers.append("N/A")
        self.pickers.append("ข้าราชการ")
        self.pickers.append("ประกันสังคม")
        self.pickers.append("302")
        self.picker_payment.reloadAllComponents()
        switch self.patientInfo[8] {
        case "N/A":
            self.picker_payment.selectRow(0, inComponent: 0, animated: false)
        case "ข้าราชการ":
            self.picker_payment.selectRow(1, inComponent: 0, animated: false)
        case "ประกันสังคม":
            self.picker_payment.selectRow(2, inComponent: 0, animated: false)
        case "302":
            self.picker_payment.selectRow(3, inComponent: 0, animated: false)
        default:
            self.picker_payment.selectRow(0, inComponent: 0, animated: false)
        }
        self.picker_payment.isHidden = false
        self.vw_filter.isHidden = false
        self.vw_picker.isHidden = false
    }
    func pickGroup(){
        self.state = 4
        self.pickers = [String]()
        for i in 0..<self.group.count{
            if self.group[i].id == self.selectedGroup.id{
                self.picker_group.selectRow(i, inComponent: 0, animated: false)
            }
            self.pickers.append(self.group[i].groupname)
        }
        self.picker_group.reloadAllComponents()
        self.picker_group.isHidden = false
        self.vw_filter.isHidden = false
        self.vw_picker.isHidden = false
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickers.count
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if inType{
            self.inType = false
            self.view.endEditing(true)
            return true
        }else{
            return false
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickers[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.index = row
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patientInfo.count+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pic", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let pic = cell.viewWithTag(1) as! UIImageView
            if self.img == nil{
                self.helper.loadLocalProfilePic(id: self.patient.id,image:pic)
            }else{
                pic.image = self.img
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PatientProfilTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if self.profileField[indexPath.row-1] == "ID No/Passport No"{
                cell.icon.image = UIImage(named: "passport")
            }else if self.profileField[indexPath.row-1] == "Group"{
                cell.icon.image = UIImage(named: "group-grey.png")
            }else{
                cell.icon.image = UIImage(named: self.profileField[indexPath.row-1])
            }
            
            if self.patientInfo[indexPath.row-1] != ""{
                cell.tf.text = self.patientInfo[indexPath.row-1]
            }else{
                cell.tf.placeholder = self.profileField[indexPath.row-1]
            }
            if indexPath.row-1 == 7 {
                cell.tf.keyboardType = .numberPad
            }else{
                cell.tf.keyboardType = .default
            }
            cell.tf.tag = indexPath.row-1
            cell.tf.delegate = self
            return cell
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.dontUp = true
            return true
        }else if textField.tag == 2{
            self.pickGender()
            return false
        }else if textField.tag == 3{
            if self.patient.dob != nil{
                self.datePicker.date = self.patient.dob
            }
            self.datePicker.isHidden = false
            self.vw_filter.isHidden = false
            self.vw_picker.isHidden = false
            self.state = 3
            return false
        }else if textField.tag == 5{
            self.pickNation()
            return false
        }else if textField.tag == 8{
            self.pickMedPayment()
            return false
        }else if textField.tag == 7{
            self.inType = true
            return true
        }else if textField.tag == 9{
            self.pickGroup()
            self.inType = true
            return false
        }else{
            return true
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.pickImage()
        }
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
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.img = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.dontUp = false
        if textField.tag == 0 {
            self.patientInfo[0] = textField.text!
        }else if textField.tag == 1{
            self.patientInfo[1] = textField.text!
        }else if textField.tag == 4{
            self.patientInfo[4] = textField.text!
        }else if textField.tag == 6{
            self.patientInfo[6] = textField.text!
        }else if textField.tag == 7{
            self.patientInfo[7] = textField.text!
        }
        self.cons_y.constant = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 180
        }else{
            return 50
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
