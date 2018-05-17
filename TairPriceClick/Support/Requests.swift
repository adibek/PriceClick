//
//  Requests.swift
//  TairPriceClick
//
//  Created by Adibek on 18.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire

let basicUrl = "http://api.priceclick.kz/api/"
let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height
extension UITableViewCell{
    func makeDateForComment(timestamp: String) -> String{
        if let timeStamp = Double(timestamp){
            
            let date = Date(timeIntervalSince1970: timeStamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM"
            var strDate = dateFormatter.string(from: date)
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter1.locale = NSLocale.current
            dateFormatter1.dateFormat = "dd"
            var strDate1 = dateFormatter1.string(from: date)
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter2.locale = NSLocale.current
            dateFormatter2.dateFormat = "yyyy"
            var strDate2 = dateFormatter2.string(from: date)
            
            
            switch strDate {
            case "01":
                strDate = "Января"
            case "02":
                strDate = "Февраля"
            case "03":
                strDate = "Марта"
            case "04":
                strDate = "Апреля"
            case "05":
                strDate = "Мая"
            case "06":
                strDate = "Июня"
            case "07":
                strDate = "Июля"
            case "08":
                strDate = "Августа"
            case "09":
                strDate = "Сентября"
            case "10":
                strDate = "Октября"
            case "11":
                strDate = "Ноября"
            default:
                strDate = "Декабря"
            }

            return "\(strDate1) \(strDate), \(strDate2)"
        }
        return ""
        
    }
}

extension UIViewController{

    
    func getShopInfo(shopId: String, completionHandler: @escaping (_ cats: [ShopInfo]) -> ()) {
        
        var fullCategories = [ShopInfo]()
        Alamofire.request(basicUrl + "shops/shop-info?shop_id=\(shopId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[ShopInfo]>) in
            if let code = response.response?.statusCode{
                if code == 200{
                    let cats = response.result.value
                    if let catArray = cats {
                        for item in catArray {
                            fullCategories.append(item)
                        }
                        completionHandler(fullCategories)
                    }
                }else{
                    completionHandler(fullCategories)
                }
            }
        }
    }
    
    func getOrderData(params: [String: AnyObject], completionHandler: @escaping (_ cats: [OrderDetail]) -> ()) {
        
        var fullCategories = [OrderDetail]()
        Alamofire.request(basicUrl + "orders-list", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[OrderDetail]>) in
            if let code = response.response?.statusCode{
                if code == 200{
                    let cats = response.result.value
                    if let catArray = cats {
                        for item in catArray {
                            fullCategories.append(item)
                        }
                        completionHandler(fullCategories)
                    }
                }else{
                    completionHandler(fullCategories)
                }
            }
        }
    }
    

