//
//  SignUpViewController.swift
//  Price Click
//
//  Created by Dakanov Sultan on 21.12.17.
//  Copyright © 2017 Yernur. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown
import Alamofire
import TextFieldEffects

class SignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var phoneNumber = ""
    var cities = [Cities]()
    var authKey = ""
    var newPhone3 = ""
    let dropDown = DropDown()
    var check = 0
    var index1 = -1
    var firstCity = "0"
    var firstCityId = "0"
    let userCity = UserDefaults.standard.string(forKey: "cityId")
    var fromSetting = Bool()
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var phone: HoshiTextField!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameText: HoshiTextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: HoshiTextField!
    @IBOutlet weak var passRepeatText: HoshiTextField!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var vHeight: NSLayoutConstraint!{
        didSet{
            vHeight.constant = 0.5
        }
    }
    @IBOutlet var cityView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var checkBox: UIButton!{
        didSet{
            checkBox.layer.borderWidth = 0.6
            checkBox.layer.borderColor = UIColor.black.cgColor
            checkBox.layer.cornerRadius = 4
            
        }
    }
    
    
    @IBAction func acceptPressed(_ sender: Any) {
        checkBox.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
        signUpButton.backgroundColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        signUpButton.isEnabled = true
    }
    @IBAction func cityButtonPressed(_ sender: UIButton) {
        
        view.addSubview(cityView)
        self.cityButton.setTitleColor(.black, for: .normal)

    }

    @IBAction func agreement(_ sender: UIButton) {
    }
    @IBAction func toEnter(_ sender: UIButton) {
        performSegue(withIdentifier: "ToEnter", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    override func viewDidLoad() {
    //    self.title = "Регистрация"
        super.viewDidLoad()
        self.phone.isEnabled = false
        self.phone.text = phoneNumber
        backgroundImage()
        signUpButton.isEnabled = false
        dropDown.anchorView = self.cityButton
        getCity()
        agreeButton.underline()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        passText.delegate = self
        passText.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        passRepeatText.delegate = self
        passRepeatText.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        
        cityView.frame = CGRect(x:0, y: 0, width: w, height: h)
        hideKeyboardWhenTappedAround()
    }
 
    @IBAction func signUpButton(_ sender: UIButton) {
    
        if (nameText.text == "" ){
            nameText.placeholder = "Введите Ваше имя"
            nameText.placeholderColor = . red
            nameText.borderInactiveColor = .red
//            nameText.attributedPlaceholder = NSAttributedString(string:"* заполните поле",
                                                          //      attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            print("Please input all data")
        }
        else if phone.text == "" {
            phone.placeholder = "Введите номер телефона"
            phone.placeholderColor = . red
            phone.borderInactiveColor = .red
            print("Please input all data")
        }
        else if index1 == -1 {
                self.cityButton.setTitle("* Выберите город", for: .normal)
                self.cityButton.setTitleColor(.red, for: .normal)
        }
        else if passText.text?.isValidPass == false {
            passText.placeholder = "Введите корректный пароль"
            passText.borderInactiveColor = .red
            passText.placeholderColor = . red
            
        }
        else {
            if passRepeatText.text != passText.text {
                passRepeatText.text = ""
                passRepeatText.placeholder = "Пароли не совпадают"
                passRepeatText.borderInactiveColor = .red
                passRepeatText.placeholderColor = . red
            }else{
                let newPhone = phone.text?.replacingOccurrences(of: " ", with: "")
                let newPhone1 = newPhone?.replacingOccurrences(of: "(", with: "")
                let newPhone2 = newPhone1?.replacingOccurrences(of: ")", with: "")
                newPhone3 = (newPhone2?.replacingOccurrences(of: "-", with: ""))!
                phone.text! = newPhone3
                self.cityButton.setTitleColor(.black, for: .normal)
                signUp()
            }
        }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
   
    func getCity(){

        self.getCities(completionHandler: { cities in
            self.cities = cities
            self.tableView.reloadData()
        })
        
        
    }
    func signUp(){//111////
        let parameters: [String: AnyObject] = [
            "username": "\(nameText.text!)" as AnyObject,
            "email": "\(emailText.text!)" as AnyObject,
            "phone": "\(newPhone3)" as AnyObject,
            "password": "\(passText.text!)" as AnyObject,
            "city_id": Int(userCity!) as AnyObject
            
        ]
        let user = User()
        user.cityName = firstCity
        user.city_id = userCity!
        user.username = nameText.text!
        user.email = emailText.text!
        user.phone = newPhone3
        self.register(parameters: parameters) { response in
            if let key = response.authKey{
                UserDefaults.standard.set(key, forKey: "authKey")
                
                let realm = try? Realm()
                let result = realm?.objects(User.self)
                try? realm?.write {
                    realm?.delete(result!)
                }
                try? realm?.write {
                    realm?.add(user)
                }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                var vcs = self.tabBarController?.viewControllers
                vcs![3] = storyBoard.instantiateViewController(withIdentifier: "5") as! NavigationViewController
                self.tabBarController?.setViewControllers(vcs, animated: true)
                
                
                
            }
        }
        
    }
    
    func getAlert(){
        let alert = UIAlertController(title: nil, message: "Данный телефон/e-mail уже зарегистрирован", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (action:UIAlertAction!) in
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cityTVC
        cell.cityLabel.text = cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index1 = indexPath.row + 1
        self.firstCity = cities[indexPath.row].name!
        self.firstCityId = self.cities[indexPath.row].id!
        self.cityButton.setTitle("\(firstCity)", for: .normal)
        vHeight.constant = 2
        print("fist City is :  ", self.firstCity, " id is: ", self.firstCityId)
        cityView.removeFromSuperview()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.passText{
            if passText.text!.count < 6{
                showWarning(textField: textField, text: "Пароль должен содержать минимум 6 символов", view: whiteView)
            }else{
                warningLabel.removeFromSuperview()
            }
        }else if textField == passRepeatText{
            if passText.text! != passRepeatText.text!{
                showWarning(textField: textField, text: "Пароли не совпадают", view: whiteView)
            }else{
                warningLabel.removeFromSuperview()
            }
        }
    }
    func textFieldDidChange(textField: UITextField){
        if textField == passText{
            if passText.text!.count > 5{
                warningLabel.removeFromSuperview()
            }
        }else if textField == passRepeatText{
            warningLabel.removeFromSuperview()
        }
    }
    @IBOutlet var whiteView: UIView!
    
}

class cityTVC: UITableViewCell {
    
    @IBOutlet var cityLabel: UILabel!
    
}

extension NSRegularExpression {
    convenience init(pattern: String) {
        try! self.init(pattern: pattern, options: [])
    }
}

let warningLabel = UILabel()

extension UIViewController{
    func showWarning(textField: UITextField, text: String, view: UIView){
        warningLabel.text = text
        warningLabel.textColor = UIColor.red
        warningLabel.font = warningLabel.font.withSize(10)
        let y = textField.frame.origin.y + textField.frame.size.height + 1
        warningLabel.frame = CGRect(x: textField.frame.origin.x, y: y, width: UIScreen.main.bounds.size.width, height: 10)
        view.addSubview(warningLabel)
    }
}


