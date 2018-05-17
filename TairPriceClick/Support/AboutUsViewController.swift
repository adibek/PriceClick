//
//  AboutUsViewController.swift
//  Price Click
//
//  Created by Dakanov Sultan on 23.12.17.
//  Copyright © 2017 Yernur. All rights reserved.
//

import UIKit


class AboutUsViewController: UIViewController {

  
    @IBAction func pertnerEmail(_ sender: UIButton) {
        let email = "partner@priceclick.kz"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func tooEmail(_ sender: UIButton) {
        let email = "info@priceclick.kz"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func phoneButton(_ sender: UIButton) {
        let url: NSURL = URL(string:"TEL:+77765008558")! as NSURL
        UIApplication.shared.open( url as URL, options: [:], completionHandler: nil)
    }
    @IBAction func whatsApp(_ sender: UIButton) {
        if let url = URL(string: "https://api.whatsapp.com/send?phone=+77765008558") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
     
//        UIApplication.shared.openURL(URL(string:"https://api.whatsapp.com/send?phone=+77765008558")!)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
