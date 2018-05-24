//
//  BasketVC.swift
//  TairPriceClick
//
//  Created by Adibek on 25.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class BasketVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let realm = try? Realm()
    var goods = [ProductItem]()
    var widths = CGFloat()
    var heights = CGFloat()
    var shopInfo = [ShopInfo]()
    var goodForSegue = Good()
    
    @IBOutlet weak var orderButton: UIButton!{
        didSet{
            orderButton.layer.cornerRadius = 4
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        makePage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.backgroundImage()
        widths = UIScreen.main.bounds.size.width * 0.495
        heights = self.widths * 1.68
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func clearBasket(_ sender: Any) {
        if goods.count > 0{
            let refreshAlert = UIAlertController(title: "Внимание", message: "Вы точно уверены, что хотите удалить все товары из корзины? Очистить корзину?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
                let realm = try? Realm()
                let res = realm?.objects(ProductItem.self)
                try? realm?.write {
                    realm?.delete(res!)
                    self.makePage()
                }
                if let tabItems = self.tabBarController?.tabBar.items as NSArray!
                {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[2] as! UITabBarItem
                    let realm = try? Realm()
                    let result = realm?.objects(ProductItem.self).count
                    if result != 0{
                        tabItem.badgeValue = "\(result!)"
                    }else{
                        tabItem.badgeValue = nil
                    }
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            


        }else{
            self.showAlert(title: "Внимание", message: "Ваша корзина товаров пуста")
        }
        
    }
    
    @IBAction func makeOrder(_ sender: Any) {
        if goods.count > 0{
            self.getShopInfo(shopId: goods[0].shopId, completionHandler: { info in
                if let min = info[0].shopMinPrice{
                    if let sum = Int(min){
                        var summa = 0
                        for item in self.goods{
                            summa += item.count * Int(item.price)!
                        }
                        if summa < sum{
                            let xx = sum.formattedWithSeparator
                            let refreshAlert = UIAlertController(title: "Внимание", message: "Недостаточная сумма для совершения заказа. Минимальная сумма заказа в \(self.goods[0].shopName) - \(xx) тг. \nЖелаете перейти в магазин и продолжить шоппинг?", preferredStyle: UIAlertControllerStyle.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
                                self.myTitle = info[0].shopName!
                                self.shopId = info[0].shopId!
                                self.performSegue(withIdentifier: "toProductsShop", sender: self)
                            }))
                            
                            refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (action: UIAlertAction!) in
                                
                            }))
                            
                            self.present(refreshAlert, animated: true, completion: nil)
                            
                        }else{
                            if let _ = UserDefaults.standard.string(forKey: "authKey"){
                                self.performSegue(withIdentifier: "toPay", sender: self)
                            }else{
                                self.performSegue(withIdentifier: "toAuth", sender: nil)
                            }
                        }
                    }
                }
            })
        }else{
            self.showAlert(title: "Внимание", message: "Ваша корзина товаров пуста")
        }
    }
    
    func makePage(){
        if let result = realm?.objects(ProductItem.self){
            goods = Array(result)
        }
        
        var sum = 0
        for item in goods{
            sum += item.count * Int(item.price)!
        }
        let xx = sum.formattedWithSeparator
        self.orderButton.setTitle("ОФОРМИТЬ ЗАКАЗ: \(xx) тг.", for: .normal)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! basketCvc
        let i = indexPath.row
        cell.nameLabel.text = goods[i].name
        cell.countLabel.text = "\(goods[i].count)"
        for i in goods[i].params{
            if i.name == "Цвет"{
                cell.itemColor.backgroundColor = hexStringToUIColor(hex: i.value)
                cell.itemColor.layer.borderWidth = 0.3
            }
            if i.name == "размер" || i.name == "Размер"{
                cell.itemSize.text = i.value
            }
        }
        
        let image = goods[i].mainImage
        let url = URL(string: "http://priceclick.kz/profile/uploads/products/min/" + image)
        cell.itemImage.sd_setImage(with: url, completed: nil)
        if let x = Int(goods[i].price){
            let xx = x.formattedWithSeparator
            cell.priceLabel.text = "\(xx) тг."
        }
//        cell.priceLabel.text = goods[i].price + " тг."
        cell.plusButton.addTarget(self, action: #selector(plus(_:)), for: .touchUpInside)
        cell.plusButton.tag = indexPath.row
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: #selector(minus(_:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fromBasket = true
        self.goodForSegue = self.makeGoodFromProduct(productItem: self.goods[indexPath.row])!
        self.performSegue(withIdentifier: "toGoodFromBasket", sender: self)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widths, height: heights)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    @objc func plus(_ sender: AnyObject) {
        let tag = sender.tag!
        let ip = IndexPath(row: tag, section: 0)
        let cell = collectionView.cellForItem(at: ip) as! basketCvc
        
        let realm = try? Realm()
        try? realm?.write {
            goods[tag].count += 1
        }
        let result = realm?.objects(ProductItem.self)
        goods = Array(result!)
        var sum = 0
        for item in goods{
            sum += item.count * Int(item.price)!
        }
        let xx = sum.formattedWithSeparator
        self.orderButton.setTitle("ОФОРМИТЬ ЗАКАЗ: \(xx) тг.", for: .normal)
        
        cell.countLabel.text = "\(Int(cell.countLabel.text!)! + 1)"
        
    }
    @objc func minus(_ sender: AnyObject) {
        let tag = sender.tag!
        let ip = IndexPath(row: tag, section: 0)
        let cell = collectionView.cellForItem(at: ip) as! basketCvc
        
        let realm = try? Realm()
        if goods[tag].count < 2{
            let refreshAlert = UIAlertController(title: "Внимание", message: "Вы уверены, что хотите удалить \(goods[tag].name) из корзины?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                let realm = try? Realm()
                try? realm?.write {
                    realm?.delete(self.goods[tag])
                    if let tabItems = self.tabBarController?.tabBar.items as NSArray!
                    {
                        // In this case we want to modify the badge number of the third tab:
                        let tabItem = tabItems[2] as! UITabBarItem
                        let realm = try? Realm()
                        let result = realm?.objects(ProductItem.self).count
                        if result != 0{
                            tabItem.badgeValue = "\(result!)"
                        }else{
                            tabItem.badgeValue = nil
                        }
                    }
                    self.makePage()
                }
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }else{
            try? realm?.write {
                goods[tag].count -= 1
                cell.countLabel.text = "\(Int(cell.countLabel.text!)! - 1)"
                let result = realm?.objects(ProductItem.self)
                goods = Array(result!)
                var sum = 0
                for item in goods{
                    sum += item.count * Int(item.price)!
                }
                let xx = sum.formattedWithSeparator
                self.orderButton.setTitle("ОФОРМИТЬ ЗАКАЗ: \(xx) тг.", for: .normal)
            }
        }
        
        
        
    }
    
    var shopId = ""
    var myTitle = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProductsShop"{
            let prodList: ProductsListVC = segue.destination as! ProductsListVC
            prodList.type = 1
            prodList.shopId = shopId
            prodList.title = myTitle
        }else if segue.identifier == "toGoodFromBasket"{
            let prod: ProductVC = segue.destination as! ProductVC
            prod.good = self.goodForSegue
        }
    }
}

class basketCvc: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemColor: UILabel!{
        didSet{
            itemColor.layer.cornerRadius = itemColor.frame.height / 2
            itemColor.layer.masksToBounds = true
            itemColor.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet var borderView: UIView!{
        didSet{
            borderView.layer.borderWidth = 0.5
            borderView.layer.borderColor = UIColor.black.cgColor
            borderView.layer.cornerRadius = borderView.frame.height / 2
            borderView.layer.masksToBounds = true
        }
    }
    @IBOutlet var view1H: NSLayoutConstraint!
    @IBOutlet var view2H: NSLayoutConstraint!
    @IBOutlet var view3H: NSLayoutConstraint!
    
    
}
extension UIViewController{
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func makeGoodFromProduct(productItem: ProductItem) -> Good?{
        let good = Good()
        good.params = productItem.params
        good.id = productItem.id
        good.name = productItem.name
        good.count = productItem.count
        good.mainImage = productItem.mainImage
        good.price = productItem.price
        good.descriptionField = productItem.descriptionField
        good.rating = productItem.rating
        
        return good
    }
}
