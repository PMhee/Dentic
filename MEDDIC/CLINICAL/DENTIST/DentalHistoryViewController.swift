//
//  DentalHistoryViewController.swift
//  Dentic
//
//  Created by Tanakorn on 4/20/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class DentalHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
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
        self.tableView.reloadData()
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "internal", for: indexPath) as! InternalTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                self.helper.loadLocalProfilePic(id: self.followup.Film[indexPath.row].id, image: cell.img_internal)
                cell.lb_type.text = self.film_oral[indexPath.row]
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
