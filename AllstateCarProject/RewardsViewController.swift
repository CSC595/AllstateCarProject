//
//  RewardsViewController.swift
//  AllstateCarProject
//
//  Created by Lew Flauta on 2/10/16.
//  Copyright © 2016 ZZC. All rights reserved.
//

import UIKit
import WebKit

class RewardsViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://www.tangocard.com/the-rewards-catalog/")!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }



}
