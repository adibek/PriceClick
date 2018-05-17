//
//  SubCategoriesVC.swift
//  TairPriceClick
//
//  Created by Adibek on 19.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import ExpyTableView

class SubCategoriesVC: UIViewController,  ExpyTableViewDelegate, ExpyTableViewDataSource {

    
    var from = 0
    var shopId = "0"
    var secId = "0"
    var categories = [MainCategory]()
    
    override func viewDidLoad() {
        
        var url = String()
        if shopId != "0"{
            url = "http://api.priceclick.kz/api/categories/shop-categories?shop_id=\(shopId)"
        } else if secId != "0"  && secId != ""{
             url = "http://api.priceclick.kz/api/categories/?section_id=\(secId)"
        }else{
            url = "http://api.priceclick.kz/api/categories/all-sections"
        }
        print(url)
        self.getCategories(url: url, completionHandler: { cats in
            self.categories = cats
            self.tableView.reloadData()
        })
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        backgroundImage()
        title = "Выберите раздел"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false

    }

    
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = categories[section].subcategories?.count{
            return count + 1
        }else{
            return 0
        }
        
        
    }
    func canExpand(section: Int, inTableView tableView: ExpyTableView) -> Bool {
        return true
    }
    func expandableCell(forSection section: Int, inTableView tableView: ExpyTableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! podTvc
        cell.podLabel.text = categories[section].categoryName
        cell.layoutMargins = UIEdgeInsets.zero
        cell.showSeparator()
        return cell
        
    }
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! podTvc
        cell.podLabel.text = categories[section].categoryName
        cell.layoutMargins = UIEdgeInsets.zero
        cell.showSeparator()
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath) as! SubTVC
        if indexPath.row != 0{
            cell.subLabel.text = categories[indexPath.section].subcategories?[indexPath.row - 1].name
        }
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.hideSeparator()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row != 0 {
            if from == 0{
                if let id = self.categories[indexPath.section].subcategories?[indexPath.row - 1].id{
                    self.secId = "\(id)"
                    let a = self.navigationController?.viewControllers[1] as! ShopsListVC
                    a.subSecId = self.secId
                    a.type = 1
                    self.navigationController?.popViewController(animated: true)
                }
            }else if from == 1{
                if let id = self.categories[indexPath.section].subcategories?[indexPath.row - 1].id{
                    self.secId = "\(id)"
                    if let a = self.navigationController?.viewControllers[1] as? ProductsListVC{
                        a.subSecId = secId
                        a.type = 2
                        self.navigationController?.popViewController(animated: true)
                    }else if let a = self.navigationController?.viewControllers[2] as? ProductsListVC{
                        a.subSecId = secId
                        a.type = 2
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
                
            }
            
            
        }
    }
    
}

class SubTVC: UITableViewCell {
    
    @IBOutlet weak var subLabel: UILabel!
}
extension UITableViewCell {
    
    func showSeparator() {
        DispatchQueue.main.async { [weak self]  in
            self?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func hideSeparator() {
        DispatchQueue.main.async { [weak self] in
            self?.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
        }
    }
}


class podTvc: UITableViewCell,ExpyTableViewHeaderCell {
    
    @IBOutlet weak var podLabel: UILabel!
    @IBOutlet weak var imagel: UIImageView!
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        switch state {
        case .willExpand:
            print("WILL EXPAND")
            hideSeparator()
            arrowDown(animated: !cellReuse)
            
        case .willCollapse:
            print("WILL COLLAPSE")
            arrowRight(animated: !cellReuse)
            
        case .didExpand:
            print("DID EXPAND")
            
        case .didCollapse:
            showSeparator()
            print("DID COLLAPSE")
        }
    }
    private func arrowDown(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) { [weak self]  in
            self?.imagel.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
        }
    }
    
    private func arrowRight(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) { [weak self]  in
            self?.imagel.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    
    
}

