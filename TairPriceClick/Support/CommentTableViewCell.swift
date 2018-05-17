//
//  CommentTableViewCell.swift
//  TairPriceClick
//
//  Created by Adibek on 02.05.2018.
//  Copyright © 2018 Maint. All rights reserved.
//

import UIKit
import Cosmos

class CommentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
