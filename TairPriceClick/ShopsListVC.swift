//
//  ShopsListVC.swift
//  TairPriceClick
//
//  Created by Adibek on 18.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import RealmSwift
import Instructions

class ShopsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CoachMarksControllerDataSource, CoachMarksControllerDelegate, UISearchBarDelegate {

    //MARK: - variables
    var isAll = 0
    var sectionId = String()
    var subSecId = "0"
    var selectedShop: Shops?
    var shops = [Shops]()
    var shopId = ""
    var type = 0
    var myShops = [Shop]()
//    var result = Results<Shop>?
    var grayButton = UIButton()
    let coachMarksController = CoachMarksController()
    
    
    @objc func update() {
        UIView.animate(withDuration: 0.6, animations: {
            self.grayButton.setTitle("", for: .normal)
            self.grayButton.frame = CGRect(x: 8, y: self.buttonView.frame.origin.y, width: self.buttonView.frame.size.width, height: self.buttonView.frame.size.height)
            
        }, completion: { (finished: Bool) in
            self.grayButton.isHidden = true
            self.buttonView.isHidden = false
            self.buttonView.shake()
            var count = UserDefaults.standard.integer(forKey: "count")
            count += 1
            UserDefaults.standard.set(count, forKey: "count")

        })
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        
        searchBar.delegate = self
        if UserDefaults.standard.bool(forKey: "arrowShown"){
            if UserDefaults.standard.integer(forKey: "count") < 2{
                self.buttonView.isHidden = true
                self.grayButton.setTitle("ВЫБЕРИТЕ РАЗДЕЛ", for: .normal)
                self.grayButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                self.grayButton.layer.cornerRadius = 30
                var y: CGFloat = 0
                if width < 375{
                    y = self.buttonView.frame.origin.y - 90
                }else{
                    y = self.buttonView.frame.origin.y
                }
                self.grayButton.frame = CGRect(x: 8, y: y, width: UIScreen.main.bounds.size.width - 16, height: self.buttonView.frame.size.height)
                view.addSubview(grayButton)
                var _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)

            }else{
                self.buttonView.shake()
            }
            
        }else{
            self.coachMarksController.dataSource = self
            self.coachMarksController.start(on: self)

        }

