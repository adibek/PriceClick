//
//  Objects.swift
//  TairPriceClick
//
//  Created by Adibek on 18.04.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Foundation
import ObjectMapper
import CoreData

class ShopInfo : NSObject, NSCoding, Mappable{
    
    var cityId : String?
    var cityTitle : String?
    var countProducts : String?
    var created : String?
    var dealerId : String?
    var lastEdit : String?
    var mode : String?
    var modeOrder : String?
    var monetization : String?
    var oplata : String?
    var shopContacts : String?
    var shopDelivery : String?
    var shopDeliveryPrice : AnyObject?
    var shopDescription : String?
    var shopEmail : String?
    var shopFastDelivery : String?
    var shopId : String?
    var shopImg : String?
    var shopMinPrice : String?
    var shopName : String?
    var shopPayOptions : AnyObject?
    var shopRating : String?
    var shopReturn : String?
    var shopTop : String?
    var shopVverh : String?
    var status : String?
    var userId : String?
    var wmode : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ShopInfo()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        cityId <- map["city_id"]
        cityTitle <- map["city_title"]
        countProducts <- map["count_products"]
        created <- map["created"]
        dealerId <- map["dealer_id"]
        lastEdit <- map["last_edit"]
        mode <- map["mode"]
        modeOrder <- map["mode_order"]
        monetization <- map["monetization"]
        oplata <- map["oplata"]
        shopContacts <- map["shop_contacts"]
        shopDelivery <- map["shop_delivery"]
        shopDeliveryPrice <- map["shop_delivery_price"]
        shopDescription <- map["shop_description"]
        shopEmail <- map["shop_email"]
        shopFastDelivery <- map["shop_fast_delivery"]
        shopId <- map["shop_id"]
        shopImg <- map["shop_img"]
        shopMinPrice <- map["shop_min_price"]
        shopName <- map["shop_name"]
        shopPayOptions <- map["shop_pay_options"]
        shopRating <- map["shop_rating"]
        shopReturn <- map["shop_return"]
        shopTop <- map["shop_top"]
        shopVverh <- map["shop_vverh"]
        status <- map["status"]
        userId <- map["user_id"]
        wmode <- map["wmode"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        cityId = aDecoder.decodeObject(forKey: "city_id") as? String
        cityTitle = aDecoder.decodeObject(forKey: "city_title") as? String
        countProducts = aDecoder.decodeObject(forKey: "count_products") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        dealerId = aDecoder.decodeObject(forKey: "dealer_id") as? String
        lastEdit = aDecoder.decodeObject(forKey: "last_edit") as? String
        mode = aDecoder.decodeObject(forKey: "mode") as? String
        modeOrder = aDecoder.decodeObject(forKey: "mode_order") as? String
        monetization = aDecoder.decodeObject(forKey: "monetization") as? String
        oplata = aDecoder.decodeObject(forKey: "oplata") as? String
        shopContacts = aDecoder.decodeObject(forKey: "shop_contacts") as? String
        shopDelivery = aDecoder.decodeObject(forKey: "shop_delivery") as? String
        shopDeliveryPrice = aDecoder.decodeObject(forKey: "shop_delivery_price") as? AnyObject
        shopDescription = aDecoder.decodeObject(forKey: "shop_description") as? String
        shopEmail = aDecoder.decodeObject(forKey: "shop_email") as? String
        shopFastDelivery = aDecoder.decodeObject(forKey: "shop_fast_delivery") as? String
        shopId = aDecoder.decodeObject(forKey: "shop_id") as? String
        shopImg = aDecoder.decodeObject(forKey: "shop_img") as? String
        shopMinPrice = aDecoder.decodeObject(forKey: "shop_min_price") as? String
        shopName = aDecoder.decodeObject(forKey: "shop_name") as? String
        shopPayOptions = aDecoder.decodeObject(forKey: "shop_pay_options") as? AnyObject
        shopRating = aDecoder.decodeObject(forKey: "shop_rating") as? String
        shopReturn = aDecoder.decodeObject(forKey: "shop_return") as? String
        shopTop = aDecoder.decodeObject(forKey: "shop_top") as? String
        shopVverh = aDecoder.decodeObject(forKey: "shop_vverh") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        wmode = aDecoder.decodeObject(forKey: "wmode") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if cityId != nil{
            aCoder.encode(cityId, forKey: "city_id")
        }
        if cityTitle != nil{
            aCoder.encode(cityTitle, forKey: "city_title")
        }
        if countProducts != nil{
            aCoder.encode(countProducts, forKey: "count_products")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if dealerId != nil{
            aCoder.encode(dealerId, forKey: "dealer_id")
        }
        if lastEdit != nil{
            aCoder.encode(lastEdit, forKey: "last_edit")
        }
        if mode != nil{
            aCoder.encode(mode, forKey: "mode")
        }
        if modeOrder != nil{
            aCoder.encode(modeOrder, forKey: "mode_order")
        }
        if monetization != nil{
            aCoder.encode(monetization, forKey: "monetization")
        }
        if oplata != nil{
            aCoder.encode(oplata, forKey: "oplata")
        }
        if shopContacts != nil{
            aCoder.encode(shopContacts, forKey: "shop_contacts")
        }
        if shopDelivery != nil{
            aCoder.encode(shopDelivery, forKey: "shop_delivery")
        }
        if shopDeliveryPrice != nil{
            aCoder.encode(shopDeliveryPrice, forKey: "shop_delivery_price")
        }
        if shopDescription != nil{
            aCoder.encode(shopDescription, forKey: "shop_description")
        }
        if shopEmail != nil{
            aCoder.encode(shopEmail, forKey: "shop_email")
        }
        if shopFastDelivery != nil{
            aCoder.encode(shopFastDelivery, forKey: "shop_fast_delivery")
        }
        if shopId != nil{
            aCoder.encode(shopId, forKey: "shop_id")
        }
        if shopImg != nil{
            aCoder.encode(shopImg, forKey: "shop_img")
        }
        if shopMinPrice != nil{
            aCoder.encode(shopMinPrice, forKey: "shop_min_price")
        }
        if shopName != nil{
            aCoder.encode(shopName, forKey: "shop_name")
        }
        if shopPayOptions != nil{
            aCoder.encode(shopPayOptions, forKey: "shop_pay_options")
        }
        if shopRating != nil{
            aCoder.encode(shopRating, forKey: "shop_rating")
        }
        if shopReturn != nil{
            aCoder.encode(shopReturn, forKey: "shop_return")
        }
        if shopTop != nil{
            aCoder.encode(shopTop, forKey: "shop_top")
        }
        if shopVverh != nil{
            aCoder.encode(shopVverh, forKey: "shop_vverh")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if wmode != nil{
            aCoder.encode(wmode, forKey: "wmode")
        }
        
    }
    
}
class OrderDetail : NSObject, NSCoding, Mappable{
    
    var id : String?
    var productCount : String?
    var productMainImg : String?
    var productName : String?
    var productPrice : String?
    var shopId : String?
    var shopName : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return OrderDetail()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        productCount <- map["product_count"]
        productMainImg <- map["product_main_img"]
        productName <- map["product_name"]
        productPrice <- map["product_price"]
        shopId <- map["shop_id"]
        shopName <- map["shop_name"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        productCount = aDecoder.decodeObject(forKey: "product_count") as? String
        productMainImg = aDecoder.decodeObject(forKey: "product_main_img") as? String
        productName = aDecoder.decodeObject(forKey: "product_name") as? String
        productPrice = aDecoder.decodeObject(forKey: "product_price") as? String
        shopId = aDecoder.decodeObject(forKey: "shop_id") as? String
        shopName = aDecoder.decodeObject(forKey: "shop_name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if productCount != nil{
            aCoder.encode(productCount, forKey: "product_count")
        }
        if productMainImg != nil{
            aCoder.encode(productMainImg, forKey: "product_main_img")
        }
        if productName != nil{
            aCoder.encode(productName, forKey: "product_name")
        }
        if productPrice != nil{
            aCoder.encode(productPrice, forKey: "product_price")
        }
        if shopId != nil{
            aCoder.encode(shopId, forKey: "shop_id")
        }
        if shopName != nil{
            aCoder.encode(shopName, forKey: "shop_name")
        }
        
    }
    
}
class MainOrders : NSObject, NSCoding, Mappable{
    
    var count : String?
    var createdDate : String?
    var id : String?
    var overallSumm : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return MainOrders()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        count <- map["count"]
        createdDate <- map["created_date"]
        id <- map["id"]
        overallSumm <- map["overall_summ"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        count = aDecoder.decodeObject(forKey: "count") as? String
        createdDate = aDecoder.decodeObject(forKey: "created_date") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        overallSumm = aDecoder.decodeObject(forKey: "overall_summ") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if count != nil{
            aCoder.encode(count, forKey: "count")
        }
        if createdDate != nil{
            aCoder.encode(createdDate, forKey: "created_date")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if overallSumm != nil{
            aCoder.encode(overallSumm, forKey: "overall_summ")
        }
        
    }
    
}

class Comment : NSObject, NSCoding, Mappable{
    
    var authorId : String?
    var created : String?
    var id : String?
    var lastEdit : String?
    var objectId : String?
    var productName : String?
    var review : String?
    var status : String?
    var username : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Comment()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        authorId <- map["author_id"]
        created <- map["created"]
        id <- map["id"]
        lastEdit <- map["last_edit"]
        objectId <- map["object_id"]
        productName <- map["product_name"]
        review <- map["review"]
        status <- map["status"]
        username <- map["username"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        authorId = aDecoder.decodeObject(forKey: "author_id") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        lastEdit = aDecoder.decodeObject(forKey: "last_edit") as? String
        objectId = aDecoder.decodeObject(forKey: "object_id") as? String
        productName = aDecoder.decodeObject(forKey: "product_name") as? String
        review = aDecoder.decodeObject(forKey: "review") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if authorId != nil{
            aCoder.encode(authorId, forKey: "author_id")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastEdit != nil{
            aCoder.encode(lastEdit, forKey: "last_edit")
        }
        if objectId != nil{
            aCoder.encode(objectId, forKey: "object_id")
        }
        if productName != nil{
            aCoder.encode(productName, forKey: "product_name")
        }
        if review != nil{
            aCoder.encode(review, forKey: "review")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        
    }
    
}

class RegResponse : NSObject, NSCoding, Mappable{
    
    var authKey : String?
    var message : String?
    var status : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return RegResponse()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        authKey <- map["auth_key"]
        message <- map["message"]
        status <- map["status"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        authKey = aDecoder.decodeObject(forKey: "auth_key") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if authKey != nil{
            aCoder.encode(authKey, forKey: "auth_key")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        
    }
    
}


class UserInfo : NSObject, NSCoding, Mappable{
    
    var address : AnyObject?
    var authKey : String?
    var cityId : Int?
    var created : Int?
    var date : String?
    var email : String?
    var id : Int?
    var lastEdit : String?
    var name : String?
    var phone : String?
    var username : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return UserInfo()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        address <- map["address"]
        authKey <- map["auth_key"]
        cityId <- map["city_id"]
        created <- map["created"]
        date <- map["date"]
        email <- map["email"]
        id <- map["id"]
        lastEdit <- map["last_edit"]
        name <- map["name"]
        phone <- map["phone"]
        username <- map["username"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        address = aDecoder.decodeObject(forKey: "address") as? AnyObject
        authKey = aDecoder.decodeObject(forKey: "auth_key") as? String
        cityId = aDecoder.decodeObject(forKey: "city_id") as? Int
        created = aDecoder.decodeObject(forKey: "created") as? Int
        date = aDecoder.decodeObject(forKey: "date") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lastEdit = aDecoder.decodeObject(forKey: "last_edit") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if authKey != nil{
            aCoder.encode(authKey, forKey: "auth_key")
        }
        if cityId != nil{
            aCoder.encode(cityId, forKey: "city_id")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastEdit != nil{
            aCoder.encode(lastEdit, forKey: "last_edit")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if phone != nil{
            aCoder.encode(phone, forKey: "phone")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        
    }
    
}
class Product : NSObject, NSCoding, Mappable{
    
    var categoryId : String?
    var colors : [String]?
    var id : String?
    var parameters : [Parameter]?
    var productDescription : String?
    var productImgs : [String]?
    var productListCount : AnyObject?
    var productListId : String?
    var productMainImg : String?
    var productName : String?
    var productPrice : String?
    var productRating : String?
    var sectionId : String?
    var sectionName : String?
    var shopId : String?
    var shopName : AnyObject?
    var sizes : [String]?
    var subcategoryId : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Product()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        categoryId <- map["category_id"]
        colors <- map["colors"]
        id <- map["id"]
        parameters <- map["parameters"]
        productDescription <- map["product_description"]
        productImgs <- map["product_imgs"]
        productListCount <- map["product_list_count"]
        productListId <- map["product_list_id"]
        productMainImg <- map["product_main_img"]
        productName <- map["product_name"]
        productPrice <- map["product_price"]
        productRating <- map["product_rating"]
        sectionId <- map["section_id"]
        sectionName <- map["section_name"]
        shopId <- map["shop_id"]
        shopName <- map["shop_name"]
        sizes <- map["sizes"]
        subcategoryId <- map["subcategory_id"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
        colors = aDecoder.decodeObject(forKey: "colors") as? [String]
        id = aDecoder.decodeObject(forKey: "id") as? String
        parameters = aDecoder.decodeObject(forKey: "parameters") as? [Parameter]
        productDescription = aDecoder.decodeObject(forKey: "product_description") as? String
        productImgs = aDecoder.decodeObject(forKey: "product_imgs") as? [String]
        productListCount = aDecoder.decodeObject(forKey: "product_list_count") as? AnyObject
        productListId = aDecoder.decodeObject(forKey: "product_list_id") as? String
        productMainImg = aDecoder.decodeObject(forKey: "product_main_img") as? String
        productName = aDecoder.decodeObject(forKey: "product_name") as? String
        productPrice = aDecoder.decodeObject(forKey: "product_price") as? String
        productRating = aDecoder.decodeObject(forKey: "product_rating") as? String
        sectionId = aDecoder.decodeObject(forKey: "section_id") as? String
        sectionName = aDecoder.decodeObject(forKey: "section_name") as? String
        shopId = aDecoder.decodeObject(forKey: "shop_id") as? String
        shopName = aDecoder.decodeObject(forKey: "shop_name") as? AnyObject
        sizes = aDecoder.decodeObject(forKey: "sizes") as? [String]
        subcategoryId = aDecoder.decodeObject(forKey: "subcategory_id") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "category_id")
        }
        if colors != nil{
            aCoder.encode(colors, forKey: "colors")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if parameters != nil{
            aCoder.encode(parameters, forKey: "parameters")
        }
        if productDescription != nil{
            aCoder.encode(productDescription, forKey: "product_description")
        }
        if productImgs != nil{
            aCoder.encode(productImgs, forKey: "product_imgs")
        }
        if productListCount != nil{
            aCoder.encode(productListCount, forKey: "product_list_count")
        }
        if productListId != nil{
            aCoder.encode(productListId, forKey: "product_list_id")
        }
        if productMainImg != nil{
            aCoder.encode(productMainImg, forKey: "product_main_img")
        }
        if productName != nil{
            aCoder.encode(productName, forKey: "product_name")
        }
        if productPrice != nil{
            aCoder.encode(productPrice, forKey: "product_price")
        }
        if productRating != nil{
            aCoder.encode(productRating, forKey: "product_rating")
        }
        if sectionId != nil{
            aCoder.encode(sectionId, forKey: "section_id")
        }
        if sectionName != nil{
            aCoder.encode(sectionName, forKey: "section_name")
        }
        if shopId != nil{
            aCoder.encode(shopId, forKey: "shop_id")
        }
        if shopName != nil{
            aCoder.encode(shopName, forKey: "shop_name")
        }
        if sizes != nil{
            aCoder.encode(sizes, forKey: "sizes")
        }
        if subcategoryId != nil{
            aCoder.encode(subcategoryId, forKey: "subcategory_id")
        }
        
    }
    
}

class Parameter : NSObject, NSCoding, Mappable{
    
    var name : String?
    var params : [String]?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Parameter()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        name <- map["name"]
        params <- map["params"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as? String
        params = aDecoder.decodeObject(forKey: "params") as? [String]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if params != nil{
            aCoder.encode(params, forKey: "params")
        }
        
    }
    
}
class MainCategory : NSObject, NSCoding, Mappable{
    
    var categoryId : Int?
    var categoryName : String?
    var subcategories : [Subcategory]?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return MainCategory()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        categoryId <- map["category_id"]
        categoryName <- map["category_name"]
        subcategories <- map["subcategories"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? Int
        categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
        subcategories = aDecoder.decodeObject(forKey: "subcategories") as? [Subcategory]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "category_id")
        }
        if categoryName != nil{
            aCoder.encode(categoryName, forKey: "category_name")
        }
        if subcategories != nil{
            aCoder.encode(subcategories, forKey: "subcategories")
        }
        
    }
    
}



class Subcategory : NSObject, NSCoding, Mappable{
    
    var id : Int?
    var name : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Subcategory()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}


class Shops : NSObject, NSCoding, Mappable{
    
    var cityId : String?
    var cityTitle : String?
    var countProducts : String?
    var created : String?
    var dealerId : String?
    var lastEdit : String?
    var mode : String?
    var modeOrder : String?
    var monetization : String?
    var shopContacts : String?
    var shopDelivery : String?
    var shopDeliveryPrice : AnyObject?
    var shopDescription : String?
    var shopEmail : String?
    var shopFastDelivery : String?
    var shopId : String?
    var shopImg : String?
    var shopMinPrice : String?
    var shopName : String?
    var shopPayOptions : AnyObject?
    var shopRating : String?
    var shopReturn : String?
    var shopTop : String?
    var status : String?
    var userId : String?
    var wmode : String?
    var message : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Shops()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        cityId <- map["city_id"]
        cityTitle <- map["city_title"]
        countProducts <- map["count_products"]
        created <- map["created"]
        dealerId <- map["dealer_id"]
        lastEdit <- map["last_edit"]
        mode <- map["mode"]
        modeOrder <- map["mode_order"]
        monetization <- map["monetization"]
        shopContacts <- map["shop_contacts"]
        shopDelivery <- map["shop_delivery"]
        shopDeliveryPrice <- map["shop_delivery_price"]
        shopDescription <- map["shop_description"]
        shopEmail <- map["shop_email"]
        shopFastDelivery <- map["shop_fast_delivery"]
        shopId <- map["shop_id"]
        shopImg <- map["shop_img"]
        shopMinPrice <- map["shop_min_price"]
        shopName <- map["shop_name"]
        shopPayOptions <- map["shop_pay_options"]
        shopRating <- map["shop_rating"]
        shopReturn <- map["shop_return"]
        shopTop <- map["shop_top"]
        status <- map["status"]
        userId <- map["user_id"]
        wmode <- map["wmode"]
        message <- map["message"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        cityId = aDecoder.decodeObject(forKey: "city_id") as? String
        cityTitle = aDecoder.decodeObject(forKey: "city_title") as? String
        countProducts = aDecoder.decodeObject(forKey: "count_products") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        dealerId = aDecoder.decodeObject(forKey: "dealer_id") as? String
        lastEdit = aDecoder.decodeObject(forKey: "last_edit") as? String
        mode = aDecoder.decodeObject(forKey: "mode") as? String
        modeOrder = aDecoder.decodeObject(forKey: "mode_order") as? String
        monetization = aDecoder.decodeObject(forKey: "monetization") as? String
        shopContacts = aDecoder.decodeObject(forKey: "shop_contacts") as? String
        shopDelivery = aDecoder.decodeObject(forKey: "shop_delivery") as? String
        shopDeliveryPrice = aDecoder.decodeObject(forKey: "shop_delivery_price") as? AnyObject
        shopDescription = aDecoder.decodeObject(forKey: "shop_description") as? String
        shopEmail = aDecoder.decodeObject(forKey: "shop_email") as? String
        shopFastDelivery = aDecoder.decodeObject(forKey: "shop_fast_delivery") as? String
        shopId = aDecoder.decodeObject(forKey: "shop_id") as? String
        shopImg = aDecoder.decodeObject(forKey: "shop_img") as? String
        shopMinPrice = aDecoder.decodeObject(forKey: "shop_min_price") as? String
        shopName = aDecoder.decodeObject(forKey: "shop_name") as? String
        shopPayOptions = aDecoder.decodeObject(forKey: "shop_pay_options") as? AnyObject
        shopRating = aDecoder.decodeObject(forKey: "shop_rating") as? String
        shopReturn = aDecoder.decodeObject(forKey: "shop_return") as? String
        shopTop = aDecoder.decodeObject(forKey: "shop_top") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        wmode = aDecoder.decodeObject(forKey: "wmode") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if cityId != nil{
            aCoder.encode(cityId, forKey: "city_id")
        }
        if cityTitle != nil{
            aCoder.encode(cityTitle, forKey: "city_title")
        }
        if countProducts != nil{
            aCoder.encode(countProducts, forKey: "count_products")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if dealerId != nil{
            aCoder.encode(dealerId, forKey: "dealer_id")
        }
        if lastEdit != nil{
            aCoder.encode(lastEdit, forKey: "last_edit")
        }
        if mode != nil{
            aCoder.encode(mode, forKey: "mode")
        }
        if modeOrder != nil{
            aCoder.encode(modeOrder, forKey: "mode_order")
        }
        if monetization != nil{
            aCoder.encode(monetization, forKey: "monetization")
        }
        if shopContacts != nil{
            aCoder.encode(shopContacts, forKey: "shop_contacts")
        }
        if shopDelivery != nil{
            aCoder.encode(shopDelivery, forKey: "shop_delivery")
        }
        if shopDeliveryPrice != nil{
            aCoder.encode(shopDeliveryPrice, forKey: "shop_delivery_price")
        }
        if shopDescription != nil{
            aCoder.encode(shopDescription, forKey: "shop_description")
        }
        if shopEmail != nil{
            aCoder.encode(shopEmail, forKey: "shop_email")
        }
        if shopFastDelivery != nil{
            aCoder.encode(shopFastDelivery, forKey: "shop_fast_delivery")
        }
        if shopId != nil{
            aCoder.encode(shopId, forKey: "shop_id")
        }
        if shopImg != nil{
            aCoder.encode(shopImg, forKey: "shop_img")
        }
        if shopMinPrice != nil{
            aCoder.encode(shopMinPrice, forKey: "shop_min_price")
        }
        if shopName != nil{
            aCoder.encode(shopName, forKey: "shop_name")
        }
        if shopPayOptions != nil{
            aCoder.encode(shopPayOptions, forKey: "shop_pay_options")
        }
        if shopRating != nil{
            aCoder.encode(shopRating, forKey: "shop_rating")
        }
        if shopReturn != nil{
            aCoder.encode(shopReturn, forKey: "shop_return")
        }
        if shopTop != nil{
            aCoder.encode(shopTop, forKey: "shop_top")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if wmode != nil{
            aCoder.encode(wmode, forKey: "wmode")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        
    }
    
}


class FirstCategory : NSObject, NSCoding, Mappable{
    
    var id : String?
    var name : String?
    var sectionImage : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return FirstCategory()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
        sectionImage <- map["section_image"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        sectionImage = aDecoder.decodeObject(forKey: "section_image") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if sectionImage != nil{
            aCoder.encode(sectionImage, forKey: "section_image")
        }
        
    }
    
}

class SliderImages : NSObject, NSCoding, Mappable{
    
    var cityId : String?
    var sliderImageCreatedAt : String?
    var sliderImageId : String?
    var sliderImageStatus : String?
    var sliderImageUrl : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return SliderImages()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        cityId <- map["city_id"]
        sliderImageCreatedAt <- map["slider_image_created_at"]
        sliderImageId <- map["slider_image_id"]
        sliderImageStatus <- map["slider_image_status"]
        sliderImageUrl <- map["slider_image_url"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        cityId = aDecoder.decodeObject(forKey: "city_id") as? String
        sliderImageCreatedAt = aDecoder.decodeObject(forKey: "slider_image_created_at") as? String
        sliderImageId = aDecoder.decodeObject(forKey: "slider_image_id") as? String
        sliderImageStatus = aDecoder.decodeObject(forKey: "slider_image_status") as? String
        sliderImageUrl = aDecoder.decodeObject(forKey: "slider_image_url") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if cityId != nil{
            aCoder.encode(cityId, forKey: "city_id")
        }
        if sliderImageCreatedAt != nil{
            aCoder.encode(sliderImageCreatedAt, forKey: "slider_image_created_at")
        }
        if sliderImageId != nil{
            aCoder.encode(sliderImageId, forKey: "slider_image_id")
        }
        if sliderImageStatus != nil{
            aCoder.encode(sliderImageStatus, forKey: "slider_image_status")
        }
        if sliderImageUrl != nil{
            aCoder.encode(sliderImageUrl, forKey: "slider_image_url")
        }
        
    }
    
}
class Cities : NSObject, NSCoding, Mappable{
    
    var connectEmail : String?
    var connectPhone : String?
    var connectWhatsapp : String?
    var countryId : String?
    var created : String?
    var faqEmail : String?
    var id : String?
    var lastEdit : String?
    var name : String?
    var status : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Cities()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        connectEmail <- map["connect_email"]
        connectPhone <- map["connect_phone"]
        connectWhatsapp <- map["connect_whatsapp"]
        countryId <- map["country_id"]
        created <- map["created"]
        faqEmail <- map["faq_email"]
        id <- map["id"]
        lastEdit <- map["last_edit"]
        name <- map["name"]
        status <- map["status"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        connectEmail = aDecoder.decodeObject(forKey: "connect_email") as? String
        connectPhone = aDecoder.decodeObject(forKey: "connect_phone") as? String
        connectWhatsapp = aDecoder.decodeObject(forKey: "connect_whatsapp") as? String
        countryId = aDecoder.decodeObject(forKey: "country_id") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        faqEmail = aDecoder.decodeObject(forKey: "faq_email") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        lastEdit = aDecoder.decodeObject(forKey: "last_edit") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if connectEmail != nil{
            aCoder.encode(connectEmail, forKey: "connect_email")
        }
        if connectPhone != nil{
            aCoder.encode(connectPhone, forKey: "connect_phone")
        }
        if connectWhatsapp != nil{
            aCoder.encode(connectWhatsapp, forKey: "connect_whatsapp")
        }
        if countryId != nil{
            aCoder.encode(countryId, forKey: "country_id")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if faqEmail != nil{
            aCoder.encode(faqEmail, forKey: "faq_email")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastEdit != nil{
            aCoder.encode(lastEdit, forKey: "last_edit")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        
    }
    
}


extension UIViewController{
    func backgroundImage() {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let backgroundImage = UIImageView(frame: rect)
        backgroundImage.image = UIImage(named: "background_small")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
}

extension ViewController {
    
    func configureNavigationItem() {
        let resultsController =  UITableViewController(style: .plain)
        if #available(iOS 11.0, *) {
            navigationItem.searchController = UISearchController(searchResultsController: resultsController)
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            
        }
        
    }
}

extension UIViewController{
    func getAuthAlert(){
        let alert = UIAlertController(title: nil, message: "Вы не авторизованы", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (action:UIAlertAction!) in
            
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension UIViewController {   // dissmis keyboard on tap anywhere
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "HelveticaNeue-Medium", size: 15)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}





