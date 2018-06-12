//
//  DDAddToBagTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/10/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

protocol DDAddToBagTableViewCellDelegate {
    func checkMinOrder(value:String)
}

class DDAddToBagTableViewCell: SWRevealTableViewCell {
    
    @IBOutlet weak var storePrice: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDes: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var minimunOrderPrice: UILabel!
    @IBOutlet weak var minOrderImage: UIImageView!
    @IBOutlet weak var additemButton: UIButton!
    @IBOutlet weak var deliveryScheduleButton: UIButton!
    
    var addBagdelegate: DDAddToBagTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
