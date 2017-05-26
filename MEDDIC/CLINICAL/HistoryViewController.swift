//
//  HistoryViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/19/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    var ui = UITable()
    var api = APIPatient()
    var back = BackPatient()
    var uiLoading = UILoading()
    var fu = RealmFollowup()
    var backSystem = BackSystem()
    var patient = RealmPatient()
    var helper = Helper()
    var color = Color()
    var isFirst = true
    var followUp = try! Realm().objects(RealmListFollowup.self)
    var picture = [Picture]()
    var viewForZoom = UIView()
    var start_x : CGFloat = 0
    var begin_x : CGFloat = 0
    var isFirstLoad = true
    var apiCusform = APIAddCustomForm()
    var backCusform = BackCustomForm()
    var cusform = CustomFormListAnswer()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vw_panel: UIView!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func btn_close_action(_ sender: UIButton) {
        self.collectionView.isHidden = true
        self.btn_close.isHidden = true
        self.vw_panel.isHidden = true
        self.isFirst = true
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture))
        self.view.addGestureRecognizer(panGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(showHistoryImage), name: NSNotification.Name(rawValue: "showHistoryImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCustomForm), name: NSNotification.Name(rawValue: "showCustomForm"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDentalHistory(notification:)), name: NSNotification.Name(rawValue: "showDentalHistory"), object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func showDentalHistory(notification:Notification){
        self.fu = notification.userInfo?["fu"] as! RealmFollowup
        self.performSegue(withIdentifier: "hist", sender: self)
    }
    func showCustomForm(notification:Notification){
        
        self.cusform = notification.userInfo?["cusform"] as! CustomFormListAnswer
        if self.cusform.customform == nil{
            self.vw_filter.isHidden = false
            self.act.isHidden = false
            self.apiCusform.getAnswerWithDetail(cfanswerid: cusform.cfansid, success: {(success) in
                self.backCusform.downloadAnswer(success: success, cusformListAns: self.cusform)
                self.performSegue(withIdentifier: "cusform", sender: self)
                self.vw_filter.isHidden = true
                self.act.isHidden = true
            }, failure: {(error) in
                
            })
        }else{
            self.performSegue(withIdentifier: "cusform", sender: self)
        }
    }
    func handlePanGesture(panGestureRecognizer : UIPanGestureRecognizer!){
        switch (panGestureRecognizer.state) {
        case UIGestureRecognizerState.began:
            self.start_x = (panGestureRecognizer.location(in: self.view).x)
            self.begin_x = (panGestureRecognizer.location(in: self.view).x)
        case UIGestureRecognizerState.changed:
            var position = self.begin_x
            position = panGestureRecognizer.location(in: self.view).x - begin_x
            self.begin_x = panGestureRecognizer.location(in: self.view).x
        //self.pageAnimation(view1: self.container_home, view2: self.container_rotation, const1: self.cons_Container_home_align_x, const2: self.cons_Container_rotation_align_x, changePosition: position)
        case UIGestureRecognizerState.ended:
            if self.start_x - (panGestureRecognizer.location(in: self.view).x) < -60 {
                self.navigationController?.popViewController(animated: true)
            }
        default: print("fail")
        }
    }
    func showHistoryImage(notification:Notification){
        self.picture = notification.userInfo?["picture"] as! [Picture]
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        self.btn_close.isHidden = false
        self.vw_panel.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.scrollToItem(at: IndexPath(row:0,section:0), at: .left, animated: false)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.viewForZoom = scrollView.viewWithTag(3) as! UIImageView
        if self.viewForZoom.frame.width == self.view.frame.width{
            self.collectionView.isScrollEnabled = true
        }else{
            self.collectionView.isScrollEnabled = false
        }
        return viewForZoom
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.act.isHidden = true
        self.act.startAnimating()
        if self.patient.listFollowUp.count == 0 {
            let vw = self.uiLoading.loadFromNibNamed(nibNamed: "NoDataFound")
            vw?.frame = CGRect(x: self.tableView.frame.origin.x, y: 0, width: self.tableView.frame.width, height: self.view.frame.height-0)
            self.view.addSubview(vw!)
        }else{
        }
        self.followUp = self.back.sortFollowup(followUp: self.patient.listFollowUp)
        self.tableView.reloadData()
        if self.followUp.count > 0{
            self.tableView.scrollToRow(at: IndexPath(row:0,section:0), at: .top, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let scrollview = cell.viewWithTag(1) as! UIScrollView
        scrollview.delegate = self
        let vw = scrollview.viewWithTag(2)
        let img = vw?.viewWithTag(3) as! UIImageView
        self.helper.loadLocalProfilePic(id: self.picture[indexPath.row].id, image: img)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.picture.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.lb_follow_date.text = self.helper.dateToStringOnlyDate(date: self.followUp[indexPath.row].date)
        cell.followups = self.followUp[indexPath.row].followup
        self.ui.shadow(vw_layout: cell.vw_layout)
        cell.setDelegate()
        cell.tableViewFollowup.layoutIfNeeded()
        cell.cons_table_height.constant = cell.tableViewFollowup.contentSize.height
        return  cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followUp.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cusform"{
            if let des = segue.destination as? ShowCustomFormViewController{
                des.cusForm = self.cusform.customform
                des.answer = self.cusform.customform_section_answer
                des.isAns = true
            }
        }else if segue.identifier == "hist"{
            if let des = segue.destination as? DentalHistoryViewController{
                des.followup  = self.fu
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
