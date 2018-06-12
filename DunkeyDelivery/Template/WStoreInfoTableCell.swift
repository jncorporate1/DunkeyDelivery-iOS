//
//  WStoreInfoTableCell.swift
//  Template
//
//  Created by Jamil Khan on 8/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class WStoreInfoTableCell: UITableViewCell {
    
    @IBOutlet var changeBtn: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var ratingView: DDStarView!
    @IBOutlet weak var deliveryChargesLabel: UILabel!
    @IBOutlet weak var minimunOrderPrice: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tag1Label: UILabel!
    @IBOutlet weak var tag2Label: UILabel!
    @IBOutlet weak var storeInfoButton: UIButton!
    @IBOutlet weak var seeReviewButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bindEvents()
    }

    
    func bindEvents()
    {
        changeBtn.addTarget(WStoreInfoViewController(), action: #selector(WStoreInfoViewController.changeBtnDown(sender:)), for: .touchUpInside)

    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
