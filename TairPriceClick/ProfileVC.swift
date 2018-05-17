//
//  ProfileVC.swift
//  TairPriceClick
//
//  Created by Adibek on 03.05.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTVC
        if indexPath.row == 0{
            cell.label.text = "Мой профиль"
            cell.image1.image = #imageLiteral(resourceName: "profile3")
            return cell
        }else{
            cell.label.text = "Мои заказы"
            cell.image1.image = #imageLiteral(resourceName: "my orders black")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "toProf", sender: self)
        }else{
            performSegue(withIdentifier: "toOrders", sender: self)
        }
    }
    
    
}
