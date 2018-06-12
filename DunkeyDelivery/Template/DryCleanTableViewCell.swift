//
//  DryCleanTableViewCell.swift
//  Template
//
//  Created by Ingic on 30/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class DryCleanTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var instruction: KMPlaceholderTextView!
    @IBOutlet weak var storeDescription: UILabel!
    @IBOutlet weak var addtobagOutlet: UIButton!
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
