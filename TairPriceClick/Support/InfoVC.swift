//
//  InfoVC.swift
//  TairPriceClick
//
//  Created by Adibek on 02.05.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit

class InfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var labels = ["Рассказать другу", "О нас", "Отправить отзыв", "Пользовательское соглашение"]
    var images = [#imageLiteral(resourceName: "share black"),#imageLiteral(resourceName: "abou us black"),#imageLiteral(resourceName: "feedback black"),#imageLiteral(resourceName: "term black")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    }

    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    
    // MARK: - Functions
    
    func shareFunc() {
        let activityVC = UIActivityViewController(activityItems: ["В приложении Price Click удобно и выгодно покупать, не выходя из дома. Рекомендую! - https://itunes.apple.com/us/app/price-click/id1384640165?l=ru&ls=1&mt=8"], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func feedBackFunc() {
        let url: NSURL = URL(string:"https://itunes.apple.com/us/app/price-click/id1384640165?l=ru&ls=1&mt=8")! as NSURL
        UIApplication.shared.open( url as URL, options: [:], completionHandler: nil)
    }

    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTVC
        cell.label.text = labels[indexPath.row]
        cell.image1.image = images[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            shareFunc()
        }
        else if indexPath.row == 1 {
            performSegue(withIdentifier: "ToAboutUs", sender: self)
        }
        else if indexPath.row == 2 {
            feedBackFunc()
        }
        else {
            performSegue(withIdentifier: "ToTerm", sender: self)
        }
    }
    
}

class SettingsTVC: UITableViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var image1: UIImageView!
    
}



