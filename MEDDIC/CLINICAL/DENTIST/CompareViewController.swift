//
//  CompareViewController.swift
//  Dentic
//
//  Created by Tanakorn on 4/3/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class CompareViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UIGestureRecognizerDelegate {
    var firstFollowup =  RealmFollowup()//try! Realm().objects(RealmListFollowup.self).first?.followup.first!
    var middleFollowup =  RealmFollowup()//try! Realm().objects(RealmListFollowup.self)[1].followup.first!
    var lastFollowup = RealmFollowup()//try! Realm().objects(RealmListFollowup.self).last?.followup.first!
    var followUp =  try! Realm().objects(RealmFollowup.self)
    var helper = Helper()
    var inSelectDate = false
    var dateSelection = 0
    var compareFollowUp = [RealmFollowup]()
    var preView = RealmFollowup()
    var compareType = 0
    var selectedCompare : Int? = nil
    var external_oral = ["FACIAL หน้าตรง","FACIAL LEFT 45º","FACIAL LEFT 90º","FACIAL RIGHT 45º","FACIAL RIGHT 90º","LIP หน้าตรง","LIP LEFT","LIP RIGHT"]
    var internal_oral = ["INTERNAL ORAL"]
    var film_oral = ["CEPH","PANA","PA"]
    var lime_oral = ["LIME"]
    var compareList = [String]()
    var back = BackPatient()
    var patient = RealmPatient()
    var settingState = 0
    var manualState = 0
    var typeState1 = 0
    var typeState2 = 0
    var popController = PopOverFilterViewController()
    @IBOutlet weak var cons_height_select_compare: NSLayoutConstraint!
    @IBOutlet weak var tableViewDate: UITableView!
    @IBOutlet weak var tableViewHistory: UITableView!
    @IBOutlet weak var vw_preview_history: UIView!
    @IBOutlet weak var vw_select_date: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView_Select_Compare: UITableView!
    @IBOutlet weak var vw_select_compare: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var cons_height_select_date: NSLayoutConstraint!
    @IBOutlet weak var lb_history_date: UILabel!
    @IBOutlet weak var lb_history_followup: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBAction func btn_select_action(_ sender: UIButton) {
        self.vw_select_date.isHidden = true
        self.vw_preview_history.isHidden = true
        self.vw_filter.isHidden = true
        self.compareFollowUp[self.dateSelection] = self.followUp[self.selectedCompare!]
        self.tableView.reloadData()
    }
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.vw_preview_history.isHidden = true
        self.inSelectDate = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initValue()
        self.setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(selectCompareTable(notification:)), name: NSNotification.Name(rawValue: "selectCompareTable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectManual(notification:)), name: NSNotification.Name(rawValue: "selectManual"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectType1(notification:)), name: NSNotification.Name(rawValue: "selectType1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectType2(notification:)), name: NSNotification.Name(rawValue: "selectType2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendCompareContentSize(notification:)), name: NSNotification.Name(rawValue: "sendCompareContentSize"), object: nil)
        self.vw_select_compare.layer.cornerRadius = 5
        self.vw_select_date.layer.cornerRadius = 5
        self.vw_preview_history.layer.cornerRadius = 5
        self.vw_select_compare.layer.cornerRadius = 5
        //self.btn_cancel.layer.borderWidth = 1
        //self.btn_cancel.layer.borderColor = UIColor(netHex:0x2C3872).cgColor
        var gesture = UIGestureRecognizer()
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    func selectManual(notification:NSNotification){
        let idx = notification.userInfo?["index"] as! Int
        self.manualState = idx
        self.tableView.reloadData()
    }
    func selectType1(notification:NSNotification){
        let idx = notification.userInfo?["index"] as! Int
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectCeptOrPana"), object: self, userInfo: ["index":idx])
        self.typeState1 = idx
        self.tableView.reloadData()
    }
    func selectType2(notification:NSNotification){
        let idx = notification.userInfo?["index"] as! Int
        self.typeState2 = idx
        self.tableView.reloadData()
    }
    func selectCompareTable(notification:NSNotification){
        let idx = notification.userInfo?["index"] as! Int
        self.settingState = idx
        self.compareType = idx
//        self.compareFollowUp = [RealmFollowup]()
//        if compareType == 5 || compareType == 6 {
//            compareFollowUp.append(firstFollowup)
//            compareFollowUp.append(middleFollowup)
//            compareFollowUp.append(lastFollowup)
//        }else{
//            compareFollowUp.append(firstFollowup)
//            compareFollowUp.append(lastFollowup)
//        }
        self.tableView.reloadData()
    }
    func sendCompareContentSize(notification:NSNotification){
        let size = notification.userInfo?["contentSize"] as! CGFloat
        self.popController.preferredContentSize = CGSize(width: self.view.frame.width, height: size)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.inSelectDate{
            if self.helper.inBound(x: touch.location(in: self.vw_select_date).x, y: touch.location(in: self.vw_select_date).y, view: self.vw_select_date){
                return false
            }else{
                self.inSelectDate = false
                self.vw_filter.isHidden = true
                self.vw_select_date.isHidden = true
                return true
            }
        }else{
            return false
        }
    }
    func initValue(){
        let listFu = self.back.listPatientListFollowUp(id: patient.localid)
        self.followUp = self.back.listPatientFollowUp(id: patient.localid)
        if listFu.count == 0 {
            self.compareList = []
            let alertController = UIAlertController(title: "Error", message: "Your patient have no enough data to compare", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else if listFu.count == 1{
            self.compareList = []
            let alertController = UIAlertController(title: "Error", message: "Your patient have no enough data to compare", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else if listFu.count == 2{
            self.firstFollowup = (listFu.first?.followup.first)!
            self.lastFollowup = (listFu.last?.followup.last)!
            self.compareList = ["2x1","2x2","2x3","2x4","2x5"]
        }else{
            self.firstFollowup = (listFu.first?.followup.first)!
            self.lastFollowup = (listFu.last?.followup.last)!
            self.middleFollowup = listFu[1].followup.first!
            self.compareList = ["2x1","2x2","2x3","2x4","2x5","3x2","3x3"]
        }
        self.tableView_Select_Compare.reloadData()
        self.tableView_Select_Compare.layoutIfNeeded()
        self.cons_height_select_compare.constant = self.tableView_Select_Compare.contentSize.height
    }
    func setUI(){
        //self.helper.setGradientColorTopBot(vw: self.vw_top, color1: UIColor(netHex:0x2C3872), color2: UIColor(netHex: 0x5F6CB2))
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            let lb = cell.viewWithTag(2) as! UILabel
            img.image = UIImage(named: self.compareList[indexPath.row])
            lb.text = self.compareList[indexPath.row]
            return cell
        }else if tableView.tag == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath)
            let lb_date = cell.viewWithTag(1) as! UILabel
            lb_date.text = self.helper.dateToStringOnlyDate(date: self.followUp[indexPath.row].followdate) + " " + self.followUp[indexPath.row].followtime
            return cell
        }else if tableView.tag == 4{
            if indexPath.row < self.external_oral.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "external", for: indexPath) as! ExternalOralTableViewCell
                cell.lb_type.text = self.external_oral[indexPath.row]
                self.helper.loadLocalProfilePic(id: self.preView.ExternalImage[indexPath.row*2].id, image: cell.img_left)
                self.helper.loadLocalProfilePic(id: self.preView.ExternalImage[(indexPath.row*2)+1].id, image: cell.img_right)
                return cell
            }else if indexPath.row >= self.external_oral.count && indexPath.row < self.internal_oral.count+self.external_oral.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoneOralTableViewCell
                cell.cons_width.constant = self.view.frame.width/3
                cell.lb_type.text = self.internal_oral[indexPath.row-self.external_oral.count]
                self.helper.loadLocalProfilePic(id: self.preView.InternalImage[indexPath.row-self.external_oral.count].id, image: cell.img_front)
                self.helper.loadLocalProfilePic(id: self.preView.InternalImage[indexPath.row+1-self.external_oral.count].id, image: cell.img_left)
                self.helper.loadLocalProfilePic(id: self.preView.InternalImage[indexPath.row+2-self.external_oral.count].id, image: cell.img_right)
                self.helper.loadLocalProfilePic(id: self.preView.InternalImage[indexPath.row+3-self.external_oral.count].id, image: cell.img_back)
                self.helper.loadLocalProfilePic(id: self.preView.InternalImage[indexPath.row+4-self.external_oral.count].id, image: cell.img_top)
                return cell
            }else if indexPath.row >= self.external_oral.count+self.internal_oral.count && indexPath.row < self.internal_oral.count+self.external_oral.count+self.film_oral.count{
                if self.film_oral[indexPath.row-self.external_oral.count-self.internal_oral.count] == "PA"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "pa", for: indexPath) as! PAOralTableViewCell
                    cell.cons_width.constant = self.view.frame.width/2
                    cell.lb_type.text = self.film_oral[indexPath.row-self.external_oral.count-self.internal_oral.count]
                    self.helper.loadLocalProfilePic(id: self.preView.Film[indexPath.row-self.external_oral.count-self.internal_oral.count].id, image: cell.img_1)
                    self.helper.loadLocalProfilePic(id: self.preView.Film[indexPath.row+1-self.external_oral.count-self.internal_oral.count].id, image: cell.img_2)
                    self.helper.loadLocalProfilePic(id: self.preView.Film[indexPath.row+2-self.external_oral.count-self.internal_oral.count].id, image: cell.img_3)
                    self.helper.loadLocalProfilePic(id: self.preView.Film[indexPath.row+3-self.external_oral.count-self.internal_oral.count].id, image: cell.img_4)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "internal", for: indexPath) as! InternalTableViewCell
                    cell.lb_type.text = self.film_oral[indexPath.row-self.external_oral.count-self.internal_oral.count]
                    self.helper.loadLocalProfilePic(id: self.preView.Film[indexPath.row-self.external_oral.count-self.internal_oral.count].id, image: cell.img_internal)
                    return cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoneOralTableViewCell
                cell.cons_width.constant = self.view.frame.width/3
                cell.lb_type.text = self.lime_oral[indexPath.row-self.external_oral.count-self.internal_oral.count-self.film_oral.count]
                self.helper.loadLocalProfilePic(id: self.preView.Lime[indexPath.row-self.external_oral.count-self.internal_oral.count-self.film_oral.count].id, image: cell.img_front)
                self.helper.loadLocalProfilePic(id: self.preView.Lime[indexPath.row+1-self.external_oral.count-self.internal_oral.count-self.film_oral.count].id, image: cell.img_left)
                self.helper.loadLocalProfilePic(id: self.preView.Lime[indexPath.row+2-self.external_oral.count-self.internal_oral.count-self.film_oral.count].id, image: cell.img_right)
                self.helper.loadLocalProfilePic(id: self.preView.Lime[indexPath.row+3-self.external_oral.count-self.internal_oral.count-self.film_oral.count].id, image: cell.img_back)
                self.helper.loadLocalProfilePic(id: self.preView.Lime[indexPath.row+4-self.external_oral.count-self.internal_oral.count-self.film_oral.count].id, image: cell.img_top)
                return cell
            }
        }else{
            if indexPath.row < self.compareFollowUp.count+1{
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
                    let lb_result = cell.viewWithTag(1) as! UILabel
                    lb_result.text = "from \(self.followUp.count) data"
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
                    let lb_date = cell.viewWithTag(1) as! UILabel
                    let lb_note = cell.viewWithTag(2) as! UILabel
                    lb_date.text = self.helper.dateToStringOnlyDate(date: self.compareFollowUp[indexPath.row-1].followdate)
                    lb_note.text = self.compareFollowUp[indexPath.row-1].followupnote
                    return cell
                }
            }else{
                let idx = indexPath.row - (self.compareFollowUp.count+1)
                if self.compareType == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! Compare1TableViewCell
                    cell.cons_width.constant = self.view.frame.width * 0.6
                    if self.typeState1 == 0 {
                    switch self.manualState {
                    case 0:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[1].id, image: cell.img)
                    case 1:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[0].id, image: cell.img)
                    case 2:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[5].id, image: cell.img)
                    case 3:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[4].id, image: cell.img)
                    case 4:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[11].id, image: cell.img)
                    case 5:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[10].id, image: cell.img)
                    case 6:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[13].id, image: cell.img)
                    case 7:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[12].id, image: cell.img)
                    default:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[1].id, image: cell.img)
                    }
                    }else if self.typeState1 == 1 {
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Film[0].id, image: cell.img)
                    }else{
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Film[1].id, image: cell.img)
                    }
                    return cell
                }else if self.compareType == 1 || self.compareType == 5 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! Compare2TableViewCell
                    cell.cons_width.constant = self.view.frame.width/2
                    switch self.manualState {
                    case 0:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[3].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[7].id, image: cell.img_2)
                    case 1:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[2].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[6].id, image: cell.img_2)
                    case 2:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[5].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[9].id, image: cell.img_2)
                    case 3:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[4].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[8].id, image: cell.img_2)
                    case 4:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[13].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[15].id, image: cell.img_2)
                    case 5:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[12].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[14].id, image: cell.img_2)
                    case 6:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[13].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[15].id, image: cell.img_2)
                    case 7:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[12].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[14].id, image: cell.img_2)
                    default:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[3].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[7].id, image: cell.img_2)
                    }
                    return cell
                }else if self.compareType == 2 || self.compareType == 6 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! Compare3x2TableViewCell
                    cell.cons_width.constant = self.view.frame.width/3
                    switch self.manualState {
                    case 0:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[3].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[1].id, image: cell.img_2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[7].id, image: cell.img_3)
                    case 1:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[2].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[0].id, image: cell.img_2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[6].id, image: cell.img_3)
                    case 2:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[5].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[1].id, image: cell.img_2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[9].id, image: cell.img_3)
                    case 3:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[4].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[0].id, image: cell.img_2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[8].id, image: cell.img_3)
                    case 4:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[13].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[11].id, image: cell.img_2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[15].id, image: cell.img_3)
                    case 5:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[12].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[10].id, image: cell.img_2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[14].id, image: cell.img_3)
                    case 6:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[13].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[11].id, image: cell.img_2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[15].id, image: cell.img_3)
                    case 7:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[12].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[10].id, image: cell.img_2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[14].id, image: cell.img_3)
                    default:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[5].id, image: cell.img_1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[1].id, image: cell.img_2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].ExternalImage[9].id, image: cell.img_3)
                    }
                    return cell
                }else if self.compareType == 3 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! Compare4TableViewCell
                    cell.cons_img_width.constant = self.view.frame.width/4
                    self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Film[2].id, image: cell.img1)
                    self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Film[3].id, image: cell.img2)
                    self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Film[4].id, image: cell.img3)
                    self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Film[5].id, image: cell.img4)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! Compare5TableViewCell
                    cell.cons_widht.constant = self.view.frame.width/5
                    switch self.typeState2 {
                    case 0:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[0].id, image: cell.img1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[1].id, image: cell.img2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[2].id, image: cell.img3)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[3].id, image: cell.img4)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[4].id, image: cell.img5)
                    case 1:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Lime[0].id, image: cell.img1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Lime[1].id, image: cell.img2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Lime[2].id, image: cell.img3)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Lime[3].id, image: cell.img4)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].Lime[4].id, image: cell.img5)
                    default:
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[0].id, image: cell.img1)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[1].id, image: cell.img2)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[2].id, image: cell.img3)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[3].id, image: cell.img4)
                        self.helper.loadLocalProfilePic(id: self.compareFollowUp[idx].InternalImage[4].id, image: cell.img5)
                    }
                    return cell
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            //return 0
            return self.compareList.count
        }else if tableView.tag == 3{
            return self.followUp.count
        }else if tableView.tag == 4{
            //return 0
            if self.selectedCompare == nil{
                return 0
            }else{
                return self.external_oral.count+self.internal_oral.count+self.film_oral.count+self.lime_oral.count
            }
        }else{
            //return 0
            return (self.compareFollowUp.count*2)+1
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView.tag == 1{
            self.settingState = indexPath.row
            self.vw_select_compare.isHidden = true
            self.vw_filter.isHidden = true
            self.compareType = indexPath.row
            if compareType == 5 || compareType == 6 {
                compareFollowUp.append(firstFollowup)
                compareFollowUp.append(middleFollowup)
                compareFollowUp.append(lastFollowup)
            }else{
                compareFollowUp.append(firstFollowup)
                compareFollowUp.append(lastFollowup)
            }
            self.tableView.reloadData()
        }else if tableView.tag == 3{
            self.lb_history_date.text = self.helper.dateToStringOnlyDate(date: self.followUp[indexPath.row].followdate)
            self.lb_history_followup.text = self.followUp[indexPath.row].followupnote
            self.inSelectDate = false
            self.selectedCompare = indexPath.row
            self.preView = self.followUp[self.selectedCompare!]
            self.tableViewHistory.reloadData()
            self.vw_preview_history.isHidden = false
        }else if tableView.tag == 4{
            
        }else{
            if indexPath.row == 0{
                // get a reference to the view controller for the popover
                popController = UIStoryboard(name: "Clinical", bundle: nil).instantiateViewController(withIdentifier: "popoverId") as! PopOverFilterViewController
                popController.compareList = self.compareList
                popController.settingState = self.settingState
                popController.manualSetting = self.manualState
                popController.typeState1 = self.typeState1
                popController.typeState2 = self.typeState2
                // set the presentation style
                popController.modalPresentationStyle = UIModalPresentationStyle.popover
                
                
                // set up the popover presentation controller
                
                popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
                popController.popoverPresentationController?.delegate = self
                popController.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)?.contentView // button
                popController.popoverPresentationController?.sourceRect = (tableView.cellForRow(at: indexPath)?.contentView.bounds)!
                // present the popover
                self.present(popController, animated: true, completion: nil)
                popController.tableView.layoutIfNeeded()
                popController.preferredContentSize = CGSize(width: self.view.frame.width, height: popController.tableView.contentSize.height)
            }else if indexPath.row > 0 && indexPath.row < self.compareFollowUp.count + 1 {
                self.vw_filter.isHidden = false
                self.vw_select_date.isHidden = false
                self.inSelectDate = true
                self.dateSelection = indexPath.row - 1
                if CGFloat(self.followUp.count * 44) > self.view.frame.height * 0.8 {
                    var height = (self.view.frame.height * 0.8) / 44
                    self.cons_height_select_date.constant = CGFloat(height * 44)
                }else{
                    self.cons_height_select_date.constant = CGFloat(self.followUp.count * 44)
                }
            }
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pop"{
            if let des = segue.destination as? PopOverFilterViewController{
                des.compareList = self.compareList
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
