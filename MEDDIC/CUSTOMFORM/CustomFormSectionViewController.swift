//
//  CustomFormSectionViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/23/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class CustomFormSectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDelegateFlowLayout {
    var isCreate = false
    var cusform = CustomForm()
    var color = Color()
    var uiTable = UITable()
    var colors = [Int]()
    var indexColor = 0
    var back = BackCustomForm()
    var helper = Helper()
    var iconPic = [String]()
    var category = [String]()
    var indexPicker = 0
    var indexIcon = 0
    var indexSection = 0
    let sectionInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
    var api = APIAddCustomForm()
    var system = BackSystem()
    var ui = UILoading()
    
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var vw_section: UIView!
    @IBOutlet weak var vw_section_top: UIView!
    @IBOutlet weak var lb_vw_section_section: UILabel!
    @IBOutlet weak var tf_name_vw_section: UITextField!
    @IBOutlet weak var lb_name_vw_section: UILabel!
    @IBOutlet weak var tf_description_vw_section: UITextField!
    @IBOutlet weak var lb_description_vw_section: UILabel!
    @IBOutlet weak var btn_cancel_vw_section: UIButton!
    @IBOutlet weak var btn_confirm_vw_section: UIButton!
    @IBOutlet weak var collection_color_vw_section: UICollectionView!
    @IBOutlet weak var vw_cusform_edit: UIView!
    @IBOutlet weak var collection_icon: UICollectionView!
    @IBOutlet weak var vw_picker: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var btn_cancel_picker: UIButton!
    @IBOutlet weak var btn_confirm_picker: UIButton!
    @IBOutlet weak var img_cusform_icon: UIImageView!
    
    @IBAction func btn_cancel_picker_action(_ sender: UIButton) {
        self.vw_filer_picker.isHidden = true
        self.vw_picker.isHidden = true
    }
    @IBAction func btn_confirm_picker_action(_ sender: UIButton) {
        self.vw_filer_picker.isHidden = true
        self.vw_picker.isHidden = true
        self.tf_cusform_category.text = self.category[self.indexPicker]
    }
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.vw_filter.isHidden = true
        self.vw_cusform_edit.isHidden = true
    }
    @IBAction func btn_confirm_action(_ sender: UIButton) {
        if self.tf_cusform_name.text! == ""{
            let alertController = UIAlertController(title: "Error", message: "Please Fill CustomForm Name", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else if self.tf_cusform_category.text! == ""{
            let alertController = UIAlertController(title: "Error", message: "Please Fill CustomForm Category", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.vw_filer_picker.isHidden = false
            self.act.isHidden = false
            self.act.startAnimating()
            self.api.updateCFCover(sessionid: self.system.getSessionid(), cusformid: self.cusform.id, name: self.tf_cusform_name.text!, description: self.tf_cusform_des.text!, meshtagid: [], color: self.colors[self.indexColor], picurl: self.iconPic[self.indexIcon], success: {(success) in
                self.vw_filer_picker.isHidden = true
                self.act.isHidden = true
                self.vw_filter.isHidden = true
                if let content = success.value(forKey: "content") as? NSDictionary{
                    if let updatetime = content.value(forKey: "updatetime") as? String{
                        self.back.updateCustomForm(title: self.tf_cusform_name.text!, des: self.tf_cusform_des.text!, category: self.tf_cusform_category.text!, color: self.colors[self.indexColor], icon: self.iconPic[self.indexIcon], cusForm: self.cusform,updatetime:updatetime)
                        self.vw_filter.isHidden = true
                        self.vw_cusform_edit.isHidden = true
                        self.tableView.reloadData()
                    }
                }
                self.navigationController?.navigationBar.barTintColor = UIColor(netHex:self.cusform.color)
            }, failure: {(error) in
                self.ui.showErrorNav(error: "Internet connection error", view: self.view)
            })
            
        }
    }
    @IBAction func btn_cancel_vw_section_action(_ sender: UIButton) {
        self.vw_filter.isHidden = true
        self.vw_section.isHidden = true
    }
    @IBAction func btn_confirm_vw_section_action(_ sender: UIButton) {
        if self.tf_name_vw_section.text! == ""{
            let alertController = UIAlertController(title: "Error", message: "Please Fill Title field", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.vw_filer_picker.isHidden = false
            self.act.isHidden = false
            self.act.startAnimating()
            self.api.createCFSection(sessionid: self.system.getSessionid(), cusformid: self.cusform.id, sectionno: String(self.cusform.section.count), name: self.tf_name_vw_section.text!, description: self.tf_description_vw_section.text!, formula: [], color: self.color.backEndColor(color: self.colors[self.indexColor]), success: {(success) in
                self.vw_filer_picker.isHidden = true
                self.act.isHidden = true
                self.vw_filter.isHidden = true
                if let content = success.value(forKey: "content") as? NSDictionary{
                    if let ID = content.value(forKey: "_id") as? NSDictionary{
                        if let id = ID.value(forKey: "$id") as? String{
                            if let updatetime = content.value(forKey: "updatetime") as? String{
                                self.back.updateTime(updatetime: updatetime, cusform: self.cusform)
                            }
                            self.back.createSection(title: self.tf_name_vw_section.text!, des: self.tf_description_vw_section.text!, color: self.colors[self.indexColor], cusForm: self.cusform,id:id)
                            self.vw_filer_picker.isHidden = true
                            self.vw_section.isHidden = true
                            self.tableView.reloadData()
                            
                        }
                    }
                }
            }, failure: {(error) in
                self.ui.showErrorNav(error: "Connection problem", view: self.view)
            })
            
        }
    }
    @IBAction func tf_name_vw_section_change(_ sender: UITextField) {
        if sender.text! == ""{
            self.lb_name_vw_section.isHidden = true
        }else{
            self.lb_name_vw_section.isHidden = false
        }
    }
    @IBAction func tf_description_vw_section_change(_ sender: UITextField) {
        if sender.text! == ""{
            self.lb_description_vw_section.isHidden = true
        }else{
            self.lb_description_vw_section.isHidden = false
        }
    }
    @IBOutlet weak var vw_cusform_top: UIView!
    @IBOutlet weak var tf_cusform_name: UITextField!
    @IBOutlet weak var tf_cusform_category: UITextField!
    @IBOutlet weak var tf_cusform_des: UITextField!
    @IBOutlet weak var vw_filer_picker: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.initValue()
        self.act.isHidden = true
        self.tf_name_vw_section.delegate = self
        self.tf_description_vw_section.delegate = self
        self.helper.setButtomBorder(tf: self.tf_name_vw_section)
        self.helper.setButtomBorder(tf: self.tf_description_vw_section)
        self.tf_cusform_name.delegate = self
        self.tf_cusform_category.delegate = self
        self.tf_cusform_des.delegate = self
        self.helper.setButtomBorder(tf: self.tf_cusform_name)
        self.helper.setButtomBorder(tf: self.tf_cusform_des)
        self.helper.setButtomBorder(tf: self.tf_cusform_category)
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex:0x587EBF)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.colors = self.color.listColor()
        if isCreate{
            self.cusform = try! Realm().objects(CustomForm.self).last!
        }
        self.collection_icon.backgroundColor = UIColor(netHex: self.cusform.color)
        self.iconPic = [String]()
        self.api.listCfPresetIcon(sessionid: self.system.getSessionid(), success: {(success) in
            if let array = success.value(forKey: "content") as? NSArray{
                self.iconPic = [String]()
                for  i in 0..<array.count{
                    self.iconPic.append(array[i] as! String)
                }
                
            }
            self.collection_icon.reloadData()
        }, failure: {(error) in
            
        })
        
        self.category = [String]()
        self.category.append("Cardiology")
        self.category.append("Orthopedic")
        self.category.append("Pediatric")
        self.category.append("Medicine")
        self.category.append("Surgery")
        self.tableView.reloadData()
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex:self.cusform.color)
        if !self.cusform.isDownload && !isCreate{
            self.vw_filter.isHidden = false
            self.act.isHidden = false
            self.act.startAnimating()
            self.api.getCusform(sessionid: self.system.getSessionid(), cusformid: self.cusform.id, success: {(success) in
                self.vw_filter.isHidden = true
                self.act.isHidden = true
                self.back.downloadCusForm(json: success,form:self.cusform)
                self.navigationController?.navigationBar.barTintColor = UIColor(netHex:self.cusform.color)
                self.tableView.reloadData()
                
            }, failure: {(error) in
                self.ui.showErrorNav(error: "Internet connection error", view: self.view)
                self.vw_filter.isHidden = false
                self.act.isHidden = false
            })
        }
    }
    func initValue(){
        self.tf_cusform_name.text = self.cusform.title
        self.tf_cusform_category.text = self.cusform.category
        self.tf_cusform_des.text = self.cusform.des
        for i in 0..<self.iconPic.count{
            if self.cusform.icon == self.iconPic[i]{
                self.indexIcon = i
                self.img_cusform_icon.image = UIImage(named: self.iconPic[i])
                break
            }
        }
        for i in 0..<self.colors.count{
            if self.cusform.color == self.colors[i]{
                self.indexColor = i
                self.vw_cusform_top.backgroundColor = UIColor(netHex: self.colors[i])
                break
            }
        }
    }
    func setUI(){
        self.btn_cancel_vw_section.layer.cornerRadius = 2
        self.btn_cancel_vw_section.layer.masksToBounds = true
        self.btn_cancel_vw_section.layer.borderWidth = 1
        self.btn_cancel_vw_section.layer.borderColor = UIColor(netHex: 0x27916F).cgColor
        self.btn_confirm_vw_section.layer.cornerRadius = 2
        self.btn_confirm_vw_section.layer.masksToBounds = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "add.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(addNew), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:20, height:20)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    func addNew(sender:UIButton){
        self.vw_section.isHidden = false
        self.vw_filter.isHidden = false
        self.lb_name_vw_section.isHidden = true
        self.lb_description_vw_section.isHidden = true
        self.tf_name_vw_section.text = ""
        self.tf_description_vw_section.text = ""
        self.indexColor = 0
        self.vw_section_top.backgroundColor = UIColor(netHex: self.colors[self.indexColor])
        self.lb_vw_section_section.textColor = self.color.letterColor(color: self.colors[self.indexColor])
        self.collection_color_vw_section.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1{
            self.vw_picker.isHidden = false
            self.vw_filer_picker.isHidden = false
            self.picker.reloadAllComponents()
            for i in 0..<self.category.count{
                if self.category[i] == self.cusform.category{
                    self.indexPicker = i
                    self.picker.selectRow(i, inComponent: 0, animated: true)
                    break
                }
            }
            return false
        }else{
            return true
        }
    }
    func calculator(sender:UIButton){
        self.performSegue(withIdentifier: "calculate", sender: self)
    }
    func showForm(sender:UIButton){
        self.performSegue(withIdentifier: "cusform", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! SectionHeaderTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            self.helper.downloadImageFrom(link: self.cusform.icon, contentMode: .scaleAspectFill, img: cell.img_icon)
            cell.lb_title.text = self.cusform.title
            cell.lb_category.text = self.cusform.category
            cell.btn_eye.tag = 1
            cell.btn_calculator.tag = 2
            cell.btn_calculator.addTarget(self, action: #selector(calculator), for: .touchUpInside)
            cell.btn_eye.addTarget(self, action: #selector(showForm), for: .touchUpInside)
            cell.contentView.backgroundColor = UIColor(netHex:self.cusform.color)
            cell.lb_title.textColor = self.color.letterColor(color: self.cusform.color)
            cell.lb_category.textColor = self.color.letterColor(color: self.cusform.color)
            if self.color.isBlack(color:self.cusform.color){
                cell.btn_eye.setImage(UIImage(named:"eye-dark.png"), for: .normal)
                cell.btn_calculator.setImage(UIImage(named:"calculator-dark.png"), for: .normal)
            }else{
                cell.btn_eye.setImage(UIImage(named:"eye-white.png"), for: .normal)
                cell.btn_calculator.setImage(UIImage(named:"calculator-white.png"), for: .normal)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let vw_section_color = cell.viewWithTag(1)
            let lb_number = cell.viewWithTag(2) as! UILabel
            let lb_title = cell.viewWithTag(3) as! UILabel
            let lb_description = cell.viewWithTag(4) as! UILabel
            let vw_layout = cell.viewWithTag(5)
            vw_section_color?.backgroundColor = UIColor(netHex:self.cusform.section[indexPath.row-1].colorMain)
            lb_number.text = String(indexPath.row)
            lb_number.textColor = self.color.letterColor(color: self.cusform.section[indexPath.row-1].colorMain)
            lb_title.text = self.cusform.section[indexPath.row-1].sectionName
            lb_description.text = self.cusform.section[indexPath.row-1].des
            self.uiTable.shadow(vw_layout: vw_layout!)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cusform.section.count+1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.initValue()
            self.isCreate = true
            self.vw_cusform_edit.isHidden = false
            self.vw_filter.isHidden = false
        }else{
            self.indexSection = indexPath.row-1
            self.performSegue(withIdentifier: "select", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 120
        }else{
            return 110
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return self.iconPic.count
        }else{
            return self.colors.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon", for: indexPath)
            let icon = cell.viewWithTag(1) as! UIImageView
            self.helper.downloadImageFrom(link: self.iconPic[indexPath.row], contentMode: .scaleAspectFill, img: icon)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath)
            cell.backgroundColor = UIColor(netHex: self.colors[indexPath.row])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            self.indexIcon = indexPath.row
            self.helper.downloadImageFrom(link: self.iconPic[indexPath.row], contentMode: .scaleAspectFill, img: self.img_cusform_icon)
        }else{
            self.indexColor = indexPath.row
            self.vw_section_top.backgroundColor = UIColor(netHex: self.colors[indexPath.row])
            self.lb_vw_section_section.textColor = self.color.letterColor(color: self.colors[indexPath.row])
            self.vw_cusform_top.backgroundColor = UIColor(netHex: self.colors[indexPath.row])
            self.collection_icon.backgroundColor = UIColor(netHex: self.colors[indexPath.row])
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            let paddingSpace = sectionInsets.left * (3 + 1)
            let availableWidth = self.vw_cusform_edit.frame.width - paddingSpace
            let widthPerItem = availableWidth / 4
            return CGSize(width: widthPerItem, height: widthPerItem)
        }else{
            return CGSize(width:50,height:50)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.category.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.indexPicker = row
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 50))
        let pic = UIImageView(frame: CGRect(x: self.view.frame.width*0.35, y: 10, width: 25, height: 25))
        let lb = UILabel(frame: CGRect(x:self.view.frame.width*0.45, y: 0, width: pickerView.frame.width-55, height: 50))
        pic.image = UIImage(named: self.category[row])
        lb.text = self.category[row]
        vw.addSubview(pic)
        vw.addSubview(lb)
        return vw
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select"{
            if let des = segue.destination as? CustomFormQuestionViewController{
                des.section = self.cusform.section[self.indexSection]
                des.sectionIndex = self.indexSection
                des.cusForm = self.cusform
                des.sectionno = self.indexSection
            }
        }else if segue.identifier == "calculate"{
            if let des = segue.destination as? CustomFormEquationViewController{
                des.cusForm = self.cusform
                des.sectionIndex = 0
                des.isSection = true
            }
        }else if segue.identifier == "cusform"{
            if let des = segue.destination as? ShowCustomFormViewController{
                des.cusForm = self.cusform
                des.isView = true
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
