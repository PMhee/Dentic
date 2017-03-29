//
//  ShowGroupViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/6/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class ShowGroupViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    var isForm = false
    var backCusForm = BackCustomForm()
    var group = RealmGroup()
    var api = APIGroup()
    var apiCusForm = APIAddCustomForm()
    var backSystem = BackSystem()
    var back = BackGroup()
    var members = [RealmPhysician]()
    var grMembers = [RealmPhysician]()
    var ui = UILoading()
    var helper = Helper()
    var isShow = false
    var srMember = [RealmPhysician]()
    var tick = [Int]()
    var color = Color()
    var form = [CustomForm]()
    var cusForm = try! Realm().objects(CustomForm.self)
    var listAddCustomForm = [String]()
    var listRemoveCustomForm = [String]()
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var tableForm: UITableView!
    @IBOutlet weak var vw_myForm: UIView!
    @IBOutlet weak var btn_invite: UIButton!
    
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var vw_show_member: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vw_member: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var lb_email: UILabel!
    @IBOutlet weak var lb_telephone: UILabel!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var vw_profile: UIView!
    @IBOutlet weak var collectionViewMember: UICollectionView!
    
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.vw_member.isHidden = true
        self.vw_filter.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func tf_search_change(_ sender: UITextField) {
        self.api.listPhysician(keyword: sender.text!,sessionid: self.backSystem.getSessionid(), success: {(success) in
            self.tick = [Int]()
            self.srMember = self.back.enumPhysician(success: success)
            for i in 0..<self.members.count{
                for j in 0..<self.srMember.count{
                    
                    if self.members[i].id == self.srMember[j].id{
                        self.srMember.remove(at: j)
                        //self.tick.append(j)
                        break
                    }
                }
            }
            self.tableView.reloadData()
        }, failure: {(error) in
            print(error)
        })
    }
    
    @IBAction func btn_confirm_action(_ sender: UIButton) {
        for i in 0..<self.listAddCustomForm.count{
            self.api.addCustomFormToGroup(sessionid: self.backSystem.getSessionid(), groupid: self.group.id, cusformid: self.listAddCustomForm[i], success: {(success) in
                if i == self.listAddCustomForm.count-1{
                self.vw_filter.isHidden = true
                self.vw_myForm.isHidden = true
                self.isForm = false
                }
            }, failure: {(error) in
                print(error)
            })
        }
        if self.listAddCustomForm.count == 0 {
            self.vw_filter.isHidden = true
            self.vw_myForm.isHidden = true
            self.isForm = false
        }
    }
    @IBAction func btn_done_action(_ sender: UIButton) {
        self.vw_member.isHidden = true
        if self.grMembers.count > 0 {
            self.vw_filter.isHidden = false
            self.act.isHidden = false
            self.act.startAnimating()
            self.addMem(count:0,id:self.group.id)
            self.tf_search.text = ""
            self.srMember = [RealmPhysician]()
            self.tableView.reloadData()
        }
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var pageController: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.act.startAnimating()
        self.tf_search.delegate  = self
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile), name: NSNotification.Name(rawValue: NSNotification.Name("showProfile").rawValue), object: nil)
        self.gesture.delegate = self
        self.view.addGestureRecognizer(self.gesture)
        NotificationCenter.default.addObserver(self, selector: #selector(addMember), name: NSNotification.Name(rawValue: NSNotification.Name("addMember").rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCusform), name: NSNotification.Name(rawValue: NSNotification.Name("showCusform").rawValue), object: nil)
        // Do any additional setup after loading the view.
    }
    func addMem(count:Int,id:String){
        for i in 0..<self.grMembers.count {
            self.api.addMember(sessionid: self.backSystem.getSessionid(), groupid: self.group.id, userid: self.grMembers[i].userid, role: "member", success: {(success) in
                if i == self.grMembers.count-1{
                    self.api.listMemberInGroup(sessionid: self.backSystem.getSessionid(), groupid: self.group.id, success: {(success) in
                        self.members = self.back.enumMembers(success: success)
                        self.collectionView.reloadData()
                        self.vw_filter.isHidden = true
                        self.act.isHidden = true
                        self.collectionView.layoutIfNeeded()
                    }, failure: {(error) in
                        self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
                    })
                }
            }, failure: {(error) in
                print(error)
            })
        }
    }
    func showCusform(notification:Notification){
        self.vw_filter.isHidden = false
        self.act.isHidden = false
        self.apiCusForm.getCusform(sessionid: self.backSystem.getSessionid(), cusformid: notification.userInfo?["id"] as! String, success: {(success) in
            self.vw_filter.isHidden = true
            self.act.isHidden = true
            self.backCusForm.showCusForm(json: success)
            self.performSegue(withIdentifier: "showCusform", sender: self)
        }, failure: {(error) in
            //            self.ui.showErrorNav(error: "Internet connection error", view: self.view)
            self.vw_filter.isHidden = false
            self.act.isHidden = false
        })
        
    }
    func showMyForm(button:UIButton){
        self.vw_filter.isHidden = false
        self.vw_myForm.isHidden = false
        if self.cusForm.count == 0 {
            self.act.isHidden = false
            self.act.startAnimating()
            self.apiCusForm.listUpdatedCusform(sessionid: self.backSystem.getSessionid(), updatetime: "", success: {(success) in
                self.backCusForm.downloadCoverCusForm(json: success)
                self.tableForm.reloadData()
                self.act.isHidden = true
            }, failure: {(error) in
                self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
                self.act.isHidden = true
            })
        }else{
            self.apiCusForm.listUpdatedCusform(sessionid: self.backSystem.getSessionid(), updatetime: self.helper.dateToServer(date: self.backCusForm.getLastUpdate()), success: {(success) in
                self.backCusForm.downloadCoverCusForm(json: success)
                self.tableForm.reloadData()
                self.act.isHidden = true
            }, failure: {(error) in
                self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
                self.act.isHidden = true
            })
        }
        self.tableForm.reloadData()
        self.isForm = true
    }
    func addMember(notification:Notification){
        self.grMembers = [RealmPhysician]()
        self.collectionViewMember.reloadData()
        self.tableView.reloadData()
        self.btn_invite.setTitle("invite (0)", for: .normal)
        self.navigationController?.isNavigationBarHidden = true
        self.vw_member.isHidden = false
        if self.grMembers.count > 0 {
            self.vw_show_member.isHidden = false
        }else{
            //self.vw_show_member.isHidden = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func showProfile(notification:Notification){
        var profile = notification.userInfo?["physician"] as! RealmPhysician
        self.vw_profile.isHidden = false
        self.vw_filter.isHidden = false
        self.isShow = true
        self.helper.downloadImageFrom(link: profile.picurl, contentMode: .scaleAspectFill, img: self.img_profile)
        self.img_profile.layer.cornerRadius = 2
        self.img_profile.layer.masksToBounds = true
        self.img_profile.layer.borderWidth = 2
        self.img_profile.layer.borderColor = UIColor.white.cgColor
        self.lb_name.text = profile.name
        self.lb_telephone.text = "Tel: "+profile.telephone
        self.lb_email.text = "Email: "+profile.email
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! CustomFormTableViewCell
            let tick = cell.viewWithTag(1) as! UILabel
            tick.isHidden = true
            for i in 0..<self.listAddCustomForm.count{
                if self.listAddCustomForm[i] == self.cusForm[indexPath.row+1].id{
                    tick.isHidden = false
                    break
                }
            }
            cell.lb_name.text = self.cusForm[indexPath.row+1].title
            cell.lb_category.text = self.cusForm[indexPath.row+1].category
            self.helper.downloadImageFrom(link: self.cusForm[indexPath.row+1].icon, contentMode: .scaleAspectFill, img: cell.img_icon)
            cell.vw_icon.backgroundColor = UIColor(netHex:self.cusForm[indexPath.row+1].color)
            cell.vw_icon.layer.borderWidth = 0.5
            cell.vw_icon.layer.borderColor = UIColor.darkGray.cgColor
            cell.vw_icon.layer.cornerRadius = 3
            cell.vw_icon.layer.masksToBounds = true
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img_profile = cell.viewWithTag(1) as! UIImageView
        let lb_name = cell.viewWithTag(2) as! UILabel
        let lb_tick = cell.viewWithTag(3) as! UILabel
        self.helper.downloadImageFrom(link: self.srMember[indexPath.row].picurl, contentMode: .scaleAspectFill, img: img_profile)
        lb_name.text = self.srMember[indexPath.row].name
        lb_tick.layer.cornerRadius = 10
        lb_tick.layer.masksToBounds = true
        var found = false
        for i in 0..<self.tick.count{
            if indexPath.row == tick[i]{
                lb_tick.text = "✓"
                lb_tick.backgroundColor = UIColor(netHex: self.color.flatGreenDark)
                found = true
                break
            }
        }
        img_profile.layer.cornerRadius = 25
        if !found{
            lb_tick.text = ""
            lb_tick.backgroundColor = UIColor(netHex: 0xeeeeee)
        }
        return cell
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return self.cusForm.count-1
        }else{
        return self.srMember.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var found = false
        var index = 0
        if tableView.tag == 1{
            for i in 0..<self.listAddCustomForm.count{
                if self.cusForm[indexPath.row+1].id == self.listAddCustomForm[i]{
                    index = i
                    found = true
                    break
                }
            }
            if found {
                self.listAddCustomForm.remove(at: index)
            }else{
                self.listAddCustomForm.append(self.cusForm[indexPath.row+1].id)
            }
            self.tableForm.reloadData()
        }else{
        var found = false
        self.tf_search.resignFirstResponder()
        for i in 0..<self.tick.count{
            if self.tick[i] == indexPath.row{
                found = true
                tick.remove(at: i)
                self.tableView.reloadData()
                for j in 0..<grMembers.count{
                    if self.grMembers[j].id == self.srMember[indexPath.row].id{
                        self.grMembers.remove(at: j)
                        self.btn_invite.setTitle("invite (\(self.grMembers.count))", for: .normal)
                        self.collectionViewMember.reloadData()
                        if self.grMembers.count == 0 {
                            self.vw_show_member.isHidden = true
                        }
                        break
                    }
                }
                break
            }
        }
        if !found{
            self.grMembers.append(srMember[indexPath.row])
            self.btn_invite.setTitle("invite (\(self.grMembers.count))", for: .normal)
            self.vw_show_member.isHidden = false
            self.collectionViewMember.reloadData()
            self.tick.append(indexPath.row)
            self.tableView.reloadData()
        }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.api.listCustomFormInGroup(sessionid: self.backSystem.getSessionid(), groupid: self.group.id, success: {(success) in
            self.form = self.back.enumCoverCusForm(json: success)
            for i in 0..<self.form.count{
                self.listAddCustomForm.append(self.form[i].id)
            }
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }, failure: {(error) in
            print(error)
        })
        self.api.listMemberInGroup(sessionid: self.backSystem.getSessionid(), groupid: self.group.id, success: {(success) in
            self.members = self.back.enumMembers(success: success)
            self.collectionView.reloadData()
            self.act.isHidden = true
            self.vw_filter.isHidden = true
            self.collectionView.layoutIfNeeded()
        }, failure: {(error) in
            self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
            self.vw_filter.isHidden = true
            self.act.isHidden = true
        })
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.isForm{
            if self.helper.inBound(x: touch.location(in: self.vw_myForm).x, y: touch.location(in: self.vw_myForm).y, view: self.vw_myForm){
                return false
            }else{
                self.vw_filter.isHidden = true
                self.vw_myForm.isHidden = true
                self.isForm = false
                return true
            }
        }
        if self.isShow{
            if self.helper.inBound(x: touch.location(in: self.vw_profile).x, y: touch.location(in: self.vw_profile).y, view: self.vw_profile){
                return false
            }else{
                self.vw_filter.isHidden = true
                self.vw_profile.isHidden = true
                self.isShow = false
                return true
            }
        }else{
            return false
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 2{
         return self.grMembers.count
        }else{
        return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag != 2 {
        return CGSize(width:self.view.frame.width,height:self.collectionView.frame.height)
        }else{
            return CGSize(width: 80, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "member", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            let lb_name = cell.viewWithTag(2) as! UILabel
            self.helper.downloadImageFrom(link: self.grMembers[indexPath.row].picurl, contentMode: .scaleAspectFill, img: img)
            lb_name.text = self.grMembers[indexPath.row].name
            
            img.layer.cornerRadius = 25
            return cell
        }else{
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShowGroupCollectionViewCell
            cell.members = self.members
            cell.setDelegate()
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cusform", for: indexPath) as! ShowGroupCustomFormCollectionViewCell
            cell.form = self.form
            cell.vw_filter = self.vw_filter
            cell.act = self.act
            cell.setDelegate()
            cell.btn_add.addTarget(self, action: #selector(showMyForm), for: .touchUpInside)
            return cell
        }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == self.view.frame.width{
            self.pageController.currentPage = 1
        }else if scrollView.contentOffset.x == 0{
            self.pageController.currentPage = 0
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCusform"{
            if let des = segue.destination as? ShowCustomFormViewController{
                des.cusForm = try! Realm().objects(CustomForm.self).first!
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
