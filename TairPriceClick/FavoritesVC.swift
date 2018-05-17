//
//  FavoritesVC.swift
//  TairPriceClick
//
//  Created by Adibek on 20.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import RealmSwift

class FavoritesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    
    var byShops = false
    var good: Results<Good>? = nil
    var goods = [Good]()
    var myShops = [Shop]()
    var goodForSegue: Good?
    var shopForSegue: Shop?
    var idForSegue = ""
    let realm = try! Realm()
    var widths = CGFloat()
    var heights = CGFloat()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        widths = UIScreen.main.bounds.size.width * 0.495
        heights = self.widths * 1.5
        self.backgroundImage()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
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
        navigationController?.navigationBar.isTranslucent = false
        good = realm.objects(Good.self)
        goods = Array(good!)
        let result = realm.objects(Shop.self)
        self.myShops = Array(result)
        collectionView.reloadData()
        
        
    }
    @IBOutlet weak var byGoodsButton: UIButton!{
        didSet{
            byGoodsButton.setTitleColor(#colorLiteral(red: 0.003921568627, green: 0.9921568627, blue: 1, alpha: 1), for: .normal)
        }
    }
    @IBOutlet weak var byShopsButton: UIButton!{
        didSet{
            byShopsButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func byGoods(_ sender: Any) {
        byShops = false
        byShopsButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        byGoodsButton.setTitleColor(#colorLiteral(red: 0.003921568627, green: 0.9921568627, blue: 1, alpha: 1), for: .normal)
        widths = UIScreen.main.bounds.size.width * 0.495
        heights = self.widths * 1.5
        self.collectionView.reloadData()
    }
    @IBAction func byShops(_ sender: Any) {
        byShops = true
        widths = UIScreen.main.bounds.size.width
        heights = 180
        byGoodsButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        byShopsButton.setTitleColor(#colorLiteral(red: 0.003921568627, green: 0.9921568627, blue: 1, alpha: 1), for: .normal)
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.byShops == false{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! SecondSegmentCVC
            let i = indexPath.row
            
            let url = URL(string: "http://priceclick.kz/profile/uploads/products/min/" + goods[i].mainImage)
            cell.favButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
            cell.productImg.sd_setImage(with: url, completed: nil)
            cell.productPrice.text = goods[i].price + "тг."
            cell.productName.text = goods[i].name
            cell.favButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
            cell.backFavButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
            cell.favButton.tag = indexPath.row
            cell.backFavButton.tag = indexPath.row
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! FirstSegmentCVC
            let i = indexPath.row
            let url = URL(string: "http://priceclick.kz/profile/uploads/shops/" + myShops[i].mainImage)
            cell.shopImg.sd_setImage(with: url, completed: nil)
            cell.shopLabel.text = myShops[i].name
            cell.shopDesc.text = myShops[i].descriptionField
            cell.ratingLabel.text = myShops[i].rating
            cell.heartButton.tag = i
            cell.backFavButton.tag = i
            cell.heartButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
            cell.heartButton.addTarget(self, action: #selector(updateFavShop(_:)), for: .touchUpInside)
            cell.backFavButton.addTarget(self, action: #selector(updateFavShop(_:)), for: .touchUpInside)
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if byShops{
            return self.myShops.count
        }else{
            return goods.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if byShops == false{
            self.goodForSegue = goods[indexPath.row]
            self.performSegue(withIdentifier: "toCurrentProduct", sender: self)
        }else{
            idForSegue = myShops[indexPath.row].id
            self.performSegue(withIdentifier: "toFavShopProducts", sender: self)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widths, height: heights)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    @objc func updateFav(_ sender: AnyObject) {
        let tag = sender.tag!
        let ip = IndexPath(row: tag, section: 0)
        let cell = collectionView.cellForItem(at: ip) as! SecondSegmentCVC
        
        let realm = try! Realm()
        let id = goods[tag].id
        let result = realm.objects(Good.self).filter("id == '\(id)'")
        if result.isEmpty{
            cell.favButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
            
            try! realm.write {
                realm.add(goods[tag])
            }
        }
        else{
            var text = ""
            if byShops{
                text = "Вы уверенны что хотите удалить магазин из избранного?"
            }else{
                text = "Вы уверенны что хотите удалить товар из избранного?"
            }
            let refreshAlert = UIAlertController(title: "Внимание", message: text, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
                cell.favButton.setImage(#imageLiteral(resourceName: "favTab2"), for: .normal)
                try! realm.write {
//                    self.goods.remove(at: tag)
//                    self.collectionView.reloadData()
                    realm.delete(result)
                    self.good = realm.objects(Good.self)
                    self.goods = Array(self.good!)
                    let result = realm.objects(Shop.self)
                    self.myShops = Array(result)
                    self.collectionView.reloadData()
                    
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @objc func updateFavShop(_ sender: AnyObject) {
        let tag = sender.tag!
        let ip = IndexPath(row: tag, section: 0)
        let cell = collectionView.cellForItem(at: ip) as! FirstSegmentCVC
        
        let realm = try! Realm()
        let id = myShops[tag].id
        let result = realm.objects(Shop.self).filter("id == '\(id)'")
        if result.isEmpty{
            cell.heartButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
            
            try! realm.write {
                realm.add(myShops[tag])
            }
        }
        else{
            var text = ""
            if byShops{
                text = "Вы уверенны, что хотите удалить магазин из избранного?"
            }else{
                text = "Вы уверенны, что хотите удалить товар из избранного?"
            }
            let refreshAlert = UIAlertController(title: "Внимание", message: text, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
                cell.heartButton.setImage(#imageLiteral(resourceName: "favTab2"), for: .normal)
                try! realm.write {
//                    self.goods.remove(at: tag)
//                    self.collectionView.reloadData()
                    realm.delete(result)
                    self.good = realm.objects(Good.self)
                    self.goods = Array(self.good!)
                    let result = realm.objects(Shop.self)
                    self.myShops = Array(result)
                    self.collectionView.reloadData()
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
           
        }
    }
    
    // segue        toCurrentProduct
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCurrentProduct"{
            let prod: ProductVC = segue.destination as! ProductVC
            prod.good = goodForSegue
        }else if segue.identifier == "toFavShopProducts"{
            let shop: ProductsListVC = segue.destination as! ProductsListVC
            shop.type = 1
            shop.shopId = idForSegue
        }
    }
}

class FirstSegmentCVC: UICollectionViewCell {
    @IBOutlet var shopImg: UIImageView!
    @IBOutlet var shopLabel: UILabel!
    @IBOutlet var shopDesc: UILabel!
    @IBOutlet var rating: CosmosView!
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var fastLabel: UILabel!
    @IBOutlet var backFavButton: UIButton!{
        didSet{
            backFavButton.layer.cornerRadius = backFavButton.frame.size.height / 2
        }
    }
    @IBOutlet var imgWidth: NSLayoutConstraint!
    
}
class SecondSegmentCVC: UICollectionViewCell {
    @IBOutlet var productImg: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var favButton: UIButton!
    @IBOutlet var backFavButton: UIButton!{
        didSet{
            backFavButton.layer.cornerRadius = backFavButton.frame.size.height / 2
        }
    }
    @IBOutlet var viewHeight: NSLayoutConstraint!
    @IBOutlet var viewHeight1: NSLayoutConstraint!
    
}


