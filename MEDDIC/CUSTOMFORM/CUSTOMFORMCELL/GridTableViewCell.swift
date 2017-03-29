//
//  GridTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/7/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class GridTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableQuestion: UITableView!
    @IBOutlet weak var tableRow: UITableView!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var cons_top: NSLayoutConstraint!
    @IBOutlet weak var vw_layout: UIView!
    @IBOutlet weak var lb_number: UILabel!
    @IBOutlet weak var cons_height_row: NSLayoutConstraint!
    @IBOutlet weak var cons_traling: NSLayoutConstraint!
    @IBOutlet weak var cons_scrollView_height: NSLayoutConstraint!
    @IBOutlet weak var cons_ans_height: NSLayoutConstraint!
    @IBOutlet weak var cons_question_height: NSLayoutConstraint!
    var answer = CustomFormAnswer()
    var column = [CustomFormOption]()
    var row = [CustomFormGridOption]()
    var headHeight :CGFloat = 93.5
    var heightForRow = [CGFloat]()
    var isFirst = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setDelegate(){
        self.tableQuestion.delegate = self
        self.tableRow.delegate = self
        self.tableQuestion.dataSource = self
        self.tableRow.dataSource = self
        self.heightForRow = [CGFloat]()
        self.tableQuestion.reloadData()
        self.tableQuestion.layoutIfNeeded()
        self.tableRow.reloadData()
//        self.tableRow.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(headerHeight), name: NSNotification.Name(rawValue:"headerHeight"), object: nil)
    }
    func headerHeight(notification:Notification){
        if let height = notification.userInfo?["size"] as? CGFloat{
            self.headHeight = height
            self.cons_top.constant = self.headHeight+30
        }
        self.tableRow.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 2{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! HeaderGridTableViewCell
                cell.column = self.column
                cell.setDelegate()
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "choice", for: indexPath) as! RowGridTableViewCell
                cell.answer = self.answer.answerGrid[indexPath.row-1]
                cell.column = self.column
                cell.setDelegate()
                if self.heightForRow.count == self.row.count{
                cell.heightForRow = self.heightForRow[indexPath.row-1]
                }
                if indexPath.row % 2 == 1{
                    cell.collectionView.backgroundColor = UIColor(netHex: 0xEEEEEE)
                }else{
                    cell.collectionView.backgroundColor = UIColor.white
                }
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let lb_question = cell.viewWithTag(1) as! UILabel
            lb_question.text = self.row[indexPath.row].question
            if indexPath.row%2 == 0{
                cell.backgroundColor = UIColor(netHex: 0xEEEEEE)
            }else{
                cell.backgroundColor = UIColor.white
            }
            lb_question.sizeToFit()
            self.heightForRow.append(lb_question.frame.height+16)
            if heightForRow.count == self.row.count{
                if !self.isFirst{
                self.tableQuestion.reloadData()
                self.tableQuestion.layoutIfNeeded()
                    var sum :CGFloat = 0
                    for i in 0..<self.heightForRow.count{
                        sum+=self.heightForRow[i]
                    }
                    self.cons_scrollView_height.constant = sum
                    self.tableQuestion.reloadData()
                    self.isFirst = true
                }
                

            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 2{
            if indexPath.row == 0{
                return self.headHeight+30
            }else{
               // return UITableViewAutomaticDimension
                if self.heightForRow.count == self.row.count{
                return self.heightForRow[indexPath.row-1]
                }else{
                return 75
                }
            }
        }else{
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 2{
            return self.row.count+1
        }else{
            return self.row.count
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
