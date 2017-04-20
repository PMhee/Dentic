//
//  SelectCompareTableViewCell.swift
//  Dentic
//
//  Created by Tanakorn on 4/18/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class SelectCompareTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {
    var compareList = [String]()
    var settingState = 0
    @IBOutlet weak var cons_tableView_height: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lb = cell.viewWithTag(2) as! UILabel
        let img = cell.viewWithTag(1) as! UIImageView
        lb.text = self.compareList[indexPath.row]
        img.image = UIImage(named: self.compareList[indexPath.row])
        return cell
    }
    func setDelegate(){
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.compareList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.settingState = indexPath.row
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didSelectCompareList"), object: self, userInfo: ["index":indexPath.row])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectCompareTable"), object: self, userInfo: ["index":indexPath.row]
        )
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
