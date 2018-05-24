//
//  ProductsListVC.swift
//  TairPriceClick
//
//  Created by Adibek on 19.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import RealmSwift
import FSPagerView
import Instructions
var showName = Bool()

class ProductsListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CoachMarksControllerDataSource, CoachMarksControllerDelegate, UISearchBarDelegate  {

    var width = CGFloat()
    var height = CGFloat()
    var type = 0
    var secId = "0"
    var shopId = "0"
    var subSecId = "0"
    var thisShop: Shops?
    var widths = CGFloat()
    var heights = CGFloat()
    var products = [Product]()
    var selectedProduct: Product?
    var good: Results<Good>? = nil
    var goods = [Good]()
    var grayButton = UIButton()
    let coachMarksController = CoachMarksController()
    var korzina = [ProductItem]()
    var isEncrease = false
    var mode = 0
    var scroll = false
    var query = [String : AnyObject]()
    
    
    @objc func update() {
        UIView.animate(withDuration: 0.6, animations: {
            self.grayButton.setTitle("", for: .normal)
            self.grayButton.frame = CGRect(x: 8, y: self.backView.frame.origin.y, width: self.backView.frame.size.width, height: self.backView.frame.size.height)
            
        }, completion: { (finished: Bool) in
            self.grayButton.isHidden = true
            self.backView.isHidden = false
            self.backView.shake()
            var count = UserDefaults.standard.integer(forKey: "count")
            count += 1
            UserDefaults.standard.set(count, forKey: "count")
            
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        width = (UIScreen.main.bounds.size.width - 3) *  0.5
        
        if type == 0{
            height = self.width *  1.7
        }else{
            height = self.width *  1.4783123  
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        hideKeyboardWhenTappedAround()
        self.backgroundImage()

    }
    override func viewWillAppear(_ animated: Bool) {
        scroll = false
        if isSearch{
            self.startLoading()
            self.title = "Результаты поиска"
            self.infoButton.image = nil
            self.infoButton.isEnabled = false
            self.searchProduct(parameters: query as [String : AnyObject], completionHandler: { goods in
                self.products = goods
                self.collectionView.reloadData()
                if self.products.count < 1{
                    self.showAlert(title: "Внимание", message: "К сожалению, запрашиваемых товаров пока что нет в наличии. Повторите попытку позже.")
                    self.stopLoading()
                }
            })
            
        }else{
            makePage()
        }
        
        if UserDefaults.standard.bool(forKey: "arrowShown"){
            if UserDefaults.standard.integer(forKey: "count") < 2{
                self.backView.isHidden = true
                self.grayButton.setTitle("ВЫБЕРИТЕ РАЗДЕЛ", for: .normal)
                self.grayButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                self.grayButton.layer.cornerRadius = 30
                var y: CGFloat = 0
                if width < 375{
                    y = self.backView.frame.origin.y - 90
                }else{
                    y = self.backView.frame.origin.y
                }
                self.grayButton.frame = CGRect(x: 8, y: y, width: UIScreen.main.bounds.size.width - 16, height: self.backView.frame.size.height)
                view.addSubview(grayButton)
                var _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
                
            }else{
                self.backView.shake()
            }
            
        }else{
            self.coachMarksController.dataSource = self
            self.coachMarksController.start(on: self)
            
        }

        let realm = try? Realm()
        if let result = realm?.objects(ProductItem.self){
            korzina = Array(result)
        }
        
        
        if let realm = realm{
            good = realm.objects(Good.self)
            self.goods = Array(good!)
            print("goods count", goods.count)
        }
        navigationController?.navigationBar.isTranslucent = false

        
    }
    func makePage(){
        priceImageView.image = nil
        
        var txt = ""
        if let cityId = UserDefaults.standard.string(forKey: "cityId"){
            var url = ""
            if type == 0{
                self.infoButton.image = nil
                showName = true
                self.title = "По товарам"
                url = "http://api.priceclick.kz/api/products/section?city_id=\(cityId)&section_id=\(secId)"
                txt = "На данный момент в этой категории товары отсутствуют"
            }else if type == 1{
                showName = false
                self.infoButton.image = #imageLiteral(resourceName: "info_icon1")
                self.title = "Товары"
                url = "http://api.priceclick.kz/api/products/shop?city_id=\(cityId)&shop_id=\(shopId)"
                txt = "На данный момент в этом магазине товары отсутствуют"
            }else if type == 2{
                //self.title = "Товары"
                if shopId != "0"{
                    self.infoButton.image = #imageLiteral(resourceName: "info_icon1")
                    showName = false
                    txt = "На данный момент в этом магазине товары отсутствуют"
                    url = "http://api.priceclick.kz/api/products/shop-subcategory?shop_id=\(shopId)&city_id=\(cityId)&subcategory_id=\(subSecId)"
                }else{
                    url = "http://api.priceclick.kz/api/products/subcategory-products?subcategory_id=\(subSecId)&city_id=\(cityId)"
                    txt = "На данный момент в этой категории товары отсутствуют"
                    self.infoButton.image = nil
                    showName = true
                }
                
            }
            self.getProducts(url: url, completionHandler: { goods in
                self.products = goods
                if self.products.isEmpty{
                    self.showAlert(title: "Внимание", message: txt)
                }
                self.collectionView.reloadData()
            })
            if let name = thisShop?.shopName{
                self.title = name
            }
        }
        
    }
    

    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var backChangeButton: UIButton!{
        didSet{
            backChangeButton.layer.cornerRadius = backChangeButton.frame.height / 2
            backChangeButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var priceImageView: UIImageView!
    @IBOutlet weak var byTopButton: UIButton!

    @IBOutlet weak var byPriceButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.layer.cornerRadius = backView.frame.size.height / 2
        }
    }
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func byTop(_ sender: Any) {
        
        priceImageView.image = nil
        
        for i in 0..<products.count{
            for j in 0..<products.count{
                if let i_top = products[i].productRating, let j_top = products[i].productRating{
                    if let itop = Int(i_top), let jtop = Int(j_top){
                        if itop > jtop{
                            swap(&products[i], &products[j])
                        }
                    }
                }
                
            }
        }
        byTopButton.setTitleColor(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), for: .normal)
        byPriceButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
    }
    @IBAction func byPrice(_ sender: Any) {
        if isEncrease{
            priceImageView.image =  #imageLiteral(resourceName: "111 голубой 1")
            for i in 0..<products.count{
                for j in 0..<products.count{
                    if Int(products[i].productPrice!)! > Int(products[j].productPrice!)!{
                        swap(&products[i], &products[j])
                    }
                }
            }
            byTopButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            byPriceButton.setTitleColor(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), for: .normal)
        }else{
            priceImageView.image = #imageLiteral(resourceName: "111 голубой 2")
            for i in 0..<products.count{
                for j in 0..<products.count{
                    if Int(products[i].productPrice!)! < Int(products[j].productPrice!)!{
                        swap(&products[i], &products[j])
                    }
                }
            }
            byTopButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            byPriceButton.setTitleColor(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), for: .normal)
        }
        isEncrease = !isEncrease
        self.collectionView.reloadData()
    }
    
