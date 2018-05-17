//
//  OrdersVC.swift
//  TairPriceClick
//
//  Created by Adibek on 03.05.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit

class OrdersVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    var orders = [MainOrders]()
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let key = UserDefaults.standard.string(forKey: "authKey"){
            let json = ["auth_key" : key] as [String : AnyObject]
            self.getOrders(params: json, completionHandler: { ords in
                self.orders = ords
                self.tableView.reloadData()
            })
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Заказы"
    }


    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTVC
        if let date = orders[indexPath.row].createdDate{
            cell.dateLabel.text = date
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = orders[indexPath.row].id{
            self.id = id
            performSegue(withIdentifier: "toOrderDetail", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOrderDetail"{
            let det: OrderDetailVC = segue.destination as! OrderDetailVC
            det.id = self.id
        }
    }
}
class OrderTVC: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
}
