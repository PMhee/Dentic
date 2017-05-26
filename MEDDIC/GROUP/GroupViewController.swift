//
//  GroupViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/5/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class GroupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var api = APIGroup()
    var back = BackGroup()
    var backSystem = BackSystem()
    var ui = UILoading()
    //var groups = [Group]()
    var groups = try! Realm().objects(RealmGroup.self)
    var index = 0
    var helper = Helper()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.act.startAnimating()
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "add.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(addNew), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:20, height:20)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbarxw
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.act.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.api.listMyGroup(sessionid: self.backSystem.getSessionid(), success: {(success) in
            self.act.isHidden = true
            self.back.collectGroup(success: success)
            self.tableView.reloadData()
        }, failure: {(error) in
            self.act.isHidden = true
            self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
        })
    }
    func addNew(){
        self.performSegue(withIdentifier: "add", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img_group = cell.viewWithTag(1) as! UIImageView
        let lb_group = cell.viewWithTag(2) as! UILabel
        img_group.layer.cornerRadius = 25
        self.helper.loadLocalProfilePic(id: self.groups[indexPath.row].id, image:img_group)
        lb_group.text = self.groups[indexPath.row].groupname
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group"
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.api.deleteGroup(sessionid: self.backSystem.getSessionid(), groupid: self.groups[indexPath.row].id, success: {(success) in
                print(success)
                try! Realm().write {
                    try! Realm().delete(self.groups[indexPath.row])
                    self.tableView.reloadData()
                }
            }, failure: {(error) in
                
            })
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        tableView.deselectRow(at: indexPath, animated:true)
        self.performSegue(withIdentifier: "select", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select"{
            if let des = segue.destination as? GroupHomeViewController{
                des.group = self.groups[self.index]
            }
        }
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
