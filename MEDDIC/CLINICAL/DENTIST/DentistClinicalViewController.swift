//
//  DentistClinicalViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/27/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class DentistClinicalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    struct Image {
        var isSet = false
        var img = UIImage()
    }
    var inType = false
    //Init Value
    var state = 0
    //-*******-//
    //Setting External
    var external_oral = ["FACIAL หน้าตรง","FACIAL Left 45º","FACIAL Right 45º","FACIAL Left 90º","FACIAL Right 90º","LIP หน้าตรง","LIP LEFT","LIP RIGHT"]
    var external_oral_image = [Image]()
    var external_index = 0
    //-*******-//
    //Setting Internal
    var internal_oral = ["INTERNAL ORAL"]
    var internal_oral_image = [Image]()
    var internal_index = 0
    //-*******-//
    //Setting Film
    var film_oral = ["CEPH","PANA","PA","ปูน"]
    var film_oral_image = [Image]()
    var film_index = 0
    //
    var isFirst = false
    var helper = Helper()
    var patient = RealmPatient()
    @IBOutlet var gesture: UIGestureRecognizer!
    @IBOutlet var lb_telephone: UILabel!
    @IBOutlet var lb_age: UILabel!
    @IBOutlet var lb_gender: UILabel!
    @IBOutlet var lb_hn: UILabel!
    @IBOutlet var lb_name: UILabel!
    @IBOutlet var img_profile: UIImageView!
    @IBOutlet weak var btn_external: UIButton!
    @IBOutlet weak var btn_internal: UIButton!
    @IBOutlet weak var btn_film: UIButton!
    @IBOutlet weak var lb_pointer_external: UILabel!
    @IBOutlet weak var lb_pointer_internal: UILabel!
    @IBOutlet weak var lb_pointer_film: UILabel!
    @IBOutlet var tv_clinical_note: UITextView!
    @IBOutlet var lb_cover_clinical_note: UILabel!
    @IBOutlet weak var vw_show_image: UIView!
    @IBOutlet weak var img_show_image: UIImageView!
    @IBOutlet weak var vw_scroll_show_image: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cons_table_height: NSLayoutConstraint!
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
        self.state = 0
        self.lb_pointer_external.isHidden = false
        self.lb_pointer_internal.isHidden = true
        self.lb_pointer_film.isHidden = true
    }
    @IBAction func btn_internal_action(_ sender: UIButton) {
        self.btn_external.setTitleColor(UIColor.black, for: .normal)
        self.btn_internal.setTitleColor(UIColor(netHex:0x354590), for: .normal)
        self.btn_film.setTitleColor(UIColor.black, for: .normal)
        self.state = 1
        self.lb_pointer_external.isHidden = true
        self.lb_pointer_internal.isHidden = false
        self.lb_pointer_film.isHidden = true
    }
    @IBAction func btn_film_action(_ sender: UIButton) {
        self.btn_external.setTitleColor(UIColor.black, for: .normal)
        self.btn_internal.setTitleColor(UIColor.black, for: .normal)
        self.btn_film.setTitleColor(UIColor(netHex:0x354590), for: .normal)
        self.state = 2
        self.lb_pointer_external.isHidden = true
        self.lb_pointer_internal.isHidden = true
        self.lb_pointer_film.isHidden = false
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
        }
        for i in 0..<self.film_oral.count{
            if self.film_oral[i] == "PA"{
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
            }else if self.film_oral[i] == "ปูน"{
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
                self.film_oral_image.append(Image())
            }else{
                self.film_oral_image.append(Image())
            }
        }
        // Do any additional setup after loading the view.
    }
    func addAnnotateImage(notification:NSNotification){
        if let index = notification.userInfo?["index"] as? Int{
            if let state = notification.userInfo?["state"] as? Int{
                switch state {
                case 0:
                    if let pic = notification.userInfo?["pic"] as? UIImage{
                        print("hello")
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
        self.helper.loadLocalProfilePic(id: self.patient.id, image: self.img_profile)
        self.lb_name.text = self.patient.name
        self.lb_hn.text = self.patient.HN
        self.lb_age.text = self.patient.age
        self.lb_gender.text = self.patient.gender
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
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.state == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "external", for: indexPath) as! ExternalOralTableViewCell
            cell.lb_type.text = self.external_oral[indexPath.row]
            cell.btn_left_img.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_left_img.tag = indexPath.row*2
            cell.btn_right_img.tag = (indexPath.row*2)+1
            cell.btn_right_img.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.img_left.image = self.external_oral_image[indexPath.row*2].img
            cell.img_right.image = self.external_oral_image[(indexPath.row*2)+1].img
            return cell
        }else if self.state == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "internal", for: indexPath) as! InternalTableViewCell
            cell.lb_type.text = self.internal_oral[indexPath.row]
            cell.img_internal.image = self.internal_oral_image[indexPath.row].img
            cell.btn_internal.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            return cell
        }else{
            if self.film_oral[indexPath.row] == "PA"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "pa", for: indexPath) as! PAOralTableViewCell
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
            }else if self.film_oral[indexPath.row] == "ปูน"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoneOralTableViewCell
                cell.cons_width.constant = self.view.frame.width/3
                cell.lb_type.text = self.film_oral[indexPath.row]
                cell.img_front.image = self.film_oral_image[indexPath.row+3].img
                cell.img_left.image = self.film_oral_image[indexPath.row+4].img
                cell.img_right.image = self.film_oral_image[indexPath.row+5].img
                cell.img_back.image = self.film_oral_image[indexPath.row+6].img
                cell.img_top.image = self.film_oral_image[indexPath.row+7].img
                cell.btn_front.tag = indexPath.row+3
                cell.btn_left.tag = indexPath.row+4
                cell.btn_right.tag = indexPath.row+5
                cell.btn_back.tag = indexPath.row+6
                cell.btn_top.tag = indexPath.row+7
                cell.btn_front.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                cell.btn_left.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                cell.btn_right.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                cell.btn_back.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                cell.btn_top.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "internal", for: indexPath) as! InternalTableViewCell
                cell.lb_type.text = self.film_oral[indexPath.row]
                cell.img_internal.image = self.film_oral_image[indexPath.row].img
                cell.btn_internal.tag = indexPath.row
                cell.btn_internal.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                return cell
            }
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
        }else{
            if self.film_oral_image[sender.tag].isSet{
                isSet = true
            }
        }
        if !isSet{
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.external_index = sender.tag
                self.film_index = sender.tag
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
            self.internal_oral_image[0].isSet = true
            self.internal_oral_image[0].img = image
        }else{
            self.film_oral_image[self.film_index].isSet = true
            self.film_oral_image[self.film_index].img = image
        }
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.state == 0 {
            return self.external_oral.count
        }else if self.state == 1{
            return self.internal_oral.count
        }else{
            return self.film_oral.count
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            default:
                print("error")
            }
            des.isEdit = true
            des.isDentist = true
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
