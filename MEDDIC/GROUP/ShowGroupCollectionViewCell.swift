//
//  ShowGroupCollectionViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/6/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class ShowGroupCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_invite: UIButton!
    var members = [RealmPhysician]()
    var helper = Helper()
    func setDelegate(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    @IBAction func btn_addMember_action(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addMember"), object: self, userInfo: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img_profile = cell.viewWithTag(1) as! UIImageView
        let lb_name = cell.viewWithTag(2) as! UILabel
        self.helper.downloadImageFrom(link: self.members[indexPath.row].picurl, contentMode: .scaleAspectFill, img: img_profile)
        lb_name.text = self.members[indexPath.row].name
        img_profile.layer.cornerRadius = 22
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showProfile"), object: self, userInfo: ["physician":self.members[indexPath.row]])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Members"
    }
}
