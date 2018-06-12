//
//  DDOrderTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/26/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
protocol DDOrderTableViewCellDelegate {
    func eyeButtonTap(index: IndexPath)
    func deleteButtonTap(index: IndexPath)
}
class DDOrderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var deliveredLastBoxView: UIView!
    @IBOutlet weak var deliveredBarView: UIView!
    @IBOutlet weak var deliveredBoxView: UIView!
    @IBOutlet weak var shippedBoxView: UIView!
    @IBOutlet weak var shippedBarView: UIView!
    @IBOutlet weak var inProgressBarView: UIView!
    @IBOutlet weak var inProgessBoxView: UIView!
    @IBOutlet weak var initiatedBarView: UIView!
    @IBOutlet weak var initiatedBoxView: UIView!
    @IBOutlet weak var deliveredLabel: UILabel!
    @IBOutlet weak var shippedLabel: UILabel!
    @IBOutlet weak var inProgressLabel: UILabel!
    @IBOutlet weak var inititatedLabel: UILabel!
    @IBOutlet weak var deliveryStatus: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    
    
    var otherColor = UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0)
    var index = IndexPath()
    var delegate : DDOrderTableViewCellDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate.deleteButtonTap(index: self.index)
    }
    @IBAction func eyeButtonTapped(_ sender: Any) {
        delegate.eyeButtonTap(index: self.index)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setStatus(status: Int){
     /*   switch status {
        case 0:
            setInitiated()
            break
        case 1:
            setInProgress()
            break
        case 2:
            setShipped()
            break
        case 3:
            setDelivered()
            break
        default:
            break
        }*/
        
        if status == 0 ||  status == 1  || status == 2
        {setInitiated()}
        if status == 3 ||  status == 4  || status == 5
        {setInProgress()}
        if status == 6 ||  status == 7
        {setShipped()}
        if status == 8
        {setDelivered()}
        
    }
    func setDefaultStatus(){
        
    }
    
    func setInitiated(){
        self.deliveryStatus.text = "Initiated"
        self.inititatedLabel.textColor = Constants.APP_COLOR
        self.initiatedBoxView.backgroundColor = Constants.APP_COLOR
        self.initiatedBarView.backgroundColor = Constants.APP_COLOR
        /*self.inProgessBoxView.backgroundColor = otherColor
        self.inProgressBarView.backgroundColor = otherColor
        self.shippedBarView.backgroundColor = otherColor
        self.shippedBoxView.backgroundColor = otherColor
        self.deliveredBoxView.backgroundColor = otherColor
        self.deliveredBarView.backgroundColor = otherColor
        self.deliveredLastBoxView.backgroundColor = otherColor*/
    }
    func setInProgress(){
        self.deliveryStatus.text = "In Progress"
        self.inititatedLabel.textColor = Constants.APP_COLOR
        self.inProgressLabel.textColor = Constants.APP_COLOR
        self.initiatedBoxView.backgroundColor = Constants.APP_COLOR
        self.initiatedBarView.backgroundColor = Constants.APP_COLOR
        self.inProgessBoxView.backgroundColor = Constants.APP_COLOR
        self.inProgressBarView.backgroundColor = Constants.APP_COLOR
        /*self.shippedBarView.backgroundColor = otherColor
        self.shippedBoxView.backgroundColor = otherColor
        self.deliveredBoxView.backgroundColor = otherColor
        self.deliveredBarView.backgroundColor = otherColor
        self.deliveredLastBoxView.backgroundColor = otherColor*/
    }
    func setShipped(){
        self.deliveryStatus.text = "Shipped"
        self.inititatedLabel.textColor = Constants.APP_COLOR
        self.inProgressLabel.textColor = Constants.APP_COLOR
        self.shippedLabel.textColor = Constants.APP_COLOR
        self.initiatedBoxView.backgroundColor = Constants.APP_COLOR
        self.initiatedBarView.backgroundColor = Constants.APP_COLOR
        self.inProgessBoxView.backgroundColor = Constants.APP_COLOR
        self.inProgressBarView.backgroundColor = Constants.APP_COLOR
        self.shippedBarView.backgroundColor = Constants.APP_COLOR
        self.shippedBoxView.backgroundColor = Constants.APP_COLOR
        /*self.deliveredBoxView.backgroundColor = otherColor
        self.deliveredBarView.backgroundColor = otherColor
        self.deliveredLastBoxView.backgroundColor = otherColor*/
    }
    func setDelivered(){
        self.deliveryStatus.text = "Delivered"
        self.inititatedLabel.textColor = Constants.APP_COLOR
        self.inProgressLabel.textColor = Constants.APP_COLOR
        self.shippedLabel.textColor = Constants.APP_COLOR
        self.deliveredLabel.textColor = Constants.APP_COLOR
        self.initiatedBoxView.backgroundColor = Constants.APP_COLOR
        self.initiatedBarView.backgroundColor = Constants.APP_COLOR
        self.inProgessBoxView.backgroundColor = Constants.APP_COLOR
        self.inProgressBarView.backgroundColor = Constants.APP_COLOR
        self.shippedBarView.backgroundColor = Constants.APP_COLOR
        self.shippedBoxView.backgroundColor = Constants.APP_COLOR
        self.deliveredBoxView.backgroundColor = Constants.APP_COLOR
        self.deliveredBarView.backgroundColor = Constants.APP_COLOR
        self.deliveredLastBoxView.backgroundColor = Constants.APP_COLOR
    }
}
