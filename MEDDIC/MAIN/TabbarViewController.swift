//
//  TabbarViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/10/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "recentTabbar"), object: nil,userInfo:nil)
        }else if item.tag == 2{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "patientTabbar"), object: nil,userInfo:nil)
        }
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
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
