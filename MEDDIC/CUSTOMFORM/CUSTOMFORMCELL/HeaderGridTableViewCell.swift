//
//  ColumnTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/8/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class HeaderGridTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var column = [CustomFormOption]()
    var isHeightCalculated: Bool = false
    var lb_size : CGFloat = 0
    var isFirst = false
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.column.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let lb_question = cell.viewWithTag(1) as! UILabel
        lb_question.text = self.column[indexPath.row].question
        lb_question.sizeToFit()
        if self.lb_size < lb_question.frame.height{
        self.lb_size = lb_question.frame.height
        }
        if indexPath.row == self.column.count-1{
            if !isFirst{
                isFirst = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "headerHeight"), object: nil,userInfo:["size":self.lb_size])
                self.collectionView.reloadData()
            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100 , height: self.lb_size+30)
    }
    func setDelegate(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //self.collectionView.reloadData()
        //self.collectionView.layoutIfNeeded()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
