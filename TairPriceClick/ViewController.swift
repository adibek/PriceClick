//
//  ViewController.swift
//  TairPriceClick
//
//  Created by Adibek on 18.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import FSPagerView
import DropDown
import SDWebImage
import RealmSwift


class ViewController: UIViewController, FSPagerViewDelegate, FSPagerViewDataSource, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var cities = [Cities]()
    let dropDown = DropDown()
    var names = [String]()
    var ids = [String]()
    var sliderImages = [SliderImages]()
    var categories = [FirstCategory]()
    var isAll = 0
    var selectedId = String()
    var i = 0
    var x = -1
    var isFirst = true
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        isSearch = false
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
        searchBar.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.isInfinite = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        let logo = #imageLiteral(resourceName: "LogoPrice")
        let imageView = UIImageView(image: logo)
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationController?.navigationBar.topItem?.titleView = imageView
        if let _ = UserDefaults.standard.string(forKey: "cityId"){
            makeMainPage()
        }else{
            self.getCities(completionHandler: { cities in
                self.backView.frame = self.view.frame
                self.backView.alpha = 0.9
                self.view.addSubview(self.backView)
                self.cityView.frame.size = CGSize(width: Int(width - 20), height: 132)
                self.cityView.frame = CGRect(x: 10, y: (height / 2) - (self.cityView.frame.size.height / 2), width: width - 20, height: 132)
                self.view.addSubview(self.cityView)
                self.dropDown.anchorView = self.cityButton

                for city in cities{
                    self.names.append(city.name!)
                    self.ids.append(city.id!)
                }
                self.dropDown.dataSource = self.names
            })
        }
    }

    //MARK: - Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var cityView: UIView!{
        didSet{
            cityView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.typeIndex = 3
        }
    }
    @IBOutlet var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityButton: UIButton!{
        didSet{
            cityButton.layer.cornerRadius = 4
            cityButton.layer.borderWidth = 0.5
            cityButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    @IBAction func openAllShops(_ sender: Any) {
        self.isAll = 1
        self.performSegue(withIdentifier: "toShopsList", sender: self)
    }
    
    //MARK: - Functions
    func makeMainPage(){
        if let id = UserDefaults.standard.string(forKey: "cityId"){
            self.getSliderImages(id: id, completionHandler: { images in
                self.sliderImages = images
                self.pagerView.reloadData()
            })
            self.getMainCategories(completionHandler: { categories in
                self.categories = categories
                self.tableView.reloadData()
            })
        }
    }
    @IBOutlet weak var salesAction: UIButton!
    @IBOutlet weak var allShopsAction: UIButton!
    @IBAction func chooseCity(_ sender: Any) {
        if let _ = UserDefaults.standard.string(forKey: "cityId"){
            
        }else{
            UserDefaults.standard.set("9", forKey: "cityId")
        }
        self.backView.removeFromSuperview()
        self.cityView.removeFromSuperview()
        makeMainPage()
    }
    @IBAction func cities(_ sender: Any) {
        self.cityButton.setTitleColor(.black, for: .normal)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cityButton.setTitle("  " + item, for: .normal)
            self.cityButton.setTitleColor(.white, for: .normal)
            UserDefaults.standard.set(self.ids[index], forKey: "cityId")
        }
    }
    // MARK - PagerView
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
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return sliderImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if let url = sliderImages[index].sliderImageUrl{
            let url = URL(string: "https://priceclick.kz/" + url)
            cell.imageView?.clipsToBounds = true
            cell.imageView?.sd_setImage(with: url, completed: nil)
        }
        
        return cell
    }

    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.removeFromSuperview()
        isSearch = false
        x = indexPath.section
