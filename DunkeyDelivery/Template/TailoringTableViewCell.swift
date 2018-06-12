//
//  TailoringTableViewCell.swift
//  Template
//
//  Created by Ingic on 30/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class TailoringTableViewCell: UITableViewCell {

    //MARK: - IBOutlet
    
    @IBOutlet weak var storeDescription: UILabel!
    @IBOutlet weak var instruction: KMPlaceholderTextView!
    @IBOutlet weak var addToBagOutlet: UIButton!
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