    @IBAction func openCategory(_ sender: Any) {
        performSegue(withIdentifier: "toCategory", sender: self)
    }
    @IBAction func toInfo(_ sender: Any) {
        self.performSegue(withIdentifier: "toShopInfo", sender: self)
    }
    
    @IBAction func changeButton(_ sender: Any) {
        if mode == 0{
            self.changeButton.setImage(UIImage(named: "333"), for: .normal)
            mode = 1
            self.collectionView.reloadData()
        }else if mode == 1{
            self.changeButton.setImage(UIImage(named: "444"), for: .normal)
            mode = 2
            self.collectionView.reloadData()
        }else{
            self.changeButton.setImage(UIImage(named: "222"), for: .normal)
            mode = 0
            self.collectionView.reloadData()
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let i = indexPath.row
        
        if type == 0{
            var identifier = "cell1"
            if mode == 1{
                identifier = "cell3"
            }else if mode == 2{
                let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell4", for: indexPath) as! ThirdCellWithButton
                if let name = products[i].productName{
                    cell4.nameLabel.text = name
                }
                if let images = products[i].productImgs{
                    cell4.images = images
                    cell4.pagerView.reloadData()
                }
                if let rating = products[i].productRating{
                    cell4.ratingLabel.text = rating
                }
                if let price = products[i].productPrice{
                    if let x = Int(price){
                        let xx = x.formattedWithSeparator
                        cell4.priceLabel.text = "\(xx) тг."
                    }
                    
                }
                for good in goods{
                    if good.id == products[i].id!{
                        cell4.favButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
                        break
                    }else{
                        cell4.favButton.setImage(#imageLiteral(resourceName: "favTab2"), for: .normal)
                    }
                }
                cell4.favButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
                cell4.backFavButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
                cell4.toShopButton.addTarget(self, action: #selector(openShop(_:)), for: .touchUpInside)
                cell4.toShopButton.tag = i
                return cell4
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! cvc
            if let image = products[i].productMainImg{
                let url = URL(string: "http://priceclick.kz/profile/uploads/products/min/" + image)
                cell.accImage.sd_setImage(with: url, completed: nil)
            }
            for good in goods{
                if good.id == products[i].id!{
                    cell.favButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
                    break
                }else{
                    cell.favButton.setImage(#imageLiteral(resourceName: "favTab2"), for: .normal)
                }
            }
            if let rating = products[i].productRating{
                if identifier == "cell3"{
                    cell.ratingLabel.text = rating
                }
            }
            if let desc = products[i].productDescription{
                if identifier == "cell3"{
                    cell.descriptionLabel.text = desc
                }
            }
            cell.favButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
            cell.backFavButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
            
            cell.favButton.tag = indexPath.row
            cell.backFavButton.tag = indexPath.row
            if let price = products[i].productPrice{
                if let x = Int(price){
                    let xx = x.formattedWithSeparator
                    cell.priceLabel.text = "\(xx) тг."
                }
            }
            if let name = products[i].productName{
                cell.nameLabel.text = name
            }
            cell.toShopButton.addTarget(self, action: #selector(self.openShop(_:)), for: .touchUpInside)
            cell.toShopButton.tag = i
            return cell
            
        }else{
            var identifier = "cell"
            if mode == 1{
                identifier = "cell2"
            }else if mode == 2{
                let cell5 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell5", for: indexPath) as! ThirdCellWithButton
                if let name = products[i].productName{
                    cell5.nameLabel.text = name
                }
                if let images = products[i].productImgs{
                    cell5.images = images
                    cell5.pagerView.reloadData()
                }
                if let rating = products[i].productRating{
                    cell5.ratingLabel.text = rating
                }
                if let price = products[i].productPrice{
                    if let price = products[i].productPrice{
                        if let x = Int(price){
                            let xx = x.formattedWithSeparator
                            cell5.priceLabel.text = "\(xx) тг."
                        }
                        
                    }

                    
                }
                cell5.favButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
                cell5.backFavButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
                
                var count = 0
                
                for item in korzina{
                    if item.id == products[i].id!{
                        count += item.count
                    }
                }
                cell5.countLabel.text = "\(count)"
                cell5.plusButton.tag = indexPath.row
                cell5.plusButton.addTarget(self, action: #selector(plus(_:)), for: .touchUpInside)
                cell5.minusButton.tag = indexPath.row
                cell5.minusButton.addTarget(self, action: #selector(minus(_:)), for: .touchUpInside)
                cell5.plusButton.layer.cornerRadius = 5
                cell5.minusButton.layer.cornerRadius = 5
                cell5.circleView.layer.cornerRadius = 12.5
                cell5.circleView.layer.borderWidth = 1
                for good in goods{
                    if good.id == products[i].id!{
                        cell5.favButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
                        break
                    }else{
                        cell5.favButton.setImage(#imageLiteral(resourceName: "favTab2"), for: .normal)
                    }
                }
                return cell5
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! shopCvc
            
            var count = 0
            
            if let desc = products[i].productDescription{
                if identifier == "cell2"{
                    cell.descriptionLabel.text = desc
                    if let rat = products[i].productRating{
                        cell.ratingLabel.text = rat
                    }
                }
            }
            for item in korzina{
                if item.id == products[i].id!{
                    count += item.count
                }
            }
            cell.countLabel.text = "\(count)"
            
            if let image = products[i].productMainImg{
                let url = URL(string: "http://priceclick.kz/profile/uploads/products/min/" + image)
                cell.itemImage.sd_setImage(with: url, completed: nil)
            }
            for good in goods{
                if good.id == products[i].id!{
                    cell.favButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
                    break
                }else{
                    cell.favButton.setImage(UIImage(named: "newHeart"), for: .normal)
                }
            }
            cell.favButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
            cell.backFavButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
            
            cell.favButton.tag = indexPath.row
            cell.backFavButton.tag = indexPath.row
            if let price = products[i].productPrice{
                if let x = Int(price){
                    let xx = x.formattedWithSeparator
                    cell.priceLabel.text = "\(xx) тг."
                }
            }
            if let name = products[i].productName{
                cell.nameLabel.text = name
            }
            
            cell.plusButton.tag = indexPath.row
            cell.plusButton.addTarget(self, action: #selector(plus(_:)), for: .touchUpInside)
            cell.minusButton.tag = indexPath.row
            cell.minusButton.addTarget(self, action: #selector(minus(_:)), for: .touchUpInside)
            cell.plusButton.layer.cornerRadius = 5
            cell.minusButton.layer.cornerRadius = 5
            cell.borderView.layer.cornerRadius = 12.5
            cell.borderView.layer.borderWidth = 1
            cell.itemImage.layer.borderColor = UIColor.lightGray.cgColor
            if mode == 0{
                cell.viewHeigtConst.constant = 0.5
                cell.view1HeightConst.constant = 0.5
            }
            
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if type == 0{
//            if let cityId = UserDefaults.standard.string(forKey: "cityId"){
//                self.shopId = products[indexPath.row].shopId!
//                let url = "http://api.priceclick.kz/api/products/shop?city_id=\(cityId)&shop_id=\(products[indexPath.row].shopId!)"
//                self.getProducts(url: url, completionHandler: { goods in
//                    self.products = goods
//                    self.type = 1
//                    if let title = self.products[indexPath.row].shopName{
//                        self.title = title as! String
//                        self.infoButton.image = #imageLiteral(resourceName: "info_icon1")
//                        self.infoButton.isEnabled = true
//                    }else{
//                        self.title = "Товары"
//                    }
//                    self.collectionView.reloadData()
//                })
//
//            }
//        }else{
            self.selectedProduct = self.products[indexPath.row]
            self.performSegue(withIdentifier: "toItem", sender: self)
//        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let modeOneWidth = UIScreen.main.bounds.size.width
        let modeOneHieght = modeOneWidth / 2
        if mode == 0{
            return CGSize(width: width, height: height)
        }else if mode == 1{
            return CGSize(width: modeOneWidth, height: modeOneHieght)
        }else{
            if type == 0{
                return CGSize(width: modeOneWidth, height: modeOneWidth / 0.75)
            }else{
                return CGSize(width: modeOneWidth, height: modeOneWidth / 0.75)
            }
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategory"{
            let cat: SubCategoriesVC = segue.destination as! SubCategoriesVC
            if shopId != "0"{
                cat.shopId = self.shopId
            }else{
                cat.secId = self.secId
            }
            cat.from = 1
            
        }else if segue.identifier == "toItem"{
            let product: ProductVC = segue.destination as! ProductVC
            product.product = selectedProduct
            product.scroll = scroll
        }else if segue.identifier == "toShopInfo"{
            let shopInfo: ShopInfoVC = segue.destination as! ShopInfoVC
            shopInfo.info = self.thisShop
        }
    }
    
    
    @objc func openShop(_ sender: AnyObject) {
        self.selectedProduct = self.products[sender.tag!]
        self.performSegue(withIdentifier: "toItem", sender: self)
        
        
//        let tag = sender.tag!
//        if let cityId = UserDefaults.standard.string(forKey: "cityId"){
//            self.shopId = products[tag].shopId!
//            let url = "http://api.priceclick.kz/api/products/shop?city_id=\(cityId)&shop_id=\(products[tag].shopId!)"
//            self.getProducts(url: url, completionHandler: { goods in
//                self.products = goods
//                self.type = 1
//                if let title = self.products[tag].shopName{
//                    self.title = title as! String
//                }else{
//                    self.title = "Товары"
//                }
//                self.collectionView.reloadData()
//
//
//            })
//
//        }
        
        
    }
    
    @objc func plus(_ sender: AnyObject) {
        
        let tag = sender.tag!

        
        let realm = try? Realm()
        
        let id = products[tag].shopId!
        let result = realm?.objects(ProductItem.self)
        if let count = result?.count{
            if count < 1{
                self.add(tag: tag)
            }else{
                let result = realm?.objects(ProductItem.self).filter("shopId == '\(id)'")
                if let count = result?.count{
                    if count > 0{
                        self.add(tag: tag)
                    }else{
                        let refreshAlert = UIAlertController(title: "Внимание", message: "В Вашей корзине находится неоформленный заказ с другого магазина. Оформить заказ сейчас или удалить его?", preferredStyle: UIAlertControllerStyle.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Оформить", style: .default, handler: { (action: UIAlertAction!) in
                            
                            self.tabBarController?.selectedIndex = 2
                        }))
                        
                        refreshAlert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { (action: UIAlertAction!) in
                            let realm = try? Realm()
                            let result = realm?.objects(ProductItem.self)
                            try? realm?.write {
                                realm?.delete(result!)
                            }
                            self.add(tag: tag)
                        }))
                        
                        present(refreshAlert, animated: true, completion: nil)
                    }
                }
                
            }
        }
        
        
    }

    @objc func minus(_ sender: AnyObject) {
        let tag = sender.tag!
        let ip = IndexPath(row: tag, section: 0)
        
        if let _ = products[tag].parameters, let _ = products[tag].colors{
            self.showAlert(title: "Внимание", message: "Для удаления этого товара из корзины, необходимо выбрать его параметры")
        }else{
            
            let realm = try? Realm()
            let result = realm?.objects(ProductItem.self).filter("id == '\(products[tag].id!)'")
            let array = Array(result!)
            var has = false
            for i in array{
                if i.id == products[tag].id!{
                    has = true
                    if i.count < 2{
                        try? realm?.write {
                            realm?.delete(i)
                        }
                    }else{
                        try? realm?.write {
                            i.count = i.count - 1
                        }
                    }
                    
                }
                break
            }

            if mode == 2{
                let cell = collectionView.cellForItem(at: ip) as! ThirdCellWithButton
                if Int(cell.countLabel.text!)! != 0{
                    cell.countLabel.text = "\(Int(cell.countLabel.text!)! - 1)"
                }
                
            }else{
                let cell = collectionView.cellForItem(at: ip) as! shopCvc
                if Int(cell.countLabel.text!)! != 0{
                    cell.countLabel.text = "\(Int(cell.countLabel.text!)! - 1)"
                }
                
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
        }
    }

    func add(tag: Int){

        if let _ = products[tag].parameters{
            openGood(tag: tag)
        }else{
            if let _ = products[tag].colors{
                openGood(tag: tag)
            }else{
                insertGood(tag: tag)
            }
        }
    }
    func openGood(tag: Int){
        let refreshAlert = UIAlertController(title: "Внимание", message: "Для добавления этого товара в корзину, необходимо выбрать его параметры", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OК", style: .default, handler: { (action: UIAlertAction!) in
            self.selectedProduct = self.products[tag]
            self.scroll = true
            self.performSegue(withIdentifier: "toItem", sender: self)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func insertGood(tag: Int){
        
        let ip = IndexPath(row: tag, section: 0)
        
        let realm = try? Realm()
        let result = realm?.objects(ProductItem.self).filter("id == '\(products[tag].id!)'")
        let array = Array(result!)
        var has = false
        for i in array{
            if i.id == products[tag].id!{
                has = true
                try? realm?.write {
                    i.count = i.count + 1
                }
            }
            break
        }
        
        if has == false{
            let item = ProductItem()
            item.id = products[tag].id!
            item.count = 1
            item.name = products[tag].productName!
            item.mainImage = products[tag].productMainImg!
            item.descriptionField = products[tag].productDescription!
            item.price = products[tag].productPrice!
            item.rating = products[tag].productRating!
            item.shopId = products[tag].shopId!
            item.shopName = products[tag].shopName as! String
            
            try? realm?.write {
                realm?.add(item)
            }
        }
        
        if mode == 2{
            let cell = collectionView.cellForItem(at: ip) as! ThirdCellWithButton
            cell.countLabel.text = "\(Int(cell.countLabel.text!)! + 1)"
        }else{
            let cell = collectionView.cellForItem(at: ip) as! shopCvc
            cell.countLabel.text = "\(Int(cell.countLabel.text!)! + 1)"
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
    }
    @objc func updateFav(_ sender: AnyObject) {
        let tag = sender.tag!
        let ip = IndexPath(row: tag, section: 0)
        
        
        
        let realm = try! Realm()
        let id = products[tag].id!
        let result = realm.objects(Good.self).filter("id == '\(id)'")
        if result.isEmpty{
            if mode == 0 || mode == 1{
                if type == 0{
                    let cell = collectionView.cellForItem(at: ip) as! cvc
                    cell.favButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
                }else{
                    let cell = collectionView.cellForItem(at: ip) as! shopCvc
                    cell.favButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
                }
            }else if mode == 2{
                if let cell = collectionView.cellForItem(at: ip) as? ThirdCellWithButton{
                    cell.favButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
                }
            }
            
            let good = self.createGoodObject(product: products[tag])
            try! realm.write {
                self.goods.append(good!)
                realm.add(good!)
            }
        }
        else{
            let refreshAlert = UIAlertController(title: "Внимание", message: "Вы уверенны, что хотите удалить товар из избранного?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
                if self.mode == 0 || self.mode == 1{
                    if self.type == 0{
                        let cell = self.collectionView.cellForItem(at: ip) as! cvc
                        cell.favButton.setImage(UIImage(named: "newHeart"), for: .normal)
                    }else{
                        let cell = self.collectionView.cellForItem(at: ip) as! shopCvc
                        cell.favButton.setImage(UIImage(named: "newHeart"), for: .normal)
                    }
                }else if self.mode == 2{
                    let cell = self.collectionView.cellForItem(at: ip) as! ThirdCellWithButton
                    cell.favButton.setImage(UIImage(named: "newHeart"), for: .normal)
                }
                
                try? realm.write {
                    var ind = 0
                    for i in 0..<self.goods.count{
                        if self.goods[i].id == id{
                            ind = i
                            break
                        }
                    }
                    self.goods.remove(at: ind)
                    realm.delete(result)
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    
    //MARK: Instructions
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: backView)
    }
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = "Вы можете выбрать раздел"
        coachViews.bodyView.nextLabel.text = "OK"
        
        if width < 375{
            coachViews.bodyView.hintLabel.font = coachViews.bodyView.hintLabel.font?.withSize(14)
        }else{
            coachViews.bodyView.hintLabel.font = coachViews.bodyView.hintLabel.font?.withSize(16)
        }
        
        UserDefaults.standard.set(true, forKey: "arrowShown")
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    //MARK: - Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.startLoading()
        self.products = self.filterContentForSearchText()
        self.collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.stopLoading()
            self.searchBar.endEditing(true)
        }
    }
    func filterContentForSearchText() -> [Product]{
        var strArray = [String]()
        for i in products{
            strArray.append(i.productName!)
        }
        let filterdItemsArray = strArray.filter { item in
            return item.lowercased().contains(self.searchBar.text!.lowercased())
        }
        var searcheditem = [Product]()
        for i in filterdItemsArray{
            for j in products{
                if i == j.productName!{
                    searcheditem.append(j)
                }
            }
        }
        return searcheditem
    }

    
}
class shopCvc: UICollectionViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var borderView: UIView!
    @IBOutlet var favButton: UIButton!
    @IBOutlet var backFavButton: UIButton!{
        didSet{
            backFavButton.layer.cornerRadius = backFavButton.frame.size.height / 2
            backFavButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var viewHeigtConst: NSLayoutConstraint!
    @IBOutlet var view1HeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}
class Good: Object{
    @objc dynamic var id = String()
    @objc dynamic var mainImage = String()
    @objc dynamic var name = String()
    @objc dynamic var shopName = String()
    @objc dynamic var shopId = String()
    @objc dynamic var price = String()
    @objc dynamic var count = Int()
    @objc dynamic var descriptionField = String()
    @objc dynamic var rating = String()
    
    var params = List<Params>()
    var imgs = List<String>()
}

class ProductItem: Object{
    @objc dynamic var id = String()
    @objc dynamic var mainImage = String()
    @objc dynamic var name = String()
    @objc dynamic var shopName = String()
    @objc dynamic var shopId = String()
    @objc dynamic var price = String()
    @objc dynamic var descriptionField = String()
    @objc dynamic var rating = String()
    @objc dynamic var count = Int()
    var imgs = List<String>()
    var params = List<Params>()
}
class Params: Object {
    @objc dynamic var name = String()
    @objc dynamic var value = String()
}

class Shop: Object{
    @objc dynamic var id = String()
    @objc dynamic var mainImage = String()
    @objc dynamic var name = String()
    @objc dynamic var descriptionField = String()
    @objc dynamic var rating = String()
    
}
extension UIViewController{
    func createGoodObject(product: Product) -> Good?{
        let good = Good()
        good.id = product.id!
        good.mainImage = product.productMainImg!
        good.shopId = product.shopId!
        good.shopName = product.shopName as! String
        good.price = product.productPrice!
        good.rating = product.productRating!
        good.name = product.productName!
        good.descriptionField = product.productDescription!
        if let images = product.productImgs{
            for img in images{
                good.imgs.append(img)
            }
        }
        
        return good
    }
    func createShopObject(shopModel: Shops) -> Shop? {
        let shop = Shop()
        shop.id = shopModel.shopId!
        shop.name = shopModel.shopName!
        shop.mainImage = shopModel.shopImg!
        shop.descriptionField = shopModel.shopDescription!
        shop.rating = shopModel.shopRating!
        return shop
    }
   
}

class cvc: UICollectionViewCell {
    @IBOutlet weak var accImage: UIImageView!
    @IBOutlet weak var toShopButton: UIButton!{
        didSet{
            toShopButton.layer.cornerRadius = 4
            toShopButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var backFavButton: UIButton!{
        didSet{
            backFavButton.layer.cornerRadius = backFavButton.frame.size.height / 2
            backFavButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var favButton: UIButton!
    @IBOutlet var view1H: NSLayoutConstraint!
    @IBOutlet var view2H: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
}

class ThirdCellWithButton: UICollectionViewCell, FSPagerViewDataSource, FSPagerViewDelegate {
    
    
    var images = [String]()
    
    override func awakeFromNib() {
        pagerView.delegate = self
        pagerView.dataSource = self
        
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            
            pageControl.contentHorizontalAlignment = .left
            self.pageControl.hidesForSinglePage = true
//            pageControl.numberOfPages = 10
            pageControl.currentPage = 0
            
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            pageControl.setFillColor(.white, for: .normal)
            pageControl.setFillColor(UIColor.cyan, for: .selected)
            pageControl.setStrokeColor(UIColor.cyan, for: .normal)
            pageControl.setStrokeColor(UIColor.cyan, for: .selected)
        }
    }
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.typeIndex = 8
        }
    }
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]
    fileprivate var typeIndex = 8 {
        didSet {
            let type = self.transformerTypes[typeIndex]
            self.pagerView.transformer = FSPagerViewTransformer(type:type)
        }
    }
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        pageControl.numberOfPages = images.count
        
        return images.count
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        cell.imageView?.clipsToBounds = true
        
        if let url = URL(string: "http://priceclick.kz/profile/uploads/products/full/" + images[index]) {
            cell.imageView?.sd_setImage(with: url)
        }
        
        
        return cell
    }
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    @IBOutlet var backFavButton: UIButton!{
        didSet{
            backFavButton.layer.cornerRadius = backFavButton.frame.size.height / 2
            backFavButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var favButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var toShopButton: UIButton!{
        didSet{
            toShopButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
}






