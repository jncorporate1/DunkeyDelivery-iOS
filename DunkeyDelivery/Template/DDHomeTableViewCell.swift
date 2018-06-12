//
//  DDHomeTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/7/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationDisplacement: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var minOrder: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var starView: DDStarView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTags(tagArr: [String]){
        switch tagArr.count {
        case 0:
            tag1.isHidden = true
            tag2.isHidden = true
            tag3.isHidden = true

        case 1:
            tag1.text = "   \(tagArr[0])   "
            tag2.isHidden = true
            tag3.isHidden = true

        case 2:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.isHidden = true
        case 3:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.text = "   \(tagArr[2])   "

        case 4:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.text = "   \(tagArr[2])   "

        case 5:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.text = "   \(tagArr[2])   "
 
        default:
            break
        }
    }
}