//        tableView.reloadRows(at: [indexPath], with: .none)
        isFirst = false
        tableView.reloadData()
        DispatchQueue.main.async(execute: {() -> Void in
            self.isFirst = true
        })

        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ttvc
        let i = indexPath.section
        if let url = categories[i].sectionImage{
            let str = "http://priceclick.kz/profile/uploads/sections/" + url
            let url = URL(string: str)
            cell.listIcon.sd_setImage(with: url, completed: nil)
        }
        if let name = categories[i].name{
            cell.listLabel.text = name
        }
        cell.byShopButton.layer.cornerRadius = 15
        cell.byGoodButton.layer.cornerRadius = 15
        cell.byShopButton.addTarget(self, action: #selector(byShops), for: .touchUpInside)
        cell.byGoodButton.addTarget(self, action: #selector(byGoods(_:)), for: .touchUpInside)
        cell.buttonWidth.constant = 0
        cell.rightButtonWidth.constant = 0
        cell.listIcon.isHidden = false
        cell.listLabel.isHidden = false
        let w = UIScreen.main.bounds.width
        if i == x {
            view.layoutIfNeeded()
            cell.buttonWidth.constant = w / 2 + 20
            cell.rightButtonWidth.constant = w / 2 + 20
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            cell.listIcon.isHidden = true
            cell.listLabel.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isFirst{
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.1) {
                cell.transform = CGAffineTransform.identity
            }
        }
        
    }
    //MARK: - TableView Cell Buttons
    @objc func byShops(_ sender: AnyObject){
        let button = sender as? UIButton
        let cell = button?.superview?.superview as? UITableViewCell
        i = (tableView.indexPath(for: cell!)?.section)!
        isAll = 2
        selectedId = self.categories[i].id!
        
        performSegue(withIdentifier: "toShopsList", sender: self)
    }
    @objc func byGoods(_ sender: AnyObject){
        let button = sender as? UIButton
        let cell = button?.superview?.superview as? UITableViewCell
        i = (tableView.indexPath(for: cell!)?.section)!
        isAll = 2
        selectedId = self.categories[i].id!
        performSegue(withIdentifier: "toProductsList", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShopsList"{
            let shopsVC: ShopsListVC = segue.destination as! ShopsListVC
            shopsVC.isAll = isAll
            shopsVC.sectionId = selectedId
        }else if segue.identifier == "toProductsList"{
            let productsVC: ProductsListVC = segue.destination as! ProductsListVC
            if isSearch{
                productsVC.products = self.products
            }else{
                productsVC.secId = selectedId
            }
            
        }
    }
    
    //MARK: - search bar
    @IBAction func searchAction(_ sender: Any) {

        self.searchBar.frame = CGRect(x: 0, y: 0, width: width, height: 70)
        for i in searchBar.subviews{
            if i is UIButton{
                var c = searchBar.subviews.last as? UIButton
                c?.titleLabel?.text = "Отмена"
            }
        }
        
        var currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(searchBar)
    }
    var products = [Product]()
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = ["query" : searchBar.text!]
        self.searchBar.removeFromSuperview()
        self.searchProduct(parameters: query as [String : AnyObject], completionHandler: { goods in
            isSearch = true
            self.products = goods
            self.performSegue(withIdentifier: "toProductsList", sender: self)
        })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        self.navigationController?.navigationBar.isHidden = false
        self.searchBar.removeFromSuperview()
    }
    override func viewWillDisappear(_ animated: Bool) {
        searchBar.text = ""
    }
}

var isSearch = false
class ttvc: UITableViewCell {
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet var byGoodButton: UIButton!
    @IBOutlet var byShopButton: UIButton!
    @IBOutlet var listIcon: UIImageView!
    @IBOutlet weak var buttonTrail: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var rightButtonWidth: NSLayoutConstraint!
    
    
//    override func awakeFromNib() {
//        self.listIcon.isHidden = false
//        self.listLabel.isHidden = false
//        self.byShopButton.isHidden = true
//        self.byGoodButton.isHidden = true
//        self.buttonTrail.constant = -20
//        self.byShopButton.frame.origin.x = -20
//        self.byGoodButton.frame.origin.x = UIScreen.main.bounds.size.width * 0.6
//        self.layoutIfNeeded()
//    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
   /*     byShopButton.bounds.size.width = 0
        byGoodButton.bounds.size.width = 0
        byGoodButton.frame.origin.x = UIScreen.main.bounds.size.width + 20
        byShopButton.frame.origin.x = -20
        super.setSelected(selected, animated: animated)
        // Adjusts constraints everytime switch is tapped
        if selected {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 20, options: .curveLinear, animations: {
                self.listIcon.isHidden = true
                self.listLabel.isHidden = true
                self.byGoodButton.isHidden = false
                self.byShopButton.isHidden = false
                self.byShopButton.frame.origin.x = -20
                self.buttonTrail.constant = -20
                self.byGoodButton.frame.origin.x = UIScreen.main.bounds.size.width
                var w = UIScreen.main.bounds.size.width
                if UIScreen.main.bounds.size.width < 375 {
                    w = UIScreen.main.bounds.size.width * 0.5618 // se
                }
                else if UIScreen.main.bounds.size.width == 375 {
                    w = UIScreen.main.bounds.size.width * 0.554 //8
                }
                else {
                    w = UIScreen.main.bounds.size.width * 0.545 //8 plus
                }
                self.byGoodButton.frame.origin.x = UIScreen.main.bounds.size.width + 20
                self.byShopButton.frame.size = CGSize(width: w, height: 40)
                self.byGoodButton.frame.size = CGSize(width: -w, height: 40)
//                self.buttonWidth.constant = w
                self.layoutIfNeeded()
            }, completion: nil)
        }
        else {
//            UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveLinear, animations: {
                self.listIcon.isHidden = false
                self.listLabel.isHidden = false
                self.byShopButton.isHidden = true
                self.byGoodButton.isHidden = true
                self.buttonTrail.constant = -20
                self.byShopButton.frame.origin.x = -20
                self.byGoodButton.frame.origin.x = UIScreen.main.bounds.size.width * 0.6
                self.layoutIfNeeded()
//            }, completion: nil)
        } */
    }
    
}


