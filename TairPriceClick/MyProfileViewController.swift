//
//  MyProfileViewController.swift
//  Price Click
//
//  Created by Dakanov Sultan on 20.02.18.
//  Copyright © 2018 Yernur. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import AccountKit

class MyProfileViewController: UIViewController, AKFViewControllerDelegate {

    
    // MARK: - Variables
    fileprivate var accountKit = AKFAccountKit(responseType: .accessToken)
    fileprivate var pendingLoginViewController: AKFViewController? = nil
    fileprivate var showAccountOnAppear = false
    
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        hideKeyboardWhenTappedAround()

        showAccountOnAppear = accountKit.currentAccessToken != nil
        pendingLoginViewController = accountKit.viewControllerForLoginResume()
    }
    override func viewWillAppear(_ animated: Bool) {
        if showAccountOnAppear {
            showAccountOnAppear = false
//            presentWithSegueIdentifier("showAccount", animated: animated)
        } else if let viewController = pendingLoginViewController {
            prepareLoginViewController(viewController)
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: animated, completion: nil)
                pendingLoginViewController = nil
            }
        }
    }

   
    // MARK: - Outlets
    
    
    @IBOutlet var enterButton: UIButton!{
        didSet{
            enterButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet var regButton: UIButton!{
        didSet{
            regButton.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet var backView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var emailView: UIView!
    @IBOutlet var infoLabel: UILabel!
    
    // MARK: - Actions

    @IBAction func enter(_ sender: UIButton) {
        requstToLogin()
    }
    @IBAction func registration(_ sender: UIButton) {
        if let viewController = accountKit.viewControllerForPhoneLogin(with: nil, state: nil) as? AKFViewController {
            prepareLoginViewController(viewController)
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    // MARK: - Functions
    func requstToLogin(){
        if !(emailTextField.text?.isEmpty)! && !(passTextField.text?.isEmpty)!{
            
            let parameters: [String : AnyObject] = [
                "email": "\(emailTextField.text!)" as AnyObject,
                "password": "\(passTextField.text!)" as AnyObject
            ]
            
            self.logIn(parameters: parameters, completionHandler: { user in
                let userinfo = User()
                if let id = user.id{
                    userinfo.id = "\(id)"
                }
                if let key = user.authKey{
                    userinfo.authkey = key
                    UserDefaults.standard.set(key, forKey: "authKey")
                }
                if let address = user.address{
                    userinfo.address = address as! String
                }
                if let id = user.cityId{
                    userinfo.city_id = "\(id)"
                }
                if let enail = user.email{
                    userinfo.email = enail
                }
                if let phone = user.phone{
                    userinfo.phone = phone
                }
                if let name = user.username{
                    userinfo.username = name
                }
                if let name = user.name{
                    userinfo.cityName = name
                }
                let realm = try? Realm()
                try? realm?.write {
                    realm?.add(userinfo)
                }
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                var vcs = self.tabBarController?.viewControllers
                vcs![3] = storyBoard.instantiateViewController(withIdentifier: "5") as! NavigationViewController
                self.tabBarController?.setViewControllers(vcs, animated: true)
                self.tabBarController?.present(vcs![3], animated: true, completion: nil)
                
            })
        }
        
        
    }
    
    // MARK: - Helpers
    
    fileprivate func prepareLoginViewController(_ loginViewController: AKFViewController) {
        loginViewController.delegate = self
        
        loginViewController.defaultCountryCode = "KZ"
    }
    

    var phoneToVC = ""
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
//        presentWithSegueIdentifier("showAccount", animated: false)
        print("token: ", accessToken!)
        
        let accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        accountKit.requestAccount { (account, error) in
            if(error != nil){
                //error while fetching information
            }else{
                print("Account ID  \(account?.accountID)")
                if let email = account?.emailAddress,email.characters.count > 0{
                    print("Email\(email)")
                }else if let phoneNum = account?.phoneNumber{
                    print("Phone Number\(phoneNum.stringRepresentation())")
                    self.phoneToVC = phoneNum.stringRepresentation()
                    self.performSegue(withIdentifier: "ToReg", sender: self)
                }
            }
        }
        
    }
    
    

    private func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
        print("\(viewController) did fail with error: \(error)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToReg"{
            let sing : SignUpViewController = segue.destination as! SignUpViewController
            sing.phoneNumber = self.phoneToVC
        }
    }
    
}

class MyProfTVC: UITableViewCell {
    @IBOutlet var profLabel: UILabel!
    @IBOutlet var profImg: UIImageView!
    
}

class User: Object {
    @objc dynamic var id = String()
    @objc dynamic var username = String()
    @objc dynamic var email = String()
    @objc dynamic var phone = String()
    @objc dynamic var address = String()
    @objc dynamic var city_id = String()
    @objc dynamic var authkey = String()
    @objc dynamic var cityName = String()
}


