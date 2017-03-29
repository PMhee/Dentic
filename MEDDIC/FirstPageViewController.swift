//
//  FirstPageViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/16/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class FirstPageViewController: UIViewController {
    let back = BackSystem()
    let phys = try! Realm().objects(RealmPhysician.self)
    @IBOutlet weak var img_logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.img_logo.layer.cornerRadius = 5
        self.img_logo.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if phys.count == 0 {
            self.performSegue(withIdentifier: "login", sender: self)
        }else{
            if (phys.first?.passcode)!.characters.count == 4{
            self.performSegue(withIdentifier: "passcode", sender: self)
            }else{
            self.performSegue(withIdentifier: "download", sender: self)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passcode"{
            if let des = segue.destination as? PasscodeViewController{
                des.passcode = (self.phys.first?.passcode)!
            }
        }
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
