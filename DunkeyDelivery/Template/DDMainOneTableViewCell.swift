//
//  DDMainOneTableViewCell.swift
//  Template
//
//  Created by Ingic on 9/14/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDMainOneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var downArrow: UIButton!
    @IBOutlet weak var nearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setUpperView(){
        self.distanceButton.isHidden = true
        self.downArrow.isHidden = true
        self.distanceLabel.isHidden = true
    }
    func setDownView(){
        self.distanceButton.isHidden = false
        self.downArrow.isHidden = false
        self.distanceLabel.isHidden = false
        self.distanceButton.addTarget(self, action: #selector(distanceButtonTapped), for: .touchUpInside)
    }
    func distanceButtonTapped(){
    }
}
