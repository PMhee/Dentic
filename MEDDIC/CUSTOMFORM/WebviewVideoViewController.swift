//
//  WebviewVideoViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/27/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class WebviewVideoViewController: UIViewController,UIWebViewDelegate {
    var link: String!
    var helper = Helper()
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var progress: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: self.link)
        let request = NSURLRequest(url: url as! URL)
        self.webview.loadRequest(request as URLRequest)
        self.webview.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.progress.setProgress(0.1, animated: false)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.progress.setProgress(1.0, animated: true)
        self.helper.delay(1){
            self.progress.progressTintColor = UIColor(netHex:0x587EBF)
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.progress.setProgress(1.0, animated: true)
        self.helper.delay(1){
            self.progress.progressTintColor = UIColor(netHex:0x587EBF)
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
