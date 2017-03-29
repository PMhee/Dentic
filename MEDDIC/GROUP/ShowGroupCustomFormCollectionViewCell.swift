//
//  ShowGroupCustomFormCollectionViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/16/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class ShowGroupCustomFormCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_add: UIButton!
    var vw_filter = UIView()
    var act = UIActivityIndicatorView()
    var helper = Helper()
    var api = APIAddCustomForm()
    var system = BackSystem()
    var back = BackCustomForm()
    var form = [CustomForm]()
    func setDelegate(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CustomForm"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomFormTableViewCell
        cell.lb_no.text = String(indexPath.row+1)
        cell.lb_name.text = self.form[indexPath.row].title
        cell.lb_category.text = self.form[indexPath.row].category
        self.helper.downloadImageFrom(link: self.form[indexPath.row].icon, contentMode: .scaleAspectFill, img: cell.img_icon)
        cell.vw_icon.backgroundColor = UIColor(netHex:self.form[indexPath.row].color)
        cell.vw_icon.layer.borderWidth = 0.5
        cell.vw_icon.layer.borderColor = UIColor.darkGray.cgColor
        cell.vw_icon.layer.cornerRadius = 3
        cell.vw_icon.layer.masksToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showCusform"), object: self, userInfo: ["id":self.form[indexPath.row].id]
        )
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.count
    }
}
