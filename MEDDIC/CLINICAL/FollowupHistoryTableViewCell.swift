//
//  FollowupHistoryTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/6/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class FollowupHistoryTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate {
    var followup = RealmFollowup()
    var helper = Helper()
    @IBOutlet weak var lb_hashtag: UILabel!
    @IBOutlet weak var btn_click_image: UIButton!
    @IBOutlet weak var lb_number_picture: UILabel!
    @IBOutlet weak var img_history: UIImageView!
    @IBOutlet weak var lb_followupnote: UILabel!
    @IBOutlet weak var lb_followtime: UILabel!
    
    @IBOutlet weak var cons_collectionview: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cons_img_height: NSLayoutConstraint!
    @IBOutlet weak var lb_role: UILabel!
    @IBOutlet weak var lb_name: UIButton!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var vw_layout: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBAction func btn_image_click_action(_ sender: UIButton) {
        var picture = [Picture]()
        for i in 0..<self.followup.picurl.count{
            picture.append(self.followup.picurl[i])
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showHistoryImage"), object: nil,userInfo:["picture":picture])
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setDelegate(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let vw = cell.viewWithTag(1)
        let img = cell.viewWithTag(2) as! UIImageView
        let lb_name = cell.viewWithTag(3) as! UILabel
        let lb_score = cell.viewWithTag(4) as! UILabel
        vw?.layer.cornerRadius = 5
        vw?.layer.masksToBounds = true
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor.darkGray.cgColor
        vw?.backgroundColor = UIColor(netHex:self.followup.cusforms[indexPath.row].color)
        self.helper.downloadImageFrom(link: self.followup.cusforms[indexPath.row].picurl, contentMode: .scaleAspectFill, img: img)
        lb_name.text = self.followup.cusforms[indexPath.row].cusfomrname
        lb_score.text = String(format:"%.2f", self.followup.cusforms[indexPath.row].score)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.followup.cusforms.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showCustomForm"), object: nil,userInfo:["cusform":self.followup.cusforms[indexPath.row]])
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
