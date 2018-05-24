//
//  TabController.swift
//  TairPriceClick
//
//  Created by Adibek on 28.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

    

    override func viewWillAppear(_ animated: Bool) {
        var vcs = self.viewControllers
        if vcs!.count > 5{
            if let _ = UserDefaults.standard.string(forKey: "authKey"){
                vcs?.remove(at: 3)
            }else{
                vcs?.remove(at: 4)
            }
            
        }
        
        
        
        self.setViewControllers(vcs!, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent

    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var vcs = self.viewControllers
//
//        vcs?.remove(at: 4)
//        self.setViewControllers(vcs!, animated: true)
//
        // Do any additional setup after loading the view.
//
//        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let controller1 = storyBoard.instantiateViewController(withIdentifier: "1") as! NavigationViewController
//        let controller2 = storyBoard.instantiateViewController(withIdentifier: "2") as! NavigationViewController
//        let controller3 = storyBoard.instantiateViewController(withIdentifier: "3") as! NavigationViewController
//        var controller4 = UINavigationController()
//        if let _ = UserDefaults.standard.string(forKey: "authkey"){
//            controller4 = storyBoard.instantiateViewController(withIdentifier: "5") as! NavigationViewController
//        }else{
//            controller4 = storyBoard.instantiateViewController(withIdentifier: "4") as! NavigationViewController
//        }
//
//        controllerArray.append(controller1)
//        controllerArray.append(controller2)
//        controllerArray.append(controller3)
//        controllerArray.append(controller4)
//        self.setViewControllers(controllerArray, animated: true)
        
    }
    
    
    

}
