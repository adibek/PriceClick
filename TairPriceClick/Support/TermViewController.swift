//
//  TermViewController.swift
//  Price Click
//
//  Created by Dakanov Sultan on 23.12.17.
//  Copyright © 2017 Yernur. All rights reserved.
//

import UIKit


class TermViewController: UIViewController {
    
    override func viewDidLoad() {
        let priceClick = "http://api.priceclick.kz/terms"
        webView.loadRequest(URLRequest(url: URL(string: priceClick)!))
        // Do any additional setup after loading the view.
        title = "Пользовательское соглашение"
    }
    @IBOutlet var webView: UIWebView!
}
