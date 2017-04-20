//
//  MoreViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/3/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class MoreViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    let phys = try! Realm().objects(RealmPhysician.self).first
    var stackfu = try! Realm().objects(RealmStackFollowup.self)
    var stackpic = try! Realm().objects(RealmStackPicture.self)
    var backStack = BackStack()
    var more = ["Physician Profile","Group","Sync","Change Password","Passcode Lock","Logout"]
    let moreImage = ["ic_profile","ic_group_more","ic_sync","ic_password_more","ic_passcode_more","ic_logout_more"]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(checkPasscode), name: NSNotification.Name(rawValue:"checkPasscode"), object: nil)
        //self.more[4] = "Sync(\(String(self.stackfu.count+self.stackpic.count)))"
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.more.count
    }
    func checkPasscode(){
        self.performSegue(withIdentifier: "passcode", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreTableViewCell
        cell.img_icon.image = UIImage(named: self.moreImage[indexPath.row])
        cell.lb_more.text = self.more[indexPath.row]
        if indexPath.row == 4 {
            if self.phys?.passcode.characters.count == 4{
                cell.switch.isOn = true
            }else{
                cell.switch.isOn = false
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.switch.isHidden = false
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyle.default
            cell.switch.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "profile", sender: self)
        }else if indexPath.row == 1{
            self.performSegue(withIdentifier: "group", sender: self)
        }else if indexPath.row == 2{
            self.backStack.sendStackPicture()
            self.backStack.sendStackFollowup()
        }else if indexPath.row == 3{
            self.performSegue(withIdentifier: "change", sender: self)
        }else if indexPath.row == 5{
            try! Realm().write {
                try! Realm().deleteAll()
            }
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passcode"{
            if let des = segue.destination as? PasscodeViewController{
                des.isSet = true
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
