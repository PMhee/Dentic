//
//  HashtagViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/15/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class HashtagViewController: UIViewController {
    var back = BackRepresent()
    
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var lb_result: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tf_search_change(_ sender: UITextField) {
        self.lb_result.text = "found "+String(self.back.findHashtag(tag: sender.text!).count)
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
