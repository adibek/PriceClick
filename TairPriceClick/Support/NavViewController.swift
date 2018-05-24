//
//  NavViewController.swift
//  TairPriceClick
//
//  Created by Adibek on 21.05.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.tintColor = #colorLiteral(red: 0.1084294441, green: 0.1084294441, blue: 0.1084294441, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
