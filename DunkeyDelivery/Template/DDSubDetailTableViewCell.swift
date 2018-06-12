//
//  DDSubDetailTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/10/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Hero

class DDSubDetailTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var address: UILabel!
   
    @IBOutlet weak var subAddress: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var popularView: UIImageView!
    @IBOutlet weak var popularLabel: UILabel!
    //Search by Product Outlets
    @IBOutlet weak var searchName: UILabel!
    @IBOutlet weak var searchDescription: UILabel!
    @IBOutlet weak var searchPrice: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPopular(){
        popularView.isHidden = false
        popularLabel.isHidden = false
    }
    
    func setNormal(){
        popularView.isHidden = true
        popularLabel.isHidden  = true
    }
}
