//
//  LoginViewController.swift
//  Price Click
//
//  Created by Dakanov Sultan on 22.12.17.
//  Copyright © 2017 Yernur. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown
import AKMaskField
import Alamofire

class LoginViewController: UIViewController, AKMaskFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var ok = false
    let dropDown = DropDown()
    var newPhone3 = String()
    var cities = [Cities]()
    var index1 = -1
    var firstCity = "0"
    var firstCityId = UserDefaults.standard.string(forKey: "cityId")
    let userCityId = UserDefaults.standard.string(forKey: "cityId")
    var authKey = String()
    var userInfo = [User]()
    
    
    @IBOutlet weak var phone: AKMaskField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var backEditView: UIButton!
    @IBOutlet var backEditView1: UIButton!{
        didSet{
            backEditView1.layer.cornerRadius = backEditView1.frame.size.height / 2
        }
    }
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
//    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var city: UIButton!
    @IBOutlet var cityView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBAction func cityPressed(_ sender: UIButton) {

            view.addSubview(cityView)
            let w = UIScreen.main.bounds.size.width
            let h = UIScreen.main.bounds.size.height
            cityView.frame = CGRect(x:0, y: 0, width: w, height: h)
            tableView.tableFooterView = UIView()
        }
 
    
    
    @IBAction func logout1(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: "Выйти", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler:{ (action:UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "authKey")
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            var vcs = self.tabBarController?.viewControllers
            vcs![3] = storyBoard.instantiateViewController(withIdentifier: "4") as! NavigationViewController
            self.tabBarController?.setViewControllers(vcs, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.default, handler:{ (action:UIAlertAction!) in
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    

    @IBAction func EditButton(_ sender: UIButton) {
        if (name.text == "" ){
            name.attributedPlaceholder = NSAttributedString(string:"* заполните поле",
                                                                attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            print("Please input all data")
        }
        else if email.text == "" {
            email.attributedPlaceholder = NSAttributedString(string:"* заполните поле",
                                                                 attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            print("Please input all data")
        }
        else if phone.text?.isValidPhone == false {
            phone.text = ""
            phone.attributedPlaceholder = NSAttributedString(string:"* заполните поле",
                                                             attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
        }
        else {
            if !ok{
                name.isEnabled = true
                //        email.isEnabled = true
                phone.isEnabled = true
                city.isEnabled = true
                name.borderStyle = UITextBorderStyle.roundedRect
                phone.borderStyle = UITextBorderStyle.roundedRect
                city.layer.borderWidth = 1
                city.layer.borderColor = UIColor.lightGray.cgColor
                city.layer.cornerRadius = 5
                editButton.setImage(#imageLiteral(resourceName: "ok"), for: .normal)
            }
            else {
                name.isEnabled = false
                email.isEnabled = false
                phone.isEnabled = false
                city.isEnabled = false
                name.borderStyle = UITextBorderStyle.none
                phone.borderStyle = UITextBorderStyle.none
                city.layer.borderWidth = 0
                city.setTitleColor(.black, for: .normal)
                editButton.setImage(#imageLiteral(resourceName: "pencil"), for: .normal)
                changeUserInfo()
                
            }
            ok = !ok
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let key = UserDefaults.standard.string(forKey: "authKey"){
            self.authKey = key
        }
        phone.maskDelegate = self
      //  self.title = "Регистрация"
        hideKeyboardWhenTappedAround()
        backEditView.layer.cornerRadius = 30

        getCity()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try? Realm()
        let user = realm?.objects(User.self)
        self.userInfo = Array(user!)
        makePage()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makePage(){
        self.phone.text = userInfo[0].phone
        self.email.text = userInfo[0].email
        self.name.text = userInfo[0].username
        self.city.setTitle(userInfo[0].cityName, for: .normal)
    }
    func changeUserInfo(){
        let newPhone = phone.text?.replacingOccurrences(of: " ", with: "")
        let newPhone1 = newPhone?.replacingOccurrences(of: "(", with: "")
        let newPhone2 = newPhone1?.replacingOccurrences(of: ")", with: "")
        newPhone3 = (newPhone2?.replacingOccurrences(of: "-", with: ""))!
        
        let parameters: [String: Any] = [
            "auth_key": "\(authKey)",
            "username": name.text!,
            "phone": newPhone3,
            "city_id": firstCityId!
        ]
 
        let url = "http://api.priceclick.kz/api/user-info/change"
        //        Alamofire.upload(url, method(for: .post))
        print("params: \(parameters)")
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseJSON { response in
                print(response)
                if response.response?.statusCode != 400{
                    let realm = try? Realm()
                    let res = realm?.objects(User.self)
                    let user = Array(res!)
                    try? realm?.write {
                        user[0].phone = self.newPhone3
                        user[0].city_id = self.firstCityId!
                        user[0].username = self.name.text!
                    }
                }//////
                else {
                    self.showAlert(title: "Внимание", message: "Данный номер телефона уже зарегистрирован")
                    self.makePage()
                }
        }
    }
    
    func getCity(){
        self.getCities(completionHandler: { cities in
            self.cities = cities
            self.tableView.reloadData()
        })
    }
    
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LoginCityTVC
        cell.cityLabel.text = cities[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index1 = indexPath.row + 1
        self.firstCity = self.cities[indexPath.row].name!
        self.firstCityId = self.cities[indexPath.row].id
        self.city.setTitle(" \(firstCity)", for: .normal)
        print("fist City is: ", self.firstCity, " id is: ", self.firstCityId)
        cityView.removeFromSuperview()
    }
    
}

extension String {
    var isValidEmail: Bool {
        return isMatching(expression: try! NSRegularExpression(pattern: "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"))
    }
    private func isMatching(expression: NSRegularExpression) -> Bool {
        return expression.numberOfMatches(in: self, range: NSRange(location: 0, length: characters.count)) > 0
    }
    var isValidPass: Bool {
        let passWordReg = "^.*(?=.{6,})(?=.*[a-zA-Z0-9]).*$"
        return NSPredicate(format: "SELF MATCHES %@", passWordReg as CVarArg).evaluate(with: self)
    }
    var isValidPhone: Bool {
        let phone = "^[8]+ ([(]{1}[0-9]{3}\\))+ [0-9]{3}+-[0-9]{2}+-[0-9]{2}$"
        return NSPredicate(format: "SELF MATCHES %@", phone as CVarArg).evaluate(with: self)
    }
}

class LoginCityTVC: UITableViewCell {
    @IBOutlet var cityLabel: UILabel!
}
