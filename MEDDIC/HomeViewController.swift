//
//  HomeViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 5/11/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var menu = ["Patients","Group","Compare","Settings"]
    var img_menu = ["patient-01.png","group-01.png","photo-01.png","setting-01.png"]
    let sectionInsets = UIEdgeInsets(top: 2, left:2, bottom: 2, right: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let img_menu = cell.viewWithTag(1) as! UIImageView
        let lb_menu = cell.viewWithTag(2) as! UILabel
        lb_menu.text = self.menu[indexPath.row]
        img_menu.image = UIImage(named: self.img_menu[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (2 + 1)
        let availableWidth = self.collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
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
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "patient", sender: self)
        }else if indexPath.row == 1{
            self.performSegue(withIdentifier: "group", sender: self)
        }else if indexPath.row == 2{
            self.performSegue(withIdentifier: "compare", sender: self)
        }else{
            self.performSegue(withIdentifier: "setting", sender: self)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.performSegue(withIdentifier: "search", sender: self)
        return false
        
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
