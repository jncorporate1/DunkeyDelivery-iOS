//
//  DDCardTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardSubDetail: DDLabel!
    @IBOutlet weak var cardDetail: DDLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
