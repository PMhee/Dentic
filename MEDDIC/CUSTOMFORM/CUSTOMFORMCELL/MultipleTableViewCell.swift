//
//  MultipleTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/4/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class MultipleTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    var option = [CustomFormOption]()
    var idx = 0
    var answer = CustomFormAnswer()
    @IBOutlet weak var cons_table: NSLayoutConstraint!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img_star: UIImageView!
    @IBOutlet weak var lb_no: UILabel!
    @IBOutlet weak var vw_number: UIView!
    @IBOutlet weak var vw_layout: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setDelegate(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MultipleCheckTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.lb_question.text = self.option[indexPath.row].question
        if self.answer.checked.count == 0 {
            cell.img_check.isHidden = true
        }else{
            if Int(self.answer.checked[0].answer)! == indexPath.row{
                cell.img_check.isHidden = false
            }else{
                cell.img_check.isHidden = true
            }
        }
        cell.btn_check.layer.cornerRadius = 15
        cell.btn_check.layer.borderWidth = 1
        cell.btn_check.layer.masksToBounds = true
        cell.btn_check.layer.borderColor = UIColor.darkGray.cgColor
        cell.btn_check.tag = indexPath.row
        cell.btn_check.addTarget(self, action: #selector(check_action), for: .touchUpInside)
        return cell
    }
    func check_action(sender:UIButton){
        try! Realm().write{
            if self.answer.checked.count == 0{
                let answer = Checked()
                answer.answer = String(sender.tag)
                self.answer.checked.append(answer)
            }else{
                self.answer.checked[0].answer = String(sender.tag)
            }
            if self.answer.checked.count == 0 {
                self.answer.requiredChecked = false
            }else{
                self.answer.requiredChecked = true
            }
        }
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.option.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
