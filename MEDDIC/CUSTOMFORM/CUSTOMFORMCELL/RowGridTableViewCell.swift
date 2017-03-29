//
//  RowGridTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/8/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class RowGridTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var column = [CustomFormOption]()
    var heightForRow : CGFloat = 30
    var answer = CustomFormAnswer()
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.column.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChoiceCollectionViewCell
        cell.lb_mark.text = "(\(indexPath.row+1))"
        cell.btn_check.layer.cornerRadius = 12
        cell.btn_check.layer.masksToBounds = true
        cell.btn_check.layer.borderWidth = 1
        cell.btn_check.layer.borderColor = UIColor.darkGray.cgColor
        cell.btn_check.addTarget(self, action: #selector(check_action), for: .touchUpInside)
        cell.btn_check.tag = indexPath.row
        if self.answer.checked.count == 0 {
            cell.img_check.isHidden = true
        }else{
            if Int(self.answer.checked[0].answer)! == indexPath.row{
                cell.img_check.isHidden = false
            }else{
                cell.img_check.isHidden = true
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100 , height: self.heightForRow)
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
        self.collectionView.reloadData()
    }
    func setDelegate(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        //self.collectionView.layoutIfNeeded()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
