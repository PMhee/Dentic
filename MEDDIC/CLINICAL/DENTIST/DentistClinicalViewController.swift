//
//  DentistClinicalViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/27/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import AVFoundation
class DentistClinicalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    struct Image {
        var isSet = false
        var img = UIImage()
    }
    @IBOutlet weak var btn_history: UIButton!
    @IBOutlet weak var btn_profile: UIButton!
    @IBOutlet weak var vw_note: UIView!
    var uiTable = UITable()
    //Camera//
    let captureSession = AVCaptureSession()
    //
    var back = BackPatient()
    var inType = false
    //Init Value
    var state = 0
    //-*******-//
    //Setting External
    var external_oral = ["FACIAL หน้าตรง","FACIAL LEFT 45º","FACIAL LEFT 90º","FACIAL RIGHT 45º","FACIAL RIGHT 90º","LIP หน้าตรง","LIP LEFT","LIP RIGHT"]
    var external_oral_image = [Image]()
    var external_index = 0
    //-*******-//
    //Setting Internal
    var internal_oral = ["INTERNAL ORAL"]
    var internal_oral_image = [Image]()
    var internal_index = 0
    //-*******-//
    //Setting Film
    var film_oral = ["CEPH","PANA","PA"]
    var film_oral_image = [Image]()
    var film_index = 0
    //
    //Setting Lime
    var lime_oral = ["LIME"]
    var lime_oral_image = [Image]()
    var lime_index = 0
    //
    //DatePicker
    @IBOutlet weak var vw_datePicker: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var btn_date: UIButton!
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.vw_filter.isHidden = true
        self.vw_datePicker.isHidden = true
    }
    @IBAction func btn_confirm_action(_ sender: UIButton) {
        if self.datePicker.date > Date(){
            let alertController = UIAlertController(title: "Error", message: "Date is beyond today.Cannot save the clinical note", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.vw_filter.isHidden = true
            self.vw_datePicker.isHidden = true
            self.btn_date.setTitle(self.helper.dateToStringOnlyDate(date: self.datePicker.date), for: .normal)
        }
    }
    @IBAction func btn_select_date_action(_ sender: UIButton) {
        self.vw_filter.isHidden = false
        self.vw_datePicker.isHidden = false
    }
    
    //
    var isFirst = false
    var helper = Helper()
    var patient = RealmPatient()
    @IBOutlet var gesture: UIGestureRecognizer!
    @IBOutlet var lb_telephone: UILabel!
    @IBOutlet var lb_age: UILabel!
    @IBOutlet var lb_hn: UILabel!
    @IBOutlet var lb_name: UILabel!
    @IBOutlet var img_profile: UIImageView!
    @IBOutlet weak var btn_external: UIButton!
    @IBOutlet weak var btn_internal: UIButton!
    @IBOutlet weak var btn_film: UIButton!
    @IBOutlet weak var btn_lime: UIButton!
    @IBOutlet weak var lb_pointer_external: UILabel!
    @IBOutlet weak var lb_pointer_internal: UILabel!
    @IBOutlet weak var lb_pointer_film: UILabel!
    @IBOutlet weak var lb_pointer_lime: UILabel!
    @IBOutlet var tv_clinical_note: UITextView!
    @IBOutlet var lb_cover_clinical_note: UILabel!
    @IBOutlet weak var vw_show_image: UIView!
    @IBOutlet weak var img_show_image: UIImageView!
    @IBOutlet weak var vw_scroll_show_image: UIScrollView!
    @IBOutlet weak var btn_compare: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cons_table_height: NSLayoutConstraint!
    
    @IBAction func btn_history_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "history", sender: self)
    }
    @IBAction func btn_profile_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "profile", sender: self)
    }
    @IBAction func btn_annotate_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "annotate", sender: self)
    }
    @IBAction func btn_close_vw_show_image_action(_ sender: UIButton) {
        self.vw_show_image.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func btn_exter_action(_ sender: UIButton) {
        self.btn_external.setTitleColor(UIColor(netHex:0x354590), for: .normal)
        self.btn_internal.setTitleColor(UIColor.black, for: .normal)
        self.btn_film.setTitleColor(UIColor.black, for: .normal)
        self.btn_lime.setTitleColor(UIColor.black, for: .normal)
        self.state = 0
        self.lb_pointer_external.isHidden = false
        self.lb_pointer_internal.isHidden = true
        self.lb_pointer_film.isHidden = true
        self.lb_pointer_lime.isHidden = true
    }
    @IBAction func btn_internal_action(_ sender: UIButton) {
        self.btn_external.setTitleColor(UIColor.black, for: .normal)
        self.btn_internal.setTitleColor(UIColor(netHex:0x354590), for: .normal)
        self.btn_film.setTitleColor(UIColor.black, for: .normal)
        self.btn_lime.setTitleColor(UIColor.black, for: .normal)
        self.state = 1
        self.lb_pointer_external.isHidden = true
        self.lb_pointer_internal.isHidden = false
        self.lb_pointer_film.isHidden = true
        self.lb_pointer_lime.isHidden = true
    }
    @IBAction func btn_film_action(_ sender: UIButton) {
        self.btn_external.setTitleColor(UIColor.black, for: .normal)
        self.btn_internal.setTitleColor(UIColor.black, for: .normal)
        self.btn_film.setTitleColor(UIColor(netHex:0x354590), for: .normal)
        self.btn_lime.setTitleColor(UIColor.black, for: .normal)
        self.state = 2
        self.lb_pointer_external.isHidden = true
        self.lb_pointer_internal.isHidden = true
        self.lb_pointer_film.isHidden = false
        self.lb_pointer_lime.isHidden = true
    }
    @IBAction func btn_lime_action(_ sender: UIButton) {
        self.btn_external.setTitleColor(UIColor.black, for: .normal)
        self.btn_internal.setTitleColor(UIColor.black, for: .normal)
        self.btn_film.setTitleColor(UIColor.black, for: .normal)
        self.btn_lime.setTitleColor(UIColor(netHex:0x354590), for: .normal)
        self.state = 3
        self.lb_pointer_external.isHidden = true
        self.lb_pointer_internal.isHidden = true
        self.lb_pointer_film.isHidden = true
        self.lb_pointer_lime.isHidden = false
    }
    
    @IBAction func btn_compare_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "compare", sender: self)
    }
    func btn_update_action(sender:UIBarButtonItem){
        self.back.createDentFollowUp(date: self.datePicker.date, note: self.tv_clinical_note.text!, extra_image: self.external_oral_image, intra_image: self.internal_oral_image, film_image: self.film_oral_image, lime_image: self.lime_oral_image, patient: self.patient)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(addAnnotateImage(notification:)), name: NSNotification.Name(rawValue: "DentaddAnnotateImage"), object: nil)
        for i in 0..<self.external_oral.count{
            self.external_oral_image.append(Image())
            self.external_oral_image.append(Image())
        }
        for i in 0..<self.internal_oral.count{
            self.internal_oral_image.append(Image())
            self.internal_oral_image.append(Image())
            self.internal_oral_image.append(Image())
            self.internal_oral_image.append(Image())
            self.internal_oral_image.append(Image())
        }
        for i in 0..<self.film_oral.count{
            if self.film_oral[i] == "PA"{
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
            }else{
                self.film_oral_image.append(Image())
            }
        }
        for i in 0..<self.lime_oral.count{
            self.lime_oral_image.append(Image())
            self.lime_oral_image.append(Image())
            self.lime_oral_image.append(Image())
            self.lime_oral_image.append(Image())
            self.lime_oral_image.append(Image())
        }
        // Do any additional setup after loading the view.
    }
    func addAnnotateImage(notification:NSNotification){
        if let index = notification.userInfo?["index"] as? Int{
            if let state = notification.userInfo?["state"] as? Int{
                switch state {
                case 0:
                    if let pic = notification.userInfo?["pic"] as? UIImage{
                        self.external_oral_image[index].img = pic
                    }
                case 1:
                    if let pic = notification.userInfo?["pic"] as? UIImage{
                        self.internal_oral_image[index].img = pic
                    }
                case 2:
                    if let pic = notification.userInfo?["pic"] as? UIImage{
                        self.film_oral_image[index].img = pic
                    }
                case 3:
                    if let pic = notification.userInfo?["pic"] as? UIImage{
                        self.lime_oral_image[index].img = pic
                    }
                default:
                    print("error")
                }
            }
        }
        self.tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.setUI()
        self.cons_table_height.constant = self.tableView.contentSize.height
    }
    func setUI(){
        self.helper.loadLocalProfilePic(id: self.patient.localid, image: self.img_profile)
        self.lb_name.text = self.patient.name
        self.lb_hn.text = self.patient.HN
        self.lb_age.text = self.patient.age
        let button: UIButton = UIButton()
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(btn_update_action), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:40, height:40)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        self.btn_cancel.layer.cornerRadius = 2
        self.btn_confirm.layer.cornerRadius = 2
        self.btn_cancel.layer.borderColor = UIColor(netHex: 0x354590).cgColor
        self.btn_cancel.layer.borderWidth = 1
        self.uiTable.shadow(vw_layout: self.vw_note)
        self.btn_date.setTitle(self.helper.dateToStringOnlyDate(date: self.datePicker.date), for: .normal)
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.inType = true
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text! == ""{
            self.lb_cover_clinical_note.isHidden = false
        }else{
            self.lb_cover_clinical_note.isHidden = true
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.img_show_image
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.inType{
            if self.helper.inBound(x: touch.location(in: self.tv_clinical_note).x, y: touch.location(in: self.tv_clinical_note).y, view: self.tv_clinical_note){
                return true
            }else{
                self.inType = false
                self.tv_clinical_note.resignFirstResponder()
                return false
            }
        }else{
            return false
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        let alertController = UIAlertController(title: "Error", message: "Out of Memory", preferredStyle: UIAlertControllerStyle.alert)
        let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
        
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.state == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "external", for: indexPath) as! ExternalOralTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lb_type.text = self.external_oral[indexPath.row]
            cell.btn_left_img.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_left_img.tag = indexPath.row*2
            cell.btn_right_img.tag = (indexPath.row*2)+1
            cell.btn_right_img.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.img_left.image = self.external_oral_image[indexPath.row*2].img
            cell.img_right.image = self.external_oral_image[(indexPath.row*2)+1].img
            return cell
        }else if self.state == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoneOralTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.cons_width.constant = self.view.frame.width/3
            cell.lb_type.text = self.internal_oral[indexPath.row]
            cell.img_front.image = self.internal_oral_image[indexPath.row].img
            cell.img_left.image = self.internal_oral_image[indexPath.row+1].img
            cell.img_right.image = self.internal_oral_image[indexPath.row+2].img
            cell.img_back.image = self.internal_oral_image[indexPath.row+3].img
            cell.img_top.image = self.internal_oral_image[indexPath.row+4].img
            cell.btn_front.tag = indexPath.row
            cell.btn_left.tag = indexPath.row+1
            cell.btn_right.tag = indexPath.row+2
            cell.btn_back.tag = indexPath.row+3
            cell.btn_top.tag = indexPath.row+4
            cell.btn_front.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_left.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_right.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_back.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_top.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            return cell
        }else if self.state == 2{
            if self.film_oral[indexPath.row] == "PA"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "pa", for: indexPath) as! PAOralTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.cons_width.constant = self.view.frame.width/2
                cell.lb_type.text = self.film_oral[indexPath.row]
                cell.img_1.image = self.film_oral_image[indexPath.row].img
                cell.img_2.image = self.film_oral_image[indexPath.row+1].img
                cell.img_3.image = self.film_oral_image[indexPath.row+2].img
                cell.img_4.image = self.film_oral_image[indexPath.row+3].img
                cell.btn_1.tag = indexPath.row
                cell.btn_2.tag = indexPath.row+1
                cell.btn_3.tag = indexPath.row+2
                cell.btn_4.tag = indexPath.row+3
                cell.btn_1.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                cell.btn_2.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                cell.btn_3.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                cell.btn_4.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "internal", for: indexPath) as! InternalTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.lb_type.text = self.film_oral[indexPath.row]
                cell.img_internal.image = self.film_oral_image[indexPath.row].img
                cell.btn_internal.tag = indexPath.row
                cell.btn_internal.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoneOralTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.cons_width.constant = self.view.frame.width/3
            cell.lb_type.text = self.lime_oral[indexPath.row]
            cell.img_front.image = self.lime_oral_image[indexPath.row].img
            cell.img_left.image = self.lime_oral_image[indexPath.row+1].img
            cell.img_right.image = self.lime_oral_image[indexPath.row+2].img
            cell.img_back.image = self.lime_oral_image[indexPath.row+3].img
            cell.img_top.image = self.lime_oral_image[indexPath.row+4].img
            cell.btn_front.tag = indexPath.row
            cell.btn_left.tag = indexPath.row+1
            cell.btn_right.tag = indexPath.row+2
            cell.btn_back.tag = indexPath.row+3
            cell.btn_top.tag = indexPath.row+4
            cell.btn_front.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_left.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_right.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_back.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_top.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            return cell
        }
    }
    func openCamera(sender:UIButton){
        var isSet = false
        if self.state == 0{
            if self.external_oral_image[sender.tag].isSet{
                isSet = true
            }
        }else if self.state == 1{
            if self.internal_oral_image[sender.tag].isSet{
                isSet = true
            }
        }else if self.state == 2{
            if self.film_oral_image[sender.tag].isSet{
                isSet = true
            }
        }else{
            if self.lime_oral_image[sender.tag].isSet{
                isSet = true
            }
        }
        if !isSet{
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.external_index = sender.tag
                self.film_index = sender.tag
                self.internal_index = sender.tag
                self.lime_index = sender.tag
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }else{
            self.navigationController?.isNavigationBarHidden = true
            self.vw_show_image.isHidden = false
            switch self.state {
            case 0:
                self.img_show_image.image = self.external_oral_image[sender.tag].img
            case 1:
                self.img_show_image.image = self.internal_oral_image[sender.tag].img
            case 2:
                self.img_show_image.image = self.film_oral_image[sender.tag].img
            case 3:
                self.img_show_image.image = self.lime_oral_image[sender.tag].img
            default:
                print("error")
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = UIImage()
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if self.state == 0{
            self.external_oral_image[self.external_index].isSet = true
            self.external_oral_image[self.external_index].img = image
        }else if self.state == 1{
            self.internal_oral_image[self.internal_index].isSet = true
            self.internal_oral_image[self.internal_index].img = image
        }else if self.state == 2{
            self.film_oral_image[self.film_index].isSet = true
            self.film_oral_image[self.film_index].img = image
        }else{
            self.lime_oral_image[self.lime_index].isSet = true
            self.lime_oral_image[self.lime_index].img = image
        }
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.state == 0 {
            return self.external_oral.count
        }else if self.state == 1{
            return self.internal_oral.count
        }else if self.state == 2{
            return self.film_oral.count
        }else{
            return self.lime_oral.count
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "annotate"{
            if let des = segue.destination as? DrawPresetViewController{
                self.navigationController?.isNavigationBarHidden = false
                self.vw_show_image.isHidden = true
                des.imagePreset = self.img_show_image.image
                des.Dentstate = self.state
                switch self.state {
                case 0:
                    des.Dentindex = self.external_index
                case 1:
                    des.Dentindex = self.internal_index
                case 2:
                    des.Dentindex = self.film_index
                case 3:
                    des.Dentindex = self.lime_index
                default:
                    print("error")
                }
                des.isEdit = true
                des.isDentist = true
            }
        }else if segue.identifier == "compare"{
            if let des = segue.destination as? CompareViewController{
                des.patient = self.patient
            }
        }else if segue.identifier == "profile"{
            if let des = segue.destination as? PatientProfileViewController{
                des.patient = self.patient
            }
        }else if segue.identifier == "history"{
            if let des = segue.destination as? HistoryViewController{
                des.patient = self.patient
            }
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
