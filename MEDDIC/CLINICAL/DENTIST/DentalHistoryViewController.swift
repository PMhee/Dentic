//
//  DentalHistoryViewController.swift
//  Dentic
//
//  Created by Tanakorn on 4/20/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class DentalHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    //Init Value
    var helper = Helper()
    struct Image {
        var isSet = false
        var img = UIImage()
    }
    var followup = RealmFollowup()
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
    var contEx = false
    var contIn = false
    var contFilm = false
    var contLime = false
    
    @IBOutlet weak var btn_external: UIButton!
    @IBOutlet weak var btn_internal: UIButton!
    @IBOutlet weak var btn_film: UIButton!
    @IBOutlet weak var btn_lime: UIButton!
    @IBOutlet weak var lb_pointer_external: UILabel!
    @IBOutlet weak var lb_pointer_internal: UILabel!
    @IBOutlet weak var lb_pointer_film: UILabel!
    @IBOutlet weak var lb_pointer_lime: UILabel!
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
        if !contEx{
            self.btn_external.isUserInteractionEnabled = false
            self.btn_external.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contIn{
            self.btn_internal.isUserInteractionEnabled = false
            self.btn_internal.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contFilm{
            self.btn_film.isUserInteractionEnabled = false
            self.btn_film.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contLime{
            self.btn_lime.isUserInteractionEnabled = false
            self.btn_lime.setTitleColor(UIColor.lightGray, for: .normal)
        }
        self.tableView.reloadData()
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
        if !contEx{
            self.btn_external.isUserInteractionEnabled = false
            self.btn_external.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contIn{
            self.btn_internal.isUserInteractionEnabled = false
            self.btn_internal.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contFilm{
            self.btn_film.isUserInteractionEnabled = false
            self.btn_film.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contLime{
            self.btn_lime.isUserInteractionEnabled = false
            self.btn_lime.setTitleColor(UIColor.lightGray, for: .normal)
        }
        self.tableView.reloadData()
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
        if !contEx{
            self.btn_external.isUserInteractionEnabled = false
            self.btn_external.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contIn{
            self.btn_internal.isUserInteractionEnabled = false
            self.btn_internal.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contFilm{
            self.btn_film.isUserInteractionEnabled = false
            self.btn_film.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contLime{
            self.btn_lime.isUserInteractionEnabled = false
            self.btn_lime.setTitleColor(UIColor.lightGray, for: .normal)
        }
        self.tableView.reloadData()
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
        if !contEx{
            self.btn_external.isUserInteractionEnabled = false
            self.btn_external.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contIn{
            self.btn_internal.isUserInteractionEnabled = false
            self.btn_internal.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contFilm{
            self.btn_film.isUserInteractionEnabled = false
            self.btn_film.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contLime{
            self.btn_lime.isUserInteractionEnabled = false
            self.btn_lime.setTitleColor(UIColor.lightGray, for: .normal)
        }
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<self.followup.ExternalImage.count{
            if self.followup.ExternalImage[i].isUpdate{
                contEx = true
                break
            }
        }
        for i in 0..<self.followup.InternalImage.count{
            if self.followup.InternalImage[i].isUpdate{
                contIn = true
                break
            }
        }
        for i in 0..<self.followup.Film.count{
            if self.followup.Film[i].isUpdate{
                contFilm = true
                break
            }
        }
        for i in 0..<self.followup.Lime.count{
            if self.followup.Lime[i].isUpdate{
                contLime = true
                break
            }
        }
        if !contEx{
            self.btn_external.isUserInteractionEnabled = false
            self.btn_external.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contIn{
            self.btn_internal.isUserInteractionEnabled = false
            self.btn_internal.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contFilm{
            self.btn_film.isUserInteractionEnabled = false
            self.btn_film.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if !contLime{
            self.btn_lime.isUserInteractionEnabled = false
            self.btn_lime.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if contLime{
            self.state = 3
        }else if contFilm{
            self.state = 2
        }else if contIn{
            self.state = 1
        }else if contEx{
            self.state = 0
        }else{
            self.state = 4
        }
        switch self.state {
        case 0:
            self.lb_pointer_external.isHidden = false
            self.lb_pointer_internal.isHidden = true
            self.lb_pointer_film.isHidden = true
            self.lb_pointer_lime.isHidden = true
        case 1:
            self.lb_pointer_external.isHidden = true
            self.lb_pointer_internal.isHidden = false
            self.lb_pointer_film.isHidden = true
            self.lb_pointer_lime.isHidden = true
        case 2:
            self.lb_pointer_external.isHidden = true
            self.lb_pointer_internal.isHidden = true
            self.lb_pointer_film.isHidden = false
            self.lb_pointer_lime.isHidden = true
        case 3:
            self.lb_pointer_external.isHidden = true
            self.lb_pointer_internal.isHidden = true
            self.lb_pointer_film.isHidden = true
            self.lb_pointer_lime.isHidden = false
        default:
            self.lb_pointer_external.isHidden = true
            self.lb_pointer_internal.isHidden = true
            self.lb_pointer_film.isHidden = true
            self.lb_pointer_lime.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.state == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "external", for: indexPath) as! ExternalOralTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lb_type.text = self.external_oral[indexPath.row]
            self.helper.loadLocalProfilePic(id: self.followup.ExternalImage[indexPath.row*2].id, image: cell.img_left)
            self.helper.loadLocalProfilePic(id: self.followup.ExternalImage[(indexPath.row*2)+1].id, image: cell.img_right)
            cell.btn_left_img.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            cell.btn_left_img.tag = indexPath.row*2
            cell.btn_right_img.tag = (indexPath.row*2)+1
            cell.btn_right_img.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
            return cell
        }else if self.state == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoneOralTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.cons_width.constant = self.view.frame.width/3
            cell.lb_type.text = self.internal_oral[indexPath.row]
            self.helper.loadLocalProfilePic(id: self.followup.InternalImage[indexPath.row].id, image: cell.img_front)
            self.helper.loadLocalProfilePic(id: self.followup.InternalImage[indexPath.row+1].id, image: cell.img_left)
            self.helper.loadLocalProfilePic(id: self.followup.InternalImage[indexPath.row+2].id, image: cell.img_right)
            self.helper.loadLocalProfilePic(id: self.followup.InternalImage[indexPath.row+3].id, image: cell.img_back)
            self.helper.loadLocalProfilePic(id: self.followup.InternalImage[indexPath.row+4].id, image: cell.img_top)
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
                self.helper.loadLocalProfilePic(id: self.followup.Film[indexPath.row].id, image: cell.img_1)
                self.helper.loadLocalProfilePic(id: self.followup.Film[indexPath.row+1].id, image: cell.img_2)
                self.helper.loadLocalProfilePic(id: self.followup.Film[indexPath.row+2].id, image: cell.img_3)
                self.helper.loadLocalProfilePic(id: self.followup.Film[indexPath.row+3].id, image: cell.img_4)
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
                self.helper.loadLocalProfilePic(id: self.followup.Film[indexPath.row].id, image: cell.img_internal)
                cell.lb_type.text = self.film_oral[indexPath.row]
                cell.btn_internal.tag = indexPath.row
                cell.btn_internal.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoneOralTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.cons_width.constant = self.view.frame.width/3
            cell.lb_type.text = self.lime_oral[indexPath.row]
            self.helper.loadLocalProfilePic(id: self.followup.Lime[indexPath.row].id, image: cell.img_front)
            self.helper.loadLocalProfilePic(id: self.followup.Lime[indexPath.row+1].id, image: cell.img_left)
            self.helper.loadLocalProfilePic(id: self.followup.Lime[indexPath.row+2].id, image: cell.img_right)
            self.helper.loadLocalProfilePic(id: self.followup.Lime[indexPath.row+3].id, image: cell.img_back)
            self.helper.loadLocalProfilePic(id: self.followup.Lime[indexPath.row+4].id, image: cell.img_top)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
    //Show image
    var w : CGFloat = 0
    var h : CGFloat = 0
    var state_rotate = 0
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.img_show_image
    }
    @IBOutlet weak var img_show_image: UIImageView!
    @IBOutlet weak var vw_img_show: UIView!
    @IBAction func btn_close_action(_ sender: UIButton) {
        self.vw_img_show.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    @IBAction func btn_flip_vertical_action(_ sender: UIButton) {
        switch self.state_rotate {
        case 0:
            self.state_rotate = 1
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.downMirrored)
        case 1:
            self.state_rotate = 0
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.up)
        case 2:
            self.state_rotate = 3
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.down)
        case 3:
            self.state_rotate = 2
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.upMirrored)
        case 4:
            self.state_rotate = 5
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.left)
        case 5:
            self.state_rotate = 4
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.leftMirrored)
        case 6:
            self.state_rotate = 7
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.rightMirrored)
        case 7:
            self.state_rotate = 6
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.right)
        case 8:
            self.state_rotate = 9
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.up)
        case 9:
            self.state_rotate = 8
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.downMirrored)
        case 10:
            self.state_rotate = 11
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.upMirrored)
        case 11:
            self.state_rotate = 10
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.down)
        case 12:
            self.state_rotate = 13
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.rightMirrored)
        case 13:
            self.state_rotate = 12
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.right)
        case 14:
            self.state_rotate = 15
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.left)
        case 15:
            self.state_rotate = 14
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.leftMirrored)
        default:
            print("error")
        }
    }
    @IBAction func btn_flip_horizontal_action(_ sender: UIButton) {
        switch self.state_rotate {
        case 0:
            self.state_rotate = 2
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.upMirrored)
        case 1:
            self.state_rotate = 3
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.down)
        case 2:
            self.state_rotate = 0
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.up)
        case 3:
            self.state_rotate = 1
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.downMirrored)
        case 4:
            self.state_rotate = 6
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.right)
        case 5:
            self.state_rotate = 7
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.rightMirrored)
        case 6:
            self.state_rotate = 4
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.leftMirrored)
        case 7:
            self.state_rotate = 5
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.left)
        case 8:
            self.state_rotate = 10
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.down)
        case 9:
            self.state_rotate = 11
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.upMirrored)
        case 10:
            self.state_rotate = 8
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.downMirrored)
        case 11:
            self.state_rotate = 9
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.up)
        case 12:
            self.state_rotate = 14
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.leftMirrored)
        case 13:
            self.state_rotate = 15
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.left)
        case 14:
            self.state_rotate = 12
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.right)
        case 15:
            self.state_rotate = 13
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.rightMirrored)
        default:
            print("error")
        }
        
    }
    @IBAction func btn_rotate_action(_ sender: UIButton) {
        switch self.state_rotate {
        case 0:
            self.state_rotate = 6
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.right)
        case 1:
            self.state_rotate = 4
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.leftMirrored)
        case 2:
            self.state_rotate = 7
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.rightMirrored)
        case 3:
            self.state_rotate = 5
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.left)
        case 4:
            self.state_rotate = 2
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.upMirrored)
        case 5:
            self.state_rotate = 0
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.up)
        case 6:
            self.state_rotate = 3
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.down)
        case 7:
            self.state_rotate = 1
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.downMirrored)
        case 8:
            self.state_rotate = 14
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.leftMirrored)
        case 9:
            self.state_rotate = 12
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.right)
        case 10:
            self.state_rotate = 15
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.left)
        case 11:
            self.state_rotate = 13
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.rightMirrored)
        case 12:
            self.state_rotate = 10
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.down)
        case 13:
            self.state_rotate = 8
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.downMirrored)
        case 14:
            self.state_rotate = 11
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.upMirrored)
        case 15:
            self.state_rotate = 9
            self.img_show_image.image = UIImage(cgImage: (self.img_show_image.image?.cgImage)!, scale: 1.0, orientation:UIImageOrientation.up)
        default:
            print("error")
        }
        
    }
    @IBAction func btn_save_action(_ sender: UIButton) {
        self.vw_img_show.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        try! Realm().write {
            if self.state == 0{
                self.helper.saveLocalProfilePicFromImage(image: self.img_show_image.image!, id: self.followup.ExternalImage[self.external_index].id)
            }else if self.state == 1{
                self.helper.saveLocalProfilePicFromImage(image: self.img_show_image.image!, id: self.followup.InternalImage[self.external_index].id)
            }else if self.state == 2{
                self.helper.saveLocalProfilePicFromImage(image: self.img_show_image.image!, id: self.followup.Film[self.external_index].id)
            }else{
                self.helper.saveLocalProfilePicFromImage(image: self.img_show_image.image!, id: self.followup.Lime[self.external_index].id)
            }
        }
        self.tableView.reloadData()
    }
    func openCamera(sender:UIButton){
        var isUpdate = false
        switch self.state {
        case 0:
            if self.followup.ExternalImage[sender.tag].isUpdate{
                isUpdate = true
            }
        case 1:
            if self.followup.InternalImage[sender.tag].isUpdate{
                isUpdate = true
            }
        case 2:
            if self.followup.Film[sender.tag].isUpdate{
                isUpdate = true
            }
        case 3:
            if self.followup.Lime[sender.tag].isUpdate{
                isUpdate = true
            }
        default:
            print("error")
        }
        if isUpdate{
            UIApplication.shared.setStatusBarHidden(true, with: .none)
            self.navigationController?.isNavigationBarHidden = true
            self.vw_img_show.isHidden = false
            
            switch self.state {
            case 0:
                self.helper.loadLocalProfilePicWithSuccess(id: self.followup.ExternalImage[sender.tag].id, image: self.img_show_image, success: {(success) in
                    self.external_index = sender.tag
                    self.w = self.img_show_image.image!.size.width
                    self.h = self.img_show_image.image!.size.height
                    if self.h > self.w {
                        self.state_rotate = 12
                    }else{
                        self.state_rotate = 0
                    }
                    if self.w > self.h{
                        switch self.img_show_image.image!.imageOrientation {
                        case .down:
                            print("down")
                            self.state_rotate = 3
                        case .downMirrored:
                            print("downMirror")
                            self.state_rotate = 1
                        case .left:
                            print("left")
                            self.state_rotate = 5
                        case .leftMirrored:
                            print("leftMirrored")
                            self.state_rotate = 4
                        case .right:
                            print("right")
                            self.state_rotate = 6
                        case .rightMirrored:
                            print("rightMirrored")
                            self.state_rotate = 7
                        case .up:
                            print("up")
                            self.state_rotate = 0
                        case .upMirrored:
                            print("upMirrored")
                            self.state_rotate = 2
                        default:
                            print("error")
                        }
                    }else{
                        switch self.img_show_image.image!.imageOrientation {
                        case .down:
                            print("down")
                            self.state_rotate = 10
                        case .downMirrored:
                            print("downMirror")
                            self.state_rotate = 8
                        case .left:
                            print("left")
                            self.state_rotate = 15
                        case .leftMirrored:
                            print("leftMirrored")
                            self.state_rotate = 14
                        case .right:
                            print("right")
                            self.state_rotate = 12
                        case .rightMirrored:
                            print("rightMirrored")
                            self.state_rotate = 13
                        case .up:
                            print("up")
                            self.state_rotate = 10
                        case .upMirrored:
                            print("upMirrored")
                            self.state_rotate = 11
                        default:
                            print("error")
                        }
                    }
                })
                self.external_index = sender.tag
            case 1:
                self.helper.loadLocalProfilePicWithSuccess(id: self.followup.InternalImage[sender.tag].id, image: self.img_show_image, success: {(success) in
                    self.external_index = sender.tag
                    self.w = self.img_show_image.image!.size.width
                    self.h = self.img_show_image.image!.size.height
                    if self.h > self.w {
                        self.state_rotate = 12
                    }else{
                        self.state_rotate = 0
                    }
                    if self.w > self.h{
                        switch self.img_show_image.image!.imageOrientation {
                        case .down:
                            print("down")
                            self.state_rotate = 3
                        case .downMirrored:
                            print("downMirror")
                            self.state_rotate = 1
                        case .left:
                            print("left")
                            self.state_rotate = 5
                        case .leftMirrored:
                            print("leftMirrored")
                            self.state_rotate = 4
                        case .right:
                            print("right")
                            self.state_rotate = 6
                        case .rightMirrored:
                            print("rightMirrored")
                            self.state_rotate = 7
                        case .up:
                            print("up")
                            self.state_rotate = 0
                        case .upMirrored:
                            print("upMirrored")
                            self.state_rotate = 2
                        default:
                            print("error")
                        }
                    }else{
                        switch self.img_show_image.image!.imageOrientation {
                        case .down:
                            print("down")
                            self.state_rotate = 10
                        case .downMirrored:
                            print("downMirror")
                            self.state_rotate = 8
                        case .left:
                            print("left")
                            self.state_rotate = 15
                        case .leftMirrored:
                            print("leftMirrored")
                            self.state_rotate = 14
                        case .right:
                            print("right")
                            self.state_rotate = 12
                        case .rightMirrored:
                            print("rightMirrored")
                            self.state_rotate = 13
                        case .up:
                            print("up")
                            self.state_rotate = 10
                        case .upMirrored:
                            print("upMirrored")
                            self.state_rotate = 11
                        default:
                            print("error")
                        }
                    }
                })
                self.internal_index = sender.tag
            case 2:
                self.helper.loadLocalProfilePicWithSuccess(id: self.followup.Film[sender.tag].id, image: self.img_show_image, success: {(success) in
                    self.external_index = sender.tag
                    self.w = self.img_show_image.image!.size.width
                    self.h = self.img_show_image.image!.size.height
                    if self.h > self.w {
                        self.state_rotate = 12
                    }else{
                        self.state_rotate = 0
                    }
                    if self.w > self.h{
                        switch self.img_show_image.image!.imageOrientation {
                        case .down:
                            print("down")
                            self.state_rotate = 3
                        case .downMirrored:
                            print("downMirror")
                            self.state_rotate = 1
                        case .left:
                            print("left")
                            self.state_rotate = 5
                        case .leftMirrored:
                            print("leftMirrored")
                            self.state_rotate = 4
                        case .right:
                            print("right")
                            self.state_rotate = 6
                        case .rightMirrored:
                            print("rightMirrored")
                            self.state_rotate = 7
                        case .up:
                            print("up")
                            self.state_rotate = 0
                        case .upMirrored:
                            print("upMirrored")
                            self.state_rotate = 2
                        default:
                            print("error")
                        }
                    }else{
                        switch self.img_show_image.image!.imageOrientation {
                        case .down:
                            print("down")
                            self.state_rotate = 10
                        case .downMirrored:
                            print("downMirror")
                            self.state_rotate = 8
                        case .left:
                            print("left")
                            self.state_rotate = 15
                        case .leftMirrored:
                            print("leftMirrored")
                            self.state_rotate = 14
                        case .right:
                            print("right")
                            self.state_rotate = 12
                        case .rightMirrored:
                            print("rightMirrored")
                            self.state_rotate = 13
                        case .up:
                            print("up")
                            self.state_rotate = 10
                        case .upMirrored:
                            print("upMirrored")
                            self.state_rotate = 11
                        default:
                            print("error")
                        }
                    }
                })
                self.film_index = sender.tag
            case 3:
                self.helper.loadLocalProfilePicWithSuccess(id: self.followup.Lime[sender.tag].id, image: self.img_show_image, success: {(success) in
                    self.external_index = sender.tag
                    self.w = self.img_show_image.image!.size.width
                    self.h = self.img_show_image.image!.size.height
                    if self.h > self.w {
                        self.state_rotate = 12
                    }else{
                        self.state_rotate = 0
                    }
                    if self.w > self.h{
                        switch self.img_show_image.image!.imageOrientation {
                        case .down:
                            print("down")
                            self.state_rotate = 3
                        case .downMirrored:
                            print("downMirror")
                            self.state_rotate = 1
                        case .left:
                            print("left")
                            self.state_rotate = 5
                        case .leftMirrored:
                            print("leftMirrored")
                            self.state_rotate = 4
                        case .right:
                            print("right")
                            self.state_rotate = 6
                        case .rightMirrored:
                            print("rightMirrored")
                            self.state_rotate = 7
                        case .up:
                            print("up")
                            self.state_rotate = 0
                        case .upMirrored:
                            print("upMirrored")
                            self.state_rotate = 2
                        default:
                            print("error")
                        }
                    }else{
                        switch self.img_show_image.image!.imageOrientation {
                        case .down:
                            print("down")
                            self.state_rotate = 10
                        case .downMirrored:
                            print("downMirror")
                            self.state_rotate = 8
                        case .left:
                            print("left")
                            self.state_rotate = 15
                        case .leftMirrored:
                            print("leftMirrored")
                            self.state_rotate = 14
                        case .right:
                            print("right")
                            self.state_rotate = 12
                        case .rightMirrored:
                            print("rightMirrored")
                            self.state_rotate = 13
                        case .up:
                            print("up")
                            self.state_rotate = 10
                        case .upMirrored:
                            print("upMirrored")
                            self.state_rotate = 11
                        default:
                            print("error")
                        }
                    }
                })
                self.lime_index = sender.tag
            default:
                print("error")
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