    func getOrders(params: [String: AnyObject], completionHandler: @escaping (_ cats: [MainOrders]) -> ()) {
        
        var fullCategories = [MainOrders]()
        Alamofire.request(basicUrl + "order-group-list", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[MainOrders]>) in
            if let code = response.response?.statusCode{
                if code == 200{
                    let cats = response.result.value
                    if let catArray = cats {
                        for item in catArray {
                            fullCategories.append(item)
                        }
                        completionHandler(fullCategories)
                    }
                }else{
                    completionHandler(fullCategories)
                }
            }
        }
    }
    
    
    
    func getComments(id: String, completionHandler: @escaping (_ cats: [Comment]) -> ()) {
        
        var fullCategories = [Comment]()
        Alamofire.request(basicUrl + "reviews/getreviews?product_id=" + id, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[Comment]>) in
            if let code = response.response?.statusCode{
                if code == 200{
                    let cats = response.result.value
                    if let catArray = cats {
                        for item in catArray {
                            fullCategories.append(item)
                        }
                        completionHandler(fullCategories)
                    }
                }else{
                    completionHandler(fullCategories)
                }
            }
        }
    }
    
    
    func register(parameters: [String: AnyObject], completionHandler: @escaping (_ params: RegResponse) -> ()) {
        
        Alamofire.request("\(basicUrl)sign-up", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseObject{
            (response: DataResponse<RegResponse>) in
            if let code = response.response?.statusCode{
                if code < 205{
                    if let info = response.result.value{
                        completionHandler(info)
                    }else{
                        self.showAlert(title: "Внимание", message: "Введите корректные данные")
                    }
                }else{
                    self.showAlert(title: "Внимание", message: "Введите корректные данные")
                }
            }else{
                self.showAlert(title: "Внимание", message: "Введите корректные данные")
            }
            
        }
        
    }
    
    
    
    
    func logIn(parameters: [String: AnyObject], completionHandler: @escaping (_ params: UserInfo) -> ()) {
        
        Alamofire.request("\(basicUrl)login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseObject{
            (response: DataResponse<UserInfo>) in
            if let code = response.response?.statusCode{
                if code < 205{
                    if let info = response.result.value{
                        completionHandler(info)
                    }else{
                        self.showAlert(title: "Внимание", message: "Введите корректные данные")
                    }
                }else{
                    self.showAlert(title: "Внимание", message: "Введите корректные данные")
                }
                
            }else{
                self.showAlert(title: "Внимание", message: "Введите корректные данные")
            }
            
        }
        
    }
    
    
    func searchProduct(parameters: [String : AnyObject], completionHandler: @escaping (_ cats: [Product]) -> ()) {
        
        var fullCategories = [Product]()
        Alamofire.request(basicUrl + "products/global", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[Product]>) in
            if let code = response.response?.statusCode{
                if code == 200{
                    let cats = response.result.value
                    if let catArray = cats {
                        for item in catArray {
                            fullCategories.append(item)
                        }
                        completionHandler(fullCategories)
                    }
                }else{
                    completionHandler(fullCategories)
                }
            }
        }
    }
    
    func getProducts(url: String, completionHandler: @escaping (_ cats: [Product]) -> ()) {
        
        var fullCategories = [Product]()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[Product]>) in
            if let code = response.response?.statusCode{
                if code == 200{
                    let cats = response.result.value
                    if let catArray = cats {
                        for item in catArray {
                            fullCategories.append(item)
                        }
                        completionHandler(fullCategories)
                    }
                }else{
                    completionHandler(fullCategories)
                }
            }
        }
    }
    
    
    func getCategories(url: String, completionHandler: @escaping (_ cats: [MainCategory]) -> ()) {
     
        var fullCategories = [MainCategory]()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[MainCategory]>) in
            let cats = response.result.value
            if let catArray = cats {
                for item in catArray {
                    fullCategories.append(item)
                }
                completionHandler(fullCategories)
            }
        }
    }
    
    
    func getShops(url: String, completionHandler: @escaping (_ cats: [Shops]) -> ()) {
        var fullCategories = [Shops]()
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[Shops]>) in
            if let code = response.response?.statusCode{
                if code == 200{
                    if let cats = response.result.value{
                        let catArray = cats
                        for item in catArray {
                            fullCategories.append(item)
                        }
                        completionHandler(fullCategories)
                    }
                }else{
                    completionHandler(fullCategories)
                }
            }
        }
    }
    
    func getMainCategories(completionHandler: @escaping (_ cats: [FirstCategory]) -> ()) {
        var fullCategories = [FirstCategory]()
        Alamofire.request(basicUrl + "sections", method: .get, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[FirstCategory]>) in
            if let cats = response.result.value{
                let catArray = cats
                for item in catArray {
                    fullCategories.append(item)
                }
                completionHandler(fullCategories)
            }
        }
    }
    
    func getSliderImages(id: String, completionHandler: @escaping (_ cats: [SliderImages]) -> ()) {
        var fullCategories = [SliderImages]()
        Alamofire.request(basicUrl + "slider?city_id=\(id)", method: .get, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[SliderImages]>) in
            if let cats = response.result.value{
                let catArray = cats
                for item in catArray {
                    fullCategories.append(item)
                }
                completionHandler(fullCategories)
            }
        }
    }
    
    func getCities(completionHandler: @escaping (_ cats: [Cities]) -> ()) {
        var fullCategories = [Cities]()
        Alamofire.request(basicUrl + "cities", method: .get, encoding: JSONEncoding.default, headers: nil).responseArray { (response: DataResponse<[Cities]>) in
            if let cats = response.result.value{
                let catArray = cats
                for item in catArray {
                    fullCategories.append(item)
                }
                completionHandler(fullCategories)
            }
        }
    }



    
}

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}




extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
