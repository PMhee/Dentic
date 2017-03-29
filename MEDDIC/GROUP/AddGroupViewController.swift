//
//  AddGroupViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/5/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var members = [RealmPhysician]()
    var grMembers = [RealmPhysician]()
    var tick = [Int]()
    var color = Color()
    var ui = UILoading()
    var btn = UIButton()
    @IBOutlet weak var collectionView_member: UICollectionView!
    @IBOutlet weak var btn_invite: UIButton!
    @IBOutlet weak var vw_picker: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tf_description: UITextField!
    @IBOutlet weak var tf_groupname: UITextField!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var vw_members: UIView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    var api = APIGroup()
    var back = BackGroup()
    var backSystem = BackSystem()
    var helper = Helper()
    @IBOutlet weak var tableView: UITableView!
    @IBAction func tf_search_change(_ sender: UITextField) {
        self.api.listPhysician(keyword: sender.text!,sessionid: self.backSystem.getSessionid(), success: {(success) in
            self.tick = [Int]()
            self.members = self.back.enumPhysician(success: success)
            for i in 0..<self.grMembers.count{
                for j in 0..<self.members.count{
                    
                    if self.grMembers[i].id == self.members[j].id{
                        self.tick.append(j)
                        break
                    }
                }
            }
            self.tableView.reloadData()
        }, failure: {(error) in
            print(error)
        })
    }
    @IBOutlet weak var tf_search: UITextField!
    @IBAction func change_pic_action(_ sender: UIButton) {
        

    }
    @IBAction func btn_back_action(_ sender: UIButton) {
        self.tf_search.resignFirstResponder()
        self.vw_members.isHidden = true
        self.vw_picker.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.collectionView.reloadData()
    }
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.tf_search.resignFirstResponder()
        self.vw_members.isHidden = true
        self.vw_picker.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.act.isHidden = true
        self.tf_search.delegate = self
        self.tf_groupname.delegate = self
        self.tf_description.delegate = self
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(doneAction), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x:self.view.frame.width-40, y:0, width:40, height:40)
        let barButton = UIBarButtonItem(customView: btn)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        // Do any additional setup after loading the view.
    }
    func doneAction(){
        self.tf_groupname.resignFirstResponder()
        self.tf_description.resignFirstResponder()
        self.vw_filter.isHidden = false
        self.act.isHidden = false
        self.act.startAnimating()
        
        if self.tf_groupname.text! == ""{
            let alertController = UIAlertController(title: "Error", message: "Please fill group name", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.api.createGroup(sessionid: self.backSystem.getSessionid(), groupname: self.tf_groupname.text!, groupdescription: self.tf_description.text!, success: {(success) in
                for i in 0..<self.grMembers.count {
                    if let content = success.value(forKey: "content") as? NSDictionary{
                    if let ID = content.value(forKey: "_id") as? NSDictionary{
                        if let id = ID.value(forKey: "$id") as? String{
                            self.api = APIGroup()
                            self.api.addMember(sessionid: self.backSystem.getSessionid(), groupid: id, userid: self.grMembers[i].userid, role: "member", success: {(success) in
                                print(success)
                                if i == self.grMembers.count-1{
                                    self.vw_filter.isHidden = true
                                    self.act.isHidden = true
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }, failure: {(error) in
                                print(error)
                            })
                        }
                    }
                    }
                }
                
            }, failure: {(error) in
                self.vw_filter.isHidden = true
                self.act.isHidden = true
                self.ui.showError(error: "Internet connection problem", view: self.view)
            })
        }
    }
    func addMem(count:Int,id:String){
        self.api.addMember(sessionid: self.backSystem.getSessionid(), groupid: id, userid: self.grMembers[count].userid, role: "member", success: {(success) in
            print(success)
            if count == self.grMembers.count-1{
                self.vw_filter.isHidden = true
                self.act.isHidden = true
                self.navigationController?.popViewController(animated: true)
            }else{
                self.addMem(count: count+1, id: id)
            }
        }, failure: {(error) in
            print(error)
        })
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 2{
            return grMembers.count
        }else{
            return grMembers.count+1
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            let lb_name = cell.viewWithTag(2) as! UILabel
            let lb_remove = cell.viewWithTag(3) as! UILabel
            if indexPath.row == 0 {
                img.image = UIImage(named: "add-group")
                lb_name.text = "Add member"
                lb_remove.isHidden = true
            }else{
                lb_remove.isHidden = false
                self.helper.downloadImageFrom(link: self.grMembers[indexPath.row-1].picurl, contentMode: .scaleAspectFill, img: img)
                lb_name.text = self.grMembers[indexPath.row-1].name
            }
            img.layer.cornerRadius = 25
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2{
            for i in 0..<members.count{
                if members[i].id == self.grMembers[indexPath.row].id{
                    for k in 0..<self.tick.count{
                        if tick[k] == i{
                            tick.remove(at: k)
                            break
                        }
                    }
                    self.tableView.reloadData()
                    break
                }
            }
            self.grMembers.remove(at: indexPath.row)
            self.btn_invite.setTitle("invite (\(self.grMembers.count))", for: .normal)
            if self.grMembers.count == 0 {
                self.vw_picker.isHidden = true
            }
            self.collectionView_member.reloadData()
        }else{
            if indexPath.row == 0 {
                self.tf_search.text = ""
                self.members = [RealmPhysician]()
                self.tableView.reloadData()
                self.navigationController?.isNavigationBarHidden = true
                self.vw_members.isHidden = false
                if self.grMembers.count > 0 {
                    self.vw_picker.isHidden = false
                }
            }else{
                self.grMembers.remove(at: indexPath.row-1)
                self.btn_invite.setTitle("invite (\(self.grMembers.count))", for: .normal)
                self.collectionView.reloadData()
                self.collectionView_member.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var found = false
        self.tf_search.resignFirstResponder()
        for i in 0..<self.tick.count{
            if self.tick[i] == indexPath.row{
                found = true
                tick.remove(at: i)
                self.tableView.reloadData()
                for j in 0..<grMembers.count{
                    if self.grMembers[j].id == self.members[indexPath.row].id{
                        self.grMembers.remove(at: j)
                        self.btn_invite.setTitle("invite (\(self.grMembers.count))", for: .normal)
                        self.collectionView_member.reloadData()
                        if self.grMembers.count == 0 {
                            self.vw_picker.isHidden = true
                        }
                        break
                    }
                }
                break
            }
        }
        if !found{
            self.grMembers.append(members[indexPath.row])
            self.btn_invite.setTitle("invite (\(self.grMembers.count))", for: .normal)
            self.vw_picker.isHidden = false
            self.collectionView_member.reloadData()
            self.tick.append(indexPath.row)
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img_profile = cell.viewWithTag(1) as! UIImageView
        let lb_name = cell.viewWithTag(2) as! UILabel
        let lb_tick = cell.viewWithTag(3) as! UILabel
        self.helper.downloadImageFrom(link: self.members[indexPath.row].picurl, contentMode: .scaleAspectFill, img: img_profile)
        lb_name.text = self.members[indexPath.row].name
        lb_tick.layer.cornerRadius = 10
        lb_tick.layer.masksToBounds = true
        img_profile.layer.cornerRadius = 25
        var found = false
        for i in 0..<self.tick.count{
            if indexPath.row == tick[i]{
                lb_tick.text = "✓"
                lb_tick.backgroundColor = UIColor(netHex: self.color.flatGreenDark)
                found = true
                break
            }
        }
        if !found{
            lb_tick.text = ""
            lb_tick.backgroundColor = UIColor(netHex: 0xeeeeee)
        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
