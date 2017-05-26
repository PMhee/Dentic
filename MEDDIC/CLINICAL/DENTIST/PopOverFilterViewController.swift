//
//  PopOverFilterViewController.swift
//  Dentic
//
//  Created by Tanakorn on 4/18/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class PopOverFilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var compareList = [String]()
    var settingState = 0
    var manualSetting = 0
    var typeState1 = 0
    var typeState2 = 0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCompareList(notification:)), name: NSNotification.Name(rawValue: "didSelectCompareList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectCeptOrPana(notification:)), name: NSNotification.Name(rawValue: "selectCeptOrPana"), object: nil)
        // Do any additional setup after loadixng the view.
    }
    func didSelectCompareList(notification:NSNotification){
        let idx = notification.userInfo?["index"] as! Int
        self.settingState = idx
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendCompareContentSize"), object: self, userInfo: ["contentSize":self.tableView.contentSize.height])
    }
    func selectCeptOrPana(notification:NSNotification){
        self.typeState1 = notification.userInfo?["index"] as! Int
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendCompareContentSize"), object: self, userInfo: ["contentSize":self.tableView.contentSize.height])
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as! SelectCompareTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.settingState = self.settingState
            cell.compareList = self.compareList
            cell.setDelegate()
            cell.tableView.layoutIfNeeded()
            cell.cons_tableView_height.constant = cell.tableView.contentSize.height
            cell.tableView.selectRow(at: IndexPath(row:self.settingState,section:0), animated: true, scrollPosition: .top)
            return cell
        }else if indexPath.row == 1 && self.settingState == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "1Manual", for: indexPath) as! ManualType1TableViewCell
            cell.sg_manual.selectedSegmentIndex = self.typeState1
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.row == 1 && self.settingState == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "2Manual", for: indexPath) as! ManualType2TableViewCell
            cell.sg_manual.selectedSegmentIndex = self.typeState2
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "setting", for: indexPath) as! ManualSettingTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.manualSetting = self.manualSetting
            if self.settingState == 0 {
                cell.sgDegree.removeSegment(at: 0, animated: false)
                cell.sgDegree.removeSegment(at: 0, animated: false)
                cell.sgDegree.insertSegment(withTitle: "L", at: 0, animated: true)
                cell.sgDegree.insertSegment(withTitle: "F", at: 0, animated: true)
            }else{
                cell.sgDegree.removeSegment(at: 0, animated: false)
                cell.sgDegree.removeSegment(at: 0, animated: false)
                cell.sgDegree.insertSegment(withTitle: "90º", at: 0, animated: true)
                cell.sgDegree.insertSegment(withTitle: "45º", at: 0, animated: true)
            }
            switch self.manualSetting {
            case 0:
                cell.sgFace.selectedSegmentIndex = 0
                cell.sgDegree.selectedSegmentIndex = 0
                cell.sgSmile.selectedSegmentIndex = 0
            case 1:
                cell.sgFace.selectedSegmentIndex = 0
                cell.sgDegree.selectedSegmentIndex = 0
                cell.sgSmile.selectedSegmentIndex = 1
            case 2:
                cell.sgFace.selectedSegmentIndex = 0
                cell.sgDegree.selectedSegmentIndex = 1
                cell.sgSmile.selectedSegmentIndex = 0
            case 3:
                cell.sgFace.selectedSegmentIndex = 0
                cell.sgDegree.selectedSegmentIndex = 1
                cell.sgSmile.selectedSegmentIndex = 1
            case 4:
                cell.sgFace.selectedSegmentIndex = 1
                cell.sgDegree.selectedSegmentIndex = 0
                cell.sgSmile.selectedSegmentIndex = 0
            case 5:
                cell.sgFace.selectedSegmentIndex = 1
                cell.sgDegree.selectedSegmentIndex = 0
                cell.sgSmile.selectedSegmentIndex = 1
            case 6:
                cell.sgFace.selectedSegmentIndex = 1
                cell.sgDegree.selectedSegmentIndex = 1
                cell.sgSmile.selectedSegmentIndex = 0
            case 7:
                cell.sgFace.selectedSegmentIndex = 1
                cell.sgDegree.selectedSegmentIndex = 1
                cell.sgSmile.selectedSegmentIndex = 1
            default:
                cell.sgFace.selectedSegmentIndex = 0
                cell.sgDegree.selectedSegmentIndex = 0
                cell.sgSmile.selectedSegmentIndex = 0
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.typeState1 == 1 || self.typeState1 == 2) && self.settingState == 0{
            return 2
        }else if self.settingState == 0 {
            return 3
        }else if self.settingState == 3 || self.settingState == 4{
            return 1
        }else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
