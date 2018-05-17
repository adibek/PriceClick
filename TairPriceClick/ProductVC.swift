//
//  ProductVC.swift
//  TairPriceClick
//
//  Created by Adibek on 19.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import FSPagerView
import RealmSwift
import Cosmos

var params = [Params]()

class ProductVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var good: Good?
    var product: Product?
    var isGood = false
    var count = 2
    var comments = [Comment]()
    var hasComments = false
    var countOfGood = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        params = []
    }
    override func viewDidLoad() {

        
        
        super.viewDidLoad()
        if good != nil{
            isGood = true
            
        }else{
            isGood = false
            let realm  = try? Realm()
            let result = realm?.objects(ProductItem.self).filter("id == '\(product!.id!)'")
            if let res = result{
                for i in res{
                    countOfGood += i.count
                }
                tableView.reloadData()
            }
            if let id = product?.id{
                self.getComments(id: id, completionHandler: { comms in
                    self.comments = comms
                    
                    self.tableView.reloadData()
                    self.hasComments = true
                })
                self.count += 1
            }
            
            
            if let _ = product?.colors{
                count += 1
            }
            
            
            if let params = product?.parameters?.count{
                count += params
            }
            
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.row
        if isGood{
            if i == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "pagerCell", for: indexPath) as! PagerViewTVC
                
                if let images = good?.imgs{
                    if images.count > 0{
                        for i in images{
                            cell.images.append(i)
                        }
                        return cell
                    }else{
                        cell.images[0] = (good?.mainImage)!
                        cell.pagerView.reloadData()
                        return cell
                    }
                    
                }else{
                    cell.images[0] = (good?.mainImage)!
                    cell.pagerView.reloadData()
                    return cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! ProductIntTVC
                cell.plusMinusView.removeFromSuperview()
                cell.numberLabel.text = "\(countOfGood)"
                if showName == false{
                    cell.shopButton.removeFromSuperview()
                    cell.smallView.removeFromSuperview()
                }
                if let name = good?.name{
                    cell.nameLabel.text = name
                }else{
                    cell.nameLabel.text = "-"
                }
                if let price = good?.price{
                    if let x = Int(price){
                        let xx = x.formattedWithSeparator
                        cell.priceLabel.text = "\(xx) тг."
                    }
                    
                }else{
                    cell.priceLabel.text = "0 тг."
                }
                if let shopName = good?.shopName{
                    cell.shopButton.setTitle(shopName, for: .normal)
                }
                if let info = good?.descriptionField{
                    cell.descriptionLabel.text = info
                }
                if let rating = good?.rating{
                    cell.ratingLabel.text = rating
                }
                cell.shopButton.addTarget(self, action: #selector(toShop(_:)), for: .touchUpInside)
                return cell
            }
            
        }
        else{
            if i == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "pagerCell", for: indexPath) as! PagerViewTVC
                
                if let images = product?.productImgs{
                    cell.images = images
                    cell.pagerView.reloadData()
                    return cell
                }else{
                    if let image = product?.productMainImg{
                        cell.images = [image]
                        cell.pagerView.reloadData()
                        return cell
                    }else{
                        return cell
                    }
                }
            }else if i == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! ProductIntTVC
                if let name = product?.productName{
                    cell.nameLabel.text = name
                }else{
                    cell.nameLabel.text = "-"
                }
                if showName == false{
                    if let b = cell.shopButton{
                        b.removeFromSuperview()
                    }
                    if let s = cell.smallView{
                        s.removeFromSuperview()
                    }
                    
                }
                
                if let price = product?.productPrice{
                    cell.priceLabel.text = price + " тг."
                }else{
                    cell.priceLabel.text = "0 тг."
                }
                if let shopName = product?.shopName as? String{
                    if let b = cell.shopButton{
                        b.setTitle(shopName, for: .normal)
                        cell.shopButton.addTarget(self, action: #selector(toShop(_:)), for: .touchUpInside)
                    }
                    
                }
                if let info = product?.productDescription{
                    cell.descriptionLabel.text = info
                }
                if let rating = product?.productRating{
                    cell.ratingLabel.text = rating
                }
                cell.numberLabel.text = "\(self.countOfGood)"
                cell.plusButton.addTarget(self, action: #selector(plus(_:)), for: .touchUpInside)
                cell.minusButton.addTarget(self, action: #selector(minus(_:)), for: .touchUpInside)
                return cell
            }else if i == 2{
                if let colors = product?.colors{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! ColorTVC
                    
                    cell.colors = colors
                    cell.collectionView.reloadData()
                    
                    
                    return cell
                }else{
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "paramsCell", for: indexPath) as! ParamsTVC

                    return UITableViewCell()
                }
                
            }
            
            else if i == count - 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "comCells", for: indexPath) as! CommentsTVC
                    cell.coms = self.comments
                    cell.tableView.reloadData()

                    return cell
                }
            
            else{
                if let params = product?.parameters{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "paramsCell", for: indexPath) as! ParamsTVC
                    if let name = params[indexPath.row - 3].name{
                        cell.nameLabel.text = name
                    }
                    if let values = params[indexPath.row - 3].params{
                        cell.parameters = values
                        cell.collectionView.reloadData()
                        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                        layout.sectionInset = UIEdgeInsets(top: 20, left: 2, bottom: 10, right: 2)
                        layout.minimumInteritemSpacing = 4
                        layout.minimumLineSpacing = 4
                        cell.collectionView.collectionViewLayout = layout
                    }
                    return cell
                    
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "paramsCell", for: indexPath) as! ParamsTVC
                    return cell
                    
                }
            }
            
        }

    }
    
    //segue toCurrentShop

    
    @objc func plus(_ sender: AnyObject) {
        
        let realm = try? Realm()
        
        let id = product!.shopId!
        let result = realm?.objects(ProductItem.self)
        if let count = result?.count{
            if count < 1{
                self.addGood()
            }else{
                let result = realm?.objects(ProductItem.self).filter("shopId == '\(id)'")
                if let count = result?.count{
                    if count > 0{
                        self.addGood()
                    }else{
                        let refreshAlert = UIAlertController(title: "Внимание", message: "В Вашей корзине находится неоформленный заказ с другого магазина. Очистить корзину?", preferredStyle: UIAlertControllerStyle.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
                            let realm = try? Realm()
                            let result = realm?.objects(ProductItem.self)
                            try? realm?.write {
                                realm?.delete(result!)
                            }
                            self.addGood()
                        }))
                        
                        refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        present(refreshAlert, animated: true, completion: nil)
                    }
                }
                
            }
        }

        
     
    }
    
    @objc func minus(_ sender: AnyObject) {
            if params.count < count - 2{
            self.showAlert(title: "Внимание", message: "Выберите все параметры")
        }else{
            let realm = try? Realm()
            
            let id = product!.shopId!
            let result = realm?.objects(ProductItem.self)
            if let count = result?.count{
                if count < 1{
                    self.removeGood()
                }else{
                    let result = realm?.objects(ProductItem.self).filter("shopId == '\(id)'")
                    if let count = result?.count{
                        if count > 0{
                            self.removeGood()
                        }else{
                            let refreshAlert = UIAlertController(title: "Внимание", message: "Корзина будет очищена", preferredStyle: UIAlertControllerStyle.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                let realm = try? Realm()
                                let result = realm?.objects(ProductItem.self)
                                try? realm?.write {
                                    realm?.delete(result!)
                                }
                                self.removeGood()
                            }))
                            
                            refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (action: UIAlertAction!) in
                                
                            }))
                            
                            present(refreshAlert, animated: true, completion: nil)
                        }
                    }
                    
                }
            }

           
        }
        }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func addGood(){
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ProductIntTVC
        
        if params.count < count - 3{
            self.scrollToBottom()
            let cells = self.tableView.visibleCells
            for cell in cells{
                if cell.reuseIdentifier == "colorCell" || cell.reuseIdentifier == "paramsCell" {
                    cell.backgroundColor = #colorLiteral(red: 1, green: 0.796098727, blue: 0.7392509707, alpha: 0.5959706764)
                }
            }
            self.showAlert(title: "Внимание", message: "Выберите все параметры")
        }else{
            
            
            let item = ProductItem()
            item.id = product!.id!
            item.name = product!.productName!
            item.mainImage = product!.productMainImg!
            item.descriptionField = product!.productDescription!
            for p in params{
                item.params.append(p)
            }
            item.price = product!.productPrice!
            item.rating = product!.productRating!
            item.shopId = product!.shopId!
            item.shopName = product!.shopName! as! String
            
            
            let realm = try? Realm()
            let result = realm?.objects(ProductItem.self).filter("id == '\(item.id)'")
            let korzina = Array(result!)
            var updated = false
            for i in korzina{
                let check = compareParams(firstParam: i.params, secondParams: item.params)
                if check{
                    print("SUCCESS", i.params, item.params)
                    updated = true
                    try? realm?.write {
                        i.count = i.count + 1
                        print("UPDATED")
                    }
                    cell.numberLabel.text = "\(countOfGood + 1)"
                    break
                }
                
            }
            if updated == false{
                item.count = 1
                try? realm?.write {
                    realm?.add(item)
                    print("ADDED")
                    cell.numberLabel.text = "\(countOfGood + 1)"
                }
            }
            countOfGood += 1
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
    
    func removeGood(){
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ProductIntTVC

        let item = ProductItem()
        item.id = product!.id!
        item.name = product!.productName!
        item.mainImage = product!.productMainImg!
        item.descriptionField = product!.productDescription!
        for p in params{
            item.params.append(p)
        }
        item.price = product!.productPrice!
        item.rating = product!.productRating!
        item.shopName = product!.shopName! as! String
        
        
        let realm = try? Realm()
        let result = realm?.objects(ProductItem.self).filter("id == '\(item.id)'")
        let korzina = Array(result!)
        var updated = false
        
        for i in korzina{
            let check = compareParams(firstParam: i.params, secondParams: item.params)
            if check{
                print("SUCCESS", i.params, item.params)
                updated = true
                try? realm?.write {
                    if i.count < 2{
                        realm?.delete(i)
                    }else{
                        i.count = i.count - 1
                    }
                    
                    print("UPDATED")
                }
                cell.numberLabel.text = "\(countOfGood - 1)"
                break
            }
            
        }
        if countOfGood != 0{
            countOfGood -= 1
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
    
    @objc func toShop(_ sender: AnyObject) {
        let tag = sender.tag!
        
        performSegue(withIdentifier: "toCurrentShop", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCurrentShop"{
            let shop: ProductsListVC = segue.destination as! ProductsListVC
            if isGood{
                shop.shopId = good!.shopId
            }else{
                shop.shopId = product!.shopId!
            }
            shop.type = 1
            
        }
    }
    
  
}
class itemCvc: UICollectionViewCell {
    @IBOutlet weak var itemSizeLabel: UILabel!
}

class colorCvc: UICollectionViewCell {
    @IBOutlet var colorView: UIView!{
        didSet{
            colorView.layer.cornerRadius = colorView.frame.size.height / 2
            colorView.layer.borderWidth = 0.45
            colorView.layer.borderColor = UIColor.gray.cgColor
        }
    }
}

class ParamsTVC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var parameters = [""]
    var paramName = ["SSD","CPU","RAM"]
    var height = CGFloat()
    var pressed = Int(-1)
    let w = UIScreen.main.bounds.size.width
    let h = UIScreen.main.bounds.size.height
    
    
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        self.collectionViewHeight.constant = self.collectionView.contentSize.height + 5
    }
    fileprivate var sectionInsets: UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parameters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        self.collectionViewHeight.constant = self.collectionView.contentSize.height + 5
        

        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! itemCvc
        cell.layer.borderWidth = 0.4
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = cell.frame.size.width / 3.4
        cell.layer.masksToBounds = true
        cell.itemSizeLabel.text = parameters[indexPath.row]
        cell.layer.cornerRadius = 5
        
        if indexPath.row == pressed{
            cell.backgroundColor = UIColor.cyan
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        else {
            cell.backgroundColor = UIColor.white
            
        }
        cell.layoutIfNeeded()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pressed = indexPath.row
        let param = Params()
        param.name = nameLabel.text!
        param.value = self.parameters[indexPath.row]
        var replaced = false
        for i in 0..<params.count{
            if params[i].name == param.name{
                params[i] = param
                replaced = true
                break
            }
        }
        if replaced == false{
            params.append(param)
        }
        
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widths = parameters[indexPath.row].count * 3
    
        
        if parameters[indexPath.row].count < 3{
            widths = 40
        }else{
            widths = 20 + (parameters[indexPath.row].count * 7)
        }
        return CGSize(width: widths, height: 25)
    }
    
}
class ParamsCVC: UICollectionViewCell {
    
    @IBOutlet var paramLabel: UILabel!
    
}


class PagerViewTVC: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {
    
    
    var images = [String]()
    
    override func awakeFromNib() {
        pagerView.delegate = self
        pagerView.dataSource = self
    }
    
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.typeIndex = 8
        }
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
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)

        cell.imageView?.clipsToBounds = true
        
        if let url = URL(string: "http://priceclick.kz/profile/uploads/products/full/" + images[index]) {
            cell.imageView?.sd_setImage(with: url)
        }
        
        
        return cell
    }
    
}