        super.viewDidLoad()
        taleView.delegate = self
        taleView.dataSource = self
        self.makePage()
        self.backgroundImage()
        self.buttonView.shake()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.makePage()
        let realm = try? Realm()
        if let realm = realm{
            let result = realm.objects(Shop.self)
            myShops = Array(result)
        }
        navigationController?.navigationBar.isTranslucent = false
    }
    //MARK: - outlets
    @IBOutlet weak var taleView: UITableView!
    @IBOutlet weak var openCategoryButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var buttonView: UIView!{
        didSet{
            buttonView.layer.cornerRadius = buttonView.layer.frame.height / 2
        }
    }
    
    //MARK: - actions
    @IBAction func openCategory(_ sender: Any) {
        self.performSegue(withIdentifier: "toCategories", sender: self)
    }
    
    
    //MARK: - functions
    func makePage(){
        var url = String()
        if isAll == 1{
            if let id = UserDefaults.standard.string(forKey: "cityId"){
                
                url = "http://api.priceclick.kz/api/shops?city_id=\(id)"
                if type == 1{
                    url = "http://api.priceclick.kz/api/shops/subcategory-shops?subcategory_id=\(subSecId)&city_id=\(id)"
                }
            }
            // subcat getShopsBySubcategory(@Query("subcategory_id") String subcategory_id, @Query("city_id") String city_id);
            
        }else if isAll == 2{
            if let id = UserDefaults.standard.string(forKey: "cityId"){
                if type == 0{
                    url = "http://api.priceclick.kz/api/shops/section?section_id=\(sectionId)&city_id=\(id)"
                }else if type == 1{
                    url = "http://api.priceclick.kz/api/shops/subcategory-shops?subcategory_id=\(subSecId)&city_id=\(id)"
                }
            }
        }
        print(url)
        self.getShops(url: url, completionHandler: { shops in
            self.shops = shops
            if self.shops.isEmpty{
                self.showAlert(title: "Внимание", message: "К сожалению, запрашиваемыe магазины не найдены. Попробуйте проверить позже.")
            }
            self.taleView.reloadData()
            
            
        })
        
    }
    
    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return shops.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tvc
        print("shop id", self.shops[i].shopId)
        
        for shop in myShops{
            if shop.id == shops[i].shopId!{
                cell.heartButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
                break
            }else{
                cell.heartButton.setImage(UIImage(named: "newHeart"), for: .normal)
            }
        }
        if let name = self.shops[i].shopName{
            cell.shopName.text = name
        }
        if let path = shops[i].shopImg{
            let url = URL(string: "http://priceclick.kz/profile/uploads/shops/" + path)
            cell.shopImage.sd_setImage(with: url, completed: nil)
        }
        if let top = self.shops[i].shopTop{
            if top == "1"{
                cell.backgroundColor = UIColor(hexString: "#fffee2")
            }
            else {
                cell.backgroundColor = UIColor.white
            }
        }
        if let fast = shops[i].shopFastDelivery{
            if fast == "1"{
                cell.fastDelLabel.isHidden = false
            }
            else {
                cell.fastDelLabel.isHidden = true
            }
        }else {
            cell.fastDelLabel.isHidden = true
        }
        if let rating = shops[i].shopRating{
            cell.ratingLabel.text = rating
        }
        cell.heartButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
        cell.backFavButton.addTarget(self, action: #selector(updateFav(_:)), for: .touchUpInside)
        cell.backFavButton.layer.cornerRadius = 25
        cell.heartButton.tag = indexPath.section
        cell.backFavButton.tag = indexPath.section
        
        if let desc = self.shops[i].shopDescription{
            cell.shopInfo.text = desc
        }
        if let rating = self.shops[i].shopRating{
            if let double = Double(rating){
                cell.cosmosView.rating = double
            }
        }else{
            cell.cosmosView.rating = 0.0
        }
        cell.imgWidth.constant = UIScreen.main.bounds.width * 0.45
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.shopId = shops[indexPath.section].shopId!
        self.selectedShop = shops[indexPath.section]
        self.performSegue(withIdentifier: "toProducts", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    @objc func updateFav(_ sender: AnyObject) {
        let tag = sender.tag!
        let ip = IndexPath(row: 0, section: tag)
        let cell = taleView.cellForRow(at: ip) as! tvc
        
        let realm = try! Realm()
        let id = shops[tag].shopId!        
        let result = realm.objects(Shop.self).filter("id == '\(id)'")

        if result.isEmpty{
            cell.heartButton.setImage(#imageLiteral(resourceName: "newFullHeart"), for: .normal)
            let shop = self.createShopObject(shopModel: self.shops[tag])
            try! realm.write {
                print(shop!)
                self.myShops.append(shop!)
                realm.add(shop!)
            }
        }else{
            cell.heartButton.setImage(UIImage(named: "newHeart"), for: .normal)
            try! realm.write {
                var ind = 0
                for i in 0..<myShops.count{
                    if self.myShops[i].id == id{
                        ind =  i
                        break
                    }
                }
                self.myShops.remove(at: ind)
                realm.delete(result)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategories"{
            let sub: SubCategoriesVC = segue.destination as! SubCategoriesVC
            sub.secId = sectionId
            sub.from = 0
        }else if segue.identifier == "toProducts"{
            let productsVC: ProductsListVC = segue.destination as! ProductsListVC
            productsVC.secId = sectionId
            productsVC.shopId = self.shopId
            productsVC.type = 1
            productsVC.thisShop = selectedShop
        }
    }
    
    //MARK: Instructions
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: buttonView)
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
    
    //MARK: - Search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.startLoading()
        self.shops = self.filterContentForSearchText()
        self.taleView.reloadData()
        
        DispatchQueue.main.async {
            self.stopLoading()
            self.searchBar.endEditing(true)
        }
    }
    func filterContentForSearchText() -> [Shops]{
        var strArray = [String]()
        for i in shops{
            strArray.append(i.shopName!)
        }
        let filterdItemsArray = strArray.filter { item in
            return item.lowercased().contains(self.searchBar.text!.lowercased())
        }
        var searcheditem = [Shops]()
        for i in filterdItemsArray{
            for j in shops{
                if i == j.shopName!{
                    searcheditem.append(j)
                }
            }
        }
        return searcheditem
    }

}

class tvc: UITableViewCell {
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopInfo: UILabel!
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var fastDelLabel: UILabel!
    @IBOutlet var backFavButton: UIButton!
    @IBOutlet var imgWidth: NSLayoutConstraint!
    
    func update(_ rating: Double) {
        cosmosView.rating = rating
    }
    
}

extension UIView {
    func shake(count : Float = 5,for duration : TimeInterval = 1,withTranslation translation : Float = -5) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        layer.add(animation, forKey: "shake")
    }
}
