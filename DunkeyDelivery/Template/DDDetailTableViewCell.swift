
//
//  DDDetailTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/10/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userDate: UILabel!
    @IBOutlet weak var userOrders: UILabel!
    @IBOutlet weak var userReviews: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var rankingDesc: UILabel!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var starView: DDStarView!
    @IBOutlet weak var detailedItem: UILabel!
    @IBOutlet weak var menuItem: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
