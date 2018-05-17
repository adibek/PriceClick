//
//  CheckoutViewController.swift
//  Price Click
//
//  Created by Dakanov Sultan on 20.12.17.
//  Copyright © 2017 Yernur. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import RealmSwift
import TextFieldEffects

let loadingView = UIActivityIndicatorView()

class CheckoutViewController: UIViewController {
    
    let dropDown = DropDown()
    let dropDown1 = DropDown()
    var shopIds = [Int()]
    var id = Int()
    var korzina = [ProductItem]()
    var authKey = ""
    var adressText = ""
    var commentText = ""
    var shopInfo: ShopInfo?
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var pay: UIButton!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet var dateView: UIView!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var vHeight: NSLayoutConstraint!
    @IBOutlet var picker: UIDatePicker!
    @IBOutlet var dateButtonOutlet: UIButton!
    @IBOutlet var nameTextField: HoshiTextField!
    @IBOutlet var phoneTextField: HoshiTextField!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var minSumLabel: UILabel!
    @IBOutlet var ordersLabel: UILabel!
    @IBOutlet var deliveryInfo: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vHeight.constant = 0.5
        if let id = UserDefaults.standard.array(forKey: "contacts"){
            shopIds = id as! [Int]
        }
        else {
            shopIds = [0]
        }
        if let key = UserDefaults.standard.string(forKey: "authKey"){
            self.authKey = key
        }
        
        hideKeyboardWhenTappedAround()
        
        backgroundImage()
      
        title = "Оформить заказ"


    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try? Realm()
        let result = realm?.objects(ProductItem.self)
        self.korzina = Array(result!)
        
        let id = korzina[0].shopId
        self.getShopInfo(shopId: id, completionHandler: { info in
            self.shopInfo = info[0]
            if let sum = self.shopInfo?.shopMinPrice{
                if let x = Int(sum){
                    let xx = x.formattedWithSeparator
                    self.minSumLabel.text = "\(xx) тг."
                }
            }else{
                    self.minSumLabel.text = "0 тг."
            }
            
            if let modeOrder = self.shopInfo?.modeOrder{
                self.ordersLabel.text = modeOrder
            }
            
            if let shop_delivery = self.shopInfo?.shopDelivery{
                self.deliveryInfo.text = shop_delivery
            }
        })
        
        
        let res = realm?.objects(User.self)
        let user = Array(res!)
        nameTextField.text = user[0].username
        phoneTextField.text = user[0].phone
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var sendCheckout: UIButton!{
        didSet{
            sendCheckout.layer.cornerRadius = 4
        }
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateButtonOutlet.setTitle("\(dateFormatter.string(from:picker.date))", for: .normal)
        vHeight.constant = 2
        dateButtonOutlet.setTitleColor(UIColor.black, for: .normal)
        dateView.removeFromSuperview()
        backView.removeFromSuperview()
    }
    @IBAction func dateButton(_ sender: UIButton) {
        let w = UIScreen.main.bounds.size.width
        let h = UIScreen.main.bounds.size.height
        backView.frame = CGRect(x:0, y: 0, width: w, height: h )
        dateView.frame = CGRect(x:0, y: h - 285, width: w, height: 245)
        view.addSubview(backView)
        view.addSubview(dateView)
        
    }
    @IBAction func sensPressed(_ sender: UIButton) {
        sendCheckout.isEnabled = false
        print("Send pressed ", id)
        
        if !shopIds.contains(id){
            shopIds.append(id)
            UserDefaults.standard.set(shopIds, forKey: "contacts")
            }

        if address.text! == "" {
            getTextAlert()
        }
        else {
            adressText = address.text!
            if !(self.comment.text?.isEmpty)!{
                commentText = self.comment.text!
            }
             signUp()
        }
        }
    
    func signUp() {
        
        let parameters = [
            "auth_key" : authKey,
            "address" : adressText,
            "description" : commentText,
            "products" : createOrder()
            ] as [String : Any]
        if JSONSerialization.isValidJSONObject(parameters) {
            print("Valid Json")
        } else {
            print("InValid Json")
        }
        print("params:11", parameters)
        Alamofire.request("http://api.priceclick.kz/api/order", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            print(response)
             if response.response?.statusCode == 201 {
            if let result = response.result.value {
                if let json = result as? [String: AnyObject]{
                    print(json)
                    self.showAlert(title: "Спасибо", message: "Ваш заказ принят в обработку!")
                    let realm = try? Realm()
                    let result = realm?.objects(ProductItem.self)
                    try? realm?.write {
                        realm?.delete(result!)
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
                        
                        self.navigationController?.popViewController(animated: true)

                    }
                    
                }
            }
        }
             else if response.response?.statusCode == 400 {
                let alert = UIAlertController(title: nil, message: "Вы не авторизованы", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (action:UIAlertAction!) in
                    
                    self.stopLoading()
                    
                }))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        })

    }
    var products = [[String: AnyObject]]()
    
    func createOrder() -> [[String: AnyObject]]{
        let realm = try? Realm()
        let result = realm?.objects(ProductItem.self)
        self.korzina = Array(result!)
        for item in korzina{
            var parameters = [String: AnyObject]()
            let array = Array(item.params)
            for p in array{
                parameters[p.name] = p.value as AnyObject
            }
            var product = [String: AnyObject]()
            product["product_price"] = item.price as AnyObject
            product["product_count"] = item.count as AnyObject
            product["product_parameters"] = parameters as AnyObject
            product["product_id"] = item.id as AnyObject
            products.append(product)
        }
        return products
    }
    
    func getTextAlert(){
        let alert = UIAlertController(title: nil, message: "Заполните все поля", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (action:UIAlertAction!) in
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
  
    
}


extension UIViewController{
    func startLoading(){
        loadingView.hidesWhenStopped = true
        loadingView.activityIndicatorViewStyle = .whiteLarge
        loadingView.center = view.center
        view.addSubview(loadingView)
        loadingView.startAnimating()
    }
    func stopLoading(){
        loadingView.stopAnimating()
    }
}

extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

