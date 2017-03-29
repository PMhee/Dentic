

//
//  AddFormTitleViewController.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/1/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class AddFormTitleViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource {
    var inType = false
    @IBOutlet weak var tf_ward: UITextField!
    @IBOutlet weak var lb_ward: UILabel!
    @IBOutlet weak var lb_title: UILabel!
    struct Ward {
        var id : String!
        var name : String!
    }
    var helper = Helper()
    var api = APIAddCustomForm()
    var back = BackCustomForm()
    var backSystem = BackSystem()
    var indexIcon :Int = 0
    var indexColor : Int = 4
    let sectionInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
    var ward = [Ward]()
    var index : Int = 0
    var color = Color()
    var colorArray = [Int]()
    var iconPic = [String]()
    var cfcolor : UIColor!
    var category = [String]()
    var system = BackSystem()
    var ui = UILoading()
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var collectionView_color: UICollectionView!
    @IBOutlet weak var collectionView_icon: UICollectionView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var vw_icon: UIView!
    @IBOutlet weak var cons_y: NSLayoutConstraint!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var vw_ward: UIView!
    @IBOutlet weak var vw_layout: UIView!
    @IBOutlet weak var tv_description: UITextView!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var vw_title: UIView!
    @IBOutlet weak var tf_title: UITextField!
    @IBOutlet weak var vw_category_picker: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var vw_filter_category: UIView!
    
    @IBAction func btn_done_action(_ sender: UIButton) {
        self.vw_filter.isHidden = true
        self.vw_icon.isHidden = true
    }
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.vw_filter.isHidden = true
        self.vw_icon.isHidden = true
    }
    @IBOutlet weak var btn_picker_cancel: UIButton!
    @IBOutlet weak var btn_picker_confirm: UIButton!
    @IBAction func btn_picker_cancel_action(_ sender: UIButton) {
        self.vw_filter_category.isHidden = true
        self.vw_category_picker.isHidden = true
    }
    @IBAction func btn_picker_confirm_action(_ sender: UIButton) {
        self.tf_ward.text = self.category[self.index]
        self.vw_filter_category.isHidden = true
        self.vw_category_picker.isHidden = true
    }
    
    
    @IBAction func btn_ward_action(_ sender: UIButton) {
        self.vw_filter_category.isHidden = false
        self.vw_category_picker.isHidden = false
        self.picker.reloadAllComponents()
    }
    @IBOutlet weak var img_icon: UIImageView!
    @IBAction func btn_change_icon_action(_ sender: UIButton) {
        self.vw_filter.isHidden = false
        self.vw_icon.isHidden = false
        self.collectionView_icon.reloadData()
        self.collectionView_color.reloadData()
    }
    @IBOutlet weak var cons_ward_height: NSLayoutConstraint!
    @IBAction func btn_next_action(_ sender: UIButton) {
        if self.tf_title.text! == ""{
            let alertController = UIAlertController(title: "Error", message: "Please Fill Title field", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else if self.tf_ward.text! == ""{
            let alertController = UIAlertController(title: "Error", message: "Please Fill Category field", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            var icon : String = ""
            self.api.createCFCover(sessionid: self.system.getSessionid(), name: self.tf_title.text!, description: self.tv_description.text!, meshtagid: [], formula: [], color: self.colorArray[self.indexColor], picurl: self.iconPic[self.indexIcon], success: {(success) in
                if let content = success.value(forKey: "content") as? NSDictionary{
                    if let ID = content.value(forKey: "_id") as? NSDictionary{
                        if let id = ID.value(forKey: "$id") as? String{
                            if let updatetime = content.value(forKey: "updatetime") as? String{
                                self.back.createCustomForm(title: self.tf_title.text!, des: self.tv_description.text!, category: self.tf_ward.text!, color: self.colorArray[self.indexColor],icon:self.iconPic[self.indexIcon],id:id,updatetime:updatetime)
                            self.performSegue(withIdentifier: "create", sender: self)
                            }
                        }
                    }
                }
                
                
            }, failure: {(error) in
                self.ui.showErrorNav(error: "Internet connection error", view: self.view)
            })
        }
    }
    @IBAction func tf_title_begin(_ sender: UITextField) {
        self.inType = true
        vw_title.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
    }
    @IBAction func tf_title_end(_ sender: UITextField) {
        self.inType = false
        vw_title.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    }
    @IBAction func tf_title_change(_ sender: UITextField) {
        if sender.text! == ""{
            self.lb_title.isHidden = true
        }else{
            self.lb_title.isHidden = false
        }
    }
    @IBAction func tf_ward_change(_ sender: UITextField) {
        if sender.text! == ""{
            self.lb_ward.isHidden = true
        }else{
            self.lb_ward.isHidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tv_description.layer.borderWidth = 1
//        self.tv_description.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0).cgColor
        self.gesture.delegate = self
        self.tf_title.delegate = self
        self.tv_description.delegate = self
        self.view.addGestureRecognizer(self.gesture)
        self.btn_picker_cancel.layer.cornerRadius = 2
        self.btn_picker_cancel.layer.borderWidth = 1
        self.btn_picker_cancel.layer.borderColor = UIColor(netHex: 0x1B5391).cgColor
        self.btn_picker_cancel.layer.masksToBounds = true
        self.btn_picker_confirm.layer.cornerRadius = 2
        self.btn_picker_confirm.layer.masksToBounds = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.colorArray = self.color.listColor()
        self.iconPic = [String]()
        self.api.listCfPresetIcon(sessionid: self.system.getSessionid(), success: {(success) in
            if let array = success.value(forKey: "content") as? NSArray{
                self.iconPic = [String]()
                for  i in 0..<array.count{
                    self.iconPic.append(array[i] as! String)
                }
            }
            self.collectionView_icon.reloadData()
        }, failure: {(error) in
            
        })
        self.category = [String]()
        self.category.append("Cardiology")
        self.category.append("Orthopedic")
        self.category.append("Pediatric")
        self.category.append("Medicine")
        self.category.append("Surgery")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if inType {
            self.tf_title.resignFirstResponder()
            self.tv_description.resignFirstResponder()
            return true
        }
        return false
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.inType = true
        self.cons_y.constant -= 200
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.inType = false
        self.cons_y.constant += 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lb = cell.viewWithTag(1) as! UILabel
        lb.text = ward[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ward.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = vw_layout.viewWithTag(10)
        self.vw_ward.alpha = 0
        tag?.removeFromSuperview()
        self.index = indexPath.row
        self.btn_cancel.isHidden = true
        self.tf_ward.text = self.ward[indexPath.row].name
        self.lb_ward.isHidden = false
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.iconPic.count
        }else{
            return self.colorArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let icon = cell.viewWithTag(1) as! UIImageView
            let tick = cell.viewWithTag(2) as! UILabel
            let vw = cell.viewWithTag(3)
            self.helper.downloadImageFrom(link: self.iconPic[indexPath.row], contentMode: .scaleAspectFill, img: icon)
            if self.indexIcon != nil{
                if indexPath.row == self.indexIcon{
                    tick.isHidden = false
                }else{
                    tick.isHidden = true
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let tick = cell.viewWithTag(1) as! UILabel
            let vw = cell.viewWithTag(2)
            if self.indexColor != nil{
                if indexPath.row == self.indexColor{
                    tick.isHidden = false
                }else{
                    tick.isHidden = true
                }
            }
            self.collectionView_color.layoutIfNeeded()
            vw?.backgroundColor = UIColor(netHex:self.colorArray[indexPath.row])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            self.indexIcon = indexPath.row
            self.helper.downloadImageFrom(link: self.iconPic[indexPath.row], contentMode: .scaleAspectFill, img: self.img_icon)
            self.collectionView_icon.reloadData()
            self.collectionView_color.reloadData()
        }else{
            self.indexColor = indexPath.row
            self.collectionView_icon.backgroundColor = UIColor(netHex: self.colorArray[indexPath.row])
            self.vw_top.backgroundColor =
                UIColor(netHex: self.colorArray[indexPath.row])
            self.collectionView_icon.reloadData()
            self.collectionView_color.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let paddingSpace = sectionInsets.left * (3 + 1)
            let availableWidth = self.vw_icon.frame.width - paddingSpace
            let widthPerItem = availableWidth / 4
            return CGSize(width: widthPerItem, height: widthPerItem)
        }else{
            let paddingSpace = sectionInsets.left * (3 + 1)
            let availableWidth = self.vw_icon.frame.width - paddingSpace
            let widthPerItem = availableWidth / 4
            return CGSize(width: 40, height: 40)
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.category.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.index = row
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
        if segue.identifier == "create"{
            if let des = segue.destination as? CustomFormSectionViewController{
                des.isCreate = true
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
