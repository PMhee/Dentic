//
//  HistoryTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/19/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class HistoryTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource{
    var followups = List<RealmFollowup>()
    var ui = UITable()
    var helper = Helper()
    var isFirst = false
    @IBOutlet weak var tableViewFollowup: UITableView!
    
    @IBOutlet weak var cons_table_height: NSLayoutConstraint!
    @IBOutlet weak var lb_follow_date: UILabel!
    @IBOutlet weak var vw_layout: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setDelegate(){
        self.tableViewFollowup.delegate = self
        self.tableViewFollowup.dataSource = self
        self.tableViewFollowup.reloadData()
        self.tableViewFollowup.layoutIfNeeded()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.followups[indexPath.row].picurl.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nopic", for: indexPath) as! FollowupHistoryTableViewCell
            cell.followup = self.followups[indexPath.row]
            self.ui.shadow(vw_layout: cell.vw_layout)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lb_followupnote.text =  self.followups[indexPath.row].followupnote.replacingOccurrences(of: "<p>|</p>", with:"",options: .regularExpression )
            self.helper.downloadImageFrom(link: self.followups[indexPath.row].physician.picurl, contentMode: .scaleAspectFill, img: cell.img_profile)
            cell.lb_name.setTitle(self.followups[indexPath.row].physician.name, for: .normal)
            cell.lb_role.text = self.followups[indexPath.row].physician.role
            cell.lb_followtime.text = self.followups[indexPath.row].followtime
            cell.lb_hashtag.text = ""
            for i in 0..<self.followups[indexPath.row].meshtag.count{
                if i == 0{
                    cell.lb_hashtag.text = cell.lb_hashtag.text!+"#"+self.followups[indexPath.row].meshtag[i].tag
                }else{
                    cell.lb_hashtag.text = cell.lb_hashtag.text!+"\n#"+self.followups[indexPath.row].meshtag[i].tag
                }
            }
            cell.setDelegate()
            if followups[indexPath.row].cusforms.count == 0 {
                cell.cons_collectionview.constant = 0
            }else{
                cell.cons_collectionview.constant = 85
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowupHistoryTableViewCell
            cell.followup = self.followups[indexPath.row]
            self.ui.shadow(vw_layout: cell.vw_layout)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lb_followupnote.text =  self.followups[indexPath.row].followupnote.replacingOccurrences(of: "<p>|</p>", with:"",options: .regularExpression )
            self.helper.downloadImageFrom(link: self.followups[indexPath.row].physician.picurl, contentMode: .scaleAspectFill, img: cell.img_profile)
            cell.lb_name.setTitle(self.followups[indexPath.row].physician.name, for: .normal)
            cell.lb_role.text = self.followups[indexPath.row].physician.role
            cell.lb_followtime.text = self.followups[indexPath.row].followtime
            cell.lb_hashtag.text = ""
            for i in 0..<self.followups[indexPath.row].meshtag.count{
                if i == 0{
                    cell.lb_hashtag.text = cell.lb_hashtag.text!+"#"+self.followups[indexPath.row].meshtag[i].tag
                }else{
                    cell.lb_hashtag.text = cell.lb_hashtag.text!+"\n#"+self.followups[indexPath.row].meshtag[i].tag
                }
            }
            cell.cons_img_height.constant = 200
            self.helper.loadLocalProfilePic(id:self.followups[indexPath.row].picurl[0].id , image: cell.img_history)
            if self.followups[indexPath.row].picurl.count > 1{
                cell.vw_filter.isHidden = false
                cell.lb_number_picture.isHidden = false
                cell.lb_number_picture.text = "+"+String(self.followups[indexPath.row].picurl.count-1)
            }else{
                cell.vw_filter.isHidden = true
                cell.lb_number_picture.isHidden = true
            }
            cell.setDelegate()
            if followups[indexPath.row].cusforms.count == 0 {
                cell.cons_collectionview.constant = 0
            }else{
                cell.cons_collectionview.constant = 85
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
