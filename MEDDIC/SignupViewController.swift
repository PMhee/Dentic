//
//  SignupViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/20/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var myProgressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://smr.cp.eng.chula.ac.th")
        let request = NSURLRequest(url: url as! URL)
        self.webview.loadRequest(request as URLRequest)
        self.webview.delegate = self
        // Do any additional setup after loading the view.
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.myProgressView.setProgress(0.1, animated: false)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.myProgressView.setProgress(1.0, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.myProgressView.setProgress(1.0, animated: true)
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
