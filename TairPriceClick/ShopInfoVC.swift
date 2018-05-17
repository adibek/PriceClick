//
//  ShopInfoVC.swift
//  AKMaskField
//
//  Created by Adibek on 02.05.2018.
//

import UIKit

class ShopInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var info: Shops?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = info?.shopName{
            self.title = name
        }else{
            self.title = "Информация"
        }
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShopInfoTVC
        let i = indexPath.row
        switch i {
        case 0:
            cell.infoLabel.text = "Минимальная сумма заказа"
            if let min = info?.shopMinPrice{
                cell.valueLabel.text = min
            }
        case 1:
            
            cell.infoLabel.text = "Условия доставки"
            if let min = info?.shopDelivery{
                cell.valueLabel.text = min
            }
        case 2:
            cell.infoLabel.text = "Прочие условия"
            var text = ""
            if let min = info?.modeOrder{
                text += "Прием заказов " + min + "\n"
            }
            if let min = info?.shopReturn{
                text += min
            }
            cell.valueLabel.text = text
            
        case 3:
            cell.infoLabel.text = "О магазине"
            if let min = info?.shopDescription{
                cell.valueLabel.text = "\(min)"
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell2"){
                return cell
            }
            
        }
        return cell
    }
    @IBOutlet weak var tableView: UITableView!
    
}
class ShopInfoTVC: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
}
