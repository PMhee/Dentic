//
//  CustomFormViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/22/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class CustomFormViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var vw_filter: UIView!
    var form = try! Realm().objects(CustomForm.self)
    var api = APIAddCustomForm()
    var back = BackCustomForm()
    var index = 0
    var color = Color()
    var helper = Helper()
    var system = BackSystem()
    var ui = UILoading()
    var patient = RealmPatient()
    var isQuestionare = false
    var fudocid = ""
    var isUpdate = false // for add more customform
    override func viewDidLoad() {
        super.viewDidLoad()
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "add.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(addNew), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:20, height:20)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.act.isHidden = true
        self.form = self.back.filterAnswer()
        self.tableView.reloadData()
        if self.form.count == 0 {
            self.act.isHidden = false
            self.act.startAnimating()
        self.api.listUpdatedCusform(sessionid: self.system.getSessionid(), updatetime: "", success: {(success) in
            self.back.downloadCoverCusForm(json: success)
            self.tableView.reloadData()
            self.act.isHidden = true
        }, failure: {(error) in
            self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
            self.act.isHidden = true
        })
        }else{
            self.api.listUpdatedCusform(sessionid: self.system.getSessionid(), updatetime: self.helper.dateToServer(date: self.back.getLastUpdate()), success: {(success) in
                self.back.downloadCoverCusForm(json: success)
                self.tableView.reloadData()
                self.act.isHidden = true
            }, failure: {(error) in
                self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
                self.act.isHidden = true
            })
        }
    }
    func addNew(sender:UIButton){
        self.performSegue(withIdentifier: "add", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.count
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
        self.index = indexPath.row
        if self.isQuestionare{
            if !self.form[indexPath.row].isDownload{
                self.vw_filter.isHidden = false
                self.act.isHidden = false
                self.act.startAnimating()
                self.api.getCusform(sessionid: self.system.getSessionid(), cusformid: self.form[indexPath.row].id, success: {(success) in
                    self.vw_filter.isHidden = true
                    self.act.isHidden = true
                    self.back.downloadCusForm(json: success,form:self.form[indexPath.row])
                    self.tableView.reloadData()
                    self.performSegue(withIdentifier: "show", sender: self)
                }, failure: {(error) in
                    self.ui.showErrorNav(error: "Internet connection error", view: self.view)
                    self.vw_filter.isHidden = false
                    self.act.isHidden = false
                })
            }else{
                self.performSegue(withIdentifier: "show", sender: self)
            }
        
        }else{
        self.performSegue(withIdentifier: "select", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func generateStar(indexPath:IndexPath,img1:UIImageView,img2:UIImageView,img3:UIImageView,img4:UIImageView,img5:UIImageView){
        let star = [img1,img2,img3,img4,img5]
        var index = Int(self.form[indexPath.row].star)
        for i in 0..<index{
            star[i].isHidden = false
            star[i].image = UIImage(named: "full_star.png")
        }
        for i in index..<star.count{
            star[i].image = UIImage(named: "emp_star.png")
        }
        let diff = self.form[indexPath.row].star - Double(index)
        if diff > 0.5{
            star[index].isHidden = false
            star[index].image = UIImage(named: "half_star.png")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select"{
            if let des = segue.destination as? CustomFormSectionViewController{
                des.cusform = self.form[self.index]
            }
        }else if segue.identifier == "show"{
            if let des = segue.destination as? ShowCustomFormViewController{
                //print(self.form[self.index])
                des.cusForm = self.form[self.index]
                des.patient = self.patient
                des.isUpdate = self.isUpdate
                des.fudocid = self.fudocid
            }
        }
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
