//
//  CheckboxTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/4/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class CheckboxTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    var option = [CustomFormOption]()
    var idx = 0
    var answer = CustomFormAnswer()
    @IBOutlet weak var img_star: UIImageView!
    @IBOutlet weak var lb_number: UILabel!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vw_layout: UIView!
    @IBOutlet weak var vw_number: UIView!
    @IBOutlet weak var cons_tableView: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setDelegate(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.option.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CheckBoxCheckTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.lb_question.text = self.option[indexPath.row].question
        cell.btn_check.layer.cornerRadius = 2
        cell.btn_check.layer.borderWidth = 1
        cell.btn_check.layer.masksToBounds = true
        cell.btn_check.layer.borderColor = UIColor.darkGray.cgColor
        for i in 0..<self.answer.checked.count{
            if Int(self.answer.checked[i].answer)! == indexPath.row{
                cell.img_tick.isHidden = false
                break
            }else{
                cell.img_tick.isHidden = true
            }
        }
        if self.answer.checked.count == 0 {
            cell.img_tick.isHidden = true
        }
        cell.btn_check.tag = indexPath.row
        cell.btn_check.addTarget(self, action: #selector(check_action), for: .touchUpInside)
        return cell
    }
    func check_action(sender:UIButton){
        try! Realm().write{
            var found = false
            for i in 0..<self.answer.checked.count{
                if Int(self.answer.checked[i].answer)! == sender.tag{
                    self.answer.checked.remove(at: i)
                    found = true
                    break
                }else if i == self.answer.checked.count-1{
                    
                }
            }
            if !found{
                let answer = Checked()
                answer.answer = String(sender.tag)
                self.answer.checked.append(answer)
            }
            if self.answer.checked.count == 0 {
                self.answer.requiredChecked = false
            }else{
                self.answer.requiredChecked = true
                
            }
        }
        self.tableView.reloadData()
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