class ColorTVC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var colors = [String]()
    var selectedColor = String()
    override func awakeFromNib() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hi: NSLayoutConstraint!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        hi.constant = collectionView.contentSize.height + 5
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! colorCvc
        cell.colorView.backgroundColor = UIColor(hexString: colors[indexPath.row])
        if colors[indexPath.row] == selectedColor{
            cell.layer.borderWidth = 0.5
            cell.colorView.layer.borderWidth = 0
            cell.backgroundColor = UIColor(hexString: colors[indexPath.row])
        }else{
            cell.backgroundColor = UIColor.white
            cell.colorView.backgroundColor = UIColor(hexString: colors[indexPath.row])
            cell.layer.borderWidth = 0
            cell.colorView.layer.borderWidth = 0.45
            cell.layer.borderColor = UIColor.gray.cgColor
        }
        cell.layer.cornerRadius = cell.frame.size.height / 2
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors[indexPath.row]
        let param = Params()
        param.name = "Цвет"
        param.value = colors[indexPath.row]
        var replaced = false
        for i in 0..<params.count{
            if params[i].name == param.name{
                params[i] = param
                replaced = true
                break
            }
        }
        if replaced == false{
            params.append(param)
        }

        collectionView.reloadData()
    }
    
    
    
    
}
class SizeTVC: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
}


