//
//  DDPointsTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/12/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDPointsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var redeemButton: UIButton!
    @IBOutlet weak var rewardPrizeView: UIImageView!
    @IBOutlet weak var rewardCashView: UIView!
    @IBOutlet weak var redemPriceLabel: UILabel!
    @IBOutlet weak var redemPointLabel: UILabel!
    @IBOutlet weak var pointView: PointsEarnedView!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var oneLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bringLabelFront(){
        self.bringSubview(toFront: oneLabel)
        self.bringSubview(toFront: twoLabel)
        self.bringSubview(toFront: threeLabel)
    }
    
    @IBAction func redeemTapped(_ sender: Any) {
    }
    
    func setUpProgressBar(value: Float){
        let totalSize: Float = 500000
        self.progressBar.progress = value/totalSize
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
