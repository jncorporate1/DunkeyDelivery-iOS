//
//  DDLaundryTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/29/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDLaundryTableViewCell: UITableViewCell {

    @IBOutlet weak var laundrySubmitButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tailoringButton: UIButton!
    @IBOutlet weak var dryCleanerButton: UIButton!
    @IBOutlet weak var washFoldButton: UIButton!
    @IBOutlet weak var washNfoldView: UIView!
    @IBOutlet weak var washNfoldViewWidth: NSLayoutConstraint!
    @IBOutlet weak var dryCleanView: UIView!
    @IBOutlet weak var dryCleanViewWidth: NSLayoutConstraint!
    @IBOutlet weak var tailoringView: UIView!
    @IBOutlet weak var tailoringViewWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