class ProductIntTVC: UITableViewCell {
    
    
    @IBOutlet weak var hi1: NSLayoutConstraint!{
        didSet{
            hi1.constant = 0.4
        }
    }
    @IBOutlet weak var hi2: NSLayoutConstraint!{
        didSet{
            hi2.constant = 0.4
        }
    }
    @IBOutlet weak var plusMinusView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var smallView: UIView!
    
    @IBOutlet weak var circleView: UIView!{
        didSet{
            circleView.layer.cornerRadius = circleView.frame.size.height / 2
            circleView.layer.masksToBounds = true
            circleView.layer.borderColor = UIColor.black.cgColor
            circleView.layer.borderWidth = 0.6
        }
    }
}
extension UIViewController{
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func compareParams(firstParam: List<Params>, secondParams: List<Params>) -> Bool{
        
        if firstParam.count != secondParams.count{
            return false
        }
        for p in firstParam{
            var check = false
            for s in secondParams{
                if p.name == s.name && p.value == s.value{
                    check = true
                    break
                }
            }
            if check == false{
                return false
            }
        }
        
        return true
        
    }
}
class CommentsTVC: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    var coms = [Comment]()
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        hi.constant = tableView.contentSize.height + 5
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hi: NSLayoutConstraint!
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell{
            let i = indexPath.row
            if let text = coms[i].review{
                cell.commentLabel.text = text
            }
            if let text = coms[i].status{
                if let rating = Double(text){
                    cell.cosmosView.rating = rating
                }
//                cell.ratingLabel.text = text
            }
            if let text = coms[i].username{
                cell.nameLabel.text = text
            }
            if let date = coms[i].created{
                
                cell.dateLabel.text = self.makeDateForComment(timestamp: date)
            }
            
            hi.constant = tableView.contentSize.height + 5
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hi.constant = tableView.contentSize.height
        return coms.count
        
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110
//    }
    
    
    
}
