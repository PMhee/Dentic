//
//  ShowPatientCompareViewController.swift
//  Dentic
//
//  Created by Tanakorn on 5/24/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class ShowPatientCompareViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var patient = RealmPatient()
    var helper = Helper()
    let sectionInsets = UIEdgeInsets(top: 2, left:2, bottom: 2, right: 2)
    @IBOutlet weak var lb_patient: UILabel!
    @IBOutlet weak var img_patient: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        let button: UIButton = UIButton()
        UIApplication.shared.isStatusBarHidden = false
        self.img_patient.layer.cornerRadius = 40
        self.img_patient.layer.masksToBounds = true
        self.helper.loadLocalProfilePic(id: self.patient.localid, image: self.img_patient)
        self.lb_patient.text = self.patient.name
        button.setImage(UIImage(named: "add.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(addNew), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:20, height:20)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbarxw
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.collectionView.reloadData()
    }
    func addNew(sender:UIBarButtonItem){
        self.performSegue(withIdentifier: "add", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        self.helper.loadLocalProfilePic(id: self.patient.comparePic[indexPath.row].id, image: img)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.patient.comparePic.count
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
            let paddingSpace = sectionInsets.left * (3 + 1)
            let availableWidth = self.view.frame.width - paddingSpace
            let widthPerItem = availableWidth / 3
            return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PreviewImage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PreviewImageViewController") as! PreviewImageViewController
        vc.isEdit = true
        vc.patient = self.patient
        vc.picID = self.patient.comparePic[indexPath.row].id
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.barTintColor = UIColor(netHex:0xB798B1)
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.present(navigationController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add"{
            if let des = segue.destination as? CompareViewController{
                des.patient = self.patient
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
