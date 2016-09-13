//
//  ReadFullArticleViewController.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/26/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class ReadFullArticleViewController: UIViewController {
    @IBOutlet var myProgressView: UIProgressView!
    var articleUrl:String = ""
    var theBool:Bool = false
    var timer:NSTimer!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: articleUrl)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        theBool = true;
        timer.invalidate()
       // myProgressView.removeFromSuperview()
    }
//
    func webViewDidStartLoad(webView: UIWebView!) {
        myProgressView.progress = 0;
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(ReadFullArticleViewController.timerCallback), userInfo: nil, repeats: true)
    }

    func timerCallback() {
        if (theBool) {
            if (myProgressView.progress >= 1) {
                myProgressView.hidden = true;
                timer.invalidate()
            }
            else {
                myProgressView.progress += 0.1;
            }
        }
        else {
            myProgressView.progress += 0.01;
            if (myProgressView.progress >= 0.95) {
                myProgressView.progress = 0.95;
            }
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
