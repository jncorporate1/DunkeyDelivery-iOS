//
//  DDOrderScreenTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/11/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDOrderScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var paymentType: UILabel!
   // @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var addtionalNote: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var serviceFee: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var tipPercentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
