//
//  DDCardViewFooterCell.swift
//  Template
//
//  Created by Ingic on 7/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDCardViewFooterCell: UITableViewCell {

    @IBOutlet weak var footerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCardViewFooter(){
        self.footerButton.setTitle(" Add Credit Card Details", for: .normal)
    }
    
    func setAddressViewFooter(){
        self.footerButton.setTitle(" Add new address", for: .normal)
    }
    
    @IBAction func fotterButtonTapped(_ sender: Any) {
    }
}

protocol CustomFooterDelegate: class {
    func fotterButtonTapped()
}
