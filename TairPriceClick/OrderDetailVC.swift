//
//  OrderDetailVC.swift
//  TairPriceClick
//
//  Created by Adibek on 03.05.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import SDWebImage

class OrderDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var id = String()
    var detail = [OrderDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let key = UserDefaults.standard.string(forKey: "authKey"){
            let json = ["auth_key" : key, "order_group_id" : id] as [String : AnyObject]
            self.getOrderData(params: json, completionHandler: { info in
                self.detail = info
                self.tableView.reloadData()
            })
            
        }
        self.title = "Заказ"
    }

    @IBOutlet weak var tableView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detail.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyShopCVC
        let i = indexPath.row
        if let image = detail[i].productMainImg{
            let url = URL(string: "http://priceclick.kz/profile/uploads/products/min/" + image)
            cell.image.sd_setImage(with: url, completed: nil)
        }
        if let amount = detail[i].productCount{
            cell.countOfProduct.text = amount
        }
        if let sum = detail[i].productPrice{
            cell.priceLabel.text = sum + "тг."
            if let int = Int(detail[i].productPrice!){
                cell.summLabel.text = "\(int * Int(detail[i].productCount!)!) тг."
            }
        }
        if let name = detail[i].productName{
            cell.prodName.text = name
        }
        if let name = detail[i].shopName{
            cell.shopButton.setTitle(name, for: .normal)
        }
        return cell
    }
    
}

class MyShopCVC: UICollectionViewCell {
    @IBOutlet weak var h1: NSLayoutConstraint!{
        didSet{
            h1.constant = 0.4
        }
    }
    @IBOutlet weak var h2: NSLayoutConstraint!{
        didSet{
            h2.constant = 0.4
        }
    }
    @IBOutlet weak var h3: NSLayoutConstraint!{
        didSet{
            h3.constant = 0.4
        }
    }
    @IBOutlet weak var h4: NSLayoutConstraint!{
        didSet{
            h4.constant = 0.4
        }
    }
    @IBOutlet weak var h5: NSLayoutConstraint!{
        didSet{
            h5.constant = 0.4
        }
    }
    @IBOutlet weak var h6: NSLayoutConstraint!{
        didSet{
            h6.constant = 0.4
        }
    }
    @IBOutlet weak var w1: NSLayoutConstraint!{
        didSet{
            w1.constant = 0.2
        }
    }
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var prodName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet var countOfProduct: UILabel!
    @IBOutlet var summLabel: UILabel!
}
