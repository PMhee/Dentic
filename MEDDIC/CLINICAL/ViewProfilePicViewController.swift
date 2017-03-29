//
//  ViewProfilePicViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/23/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class ViewProfilePicViewController: UIViewController {

    @IBOutlet weak var img_profile: UIImageView!
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.img_profile.image = self.image
        // Do any additional setup after loading the view.
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
