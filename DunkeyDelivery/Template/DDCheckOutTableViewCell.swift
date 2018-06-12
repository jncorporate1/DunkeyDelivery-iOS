//
//  DDCheckOutTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/11/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDCheckOutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var paypalButton: UIButton!
    @IBOutlet weak var oneTimeButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var addPaymentButton: UIButton!
    @IBOutlet weak var additionalNoteTextView: UITextView!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpTextView(){
        self.additionalNoteTextView.text = "Add Special Instructions"
        self.additionalNoteTextView.placeholderText = "Add Special Instructions"
        self.additionalNoteTextView.textColor = UIColor.lightGray
        self.additionalNoteTextView.delegate = self
    }
    
    @IBAction func montlyTapped(_ sender: Any) {
        monthlyButton.backgroundColor = Constants.APP_COLOR
        monthlyButton.setTitleColor(UIColor.white, for: .normal)
        oneTimeButton.backgroundColor = UIColor.clear
        oneTimeButton.setTitleColor(UIColor.black, for: .normal)
        weeklyButton.backgroundColor = UIColor.clear
        weeklyButton.setTitleColor(UIColor.black, for: .normal)
    }
    @IBAction func weeklyTapped(_ sender: Any) {
        weeklyButton.backgroundColor = Constants.APP_COLOR
        weeklyButton.setTitleColor(UIColor.white, for: .normal)
        oneTimeButton.backgroundColor = UIColor.clear
        oneTimeButton.setTitleColor(UIColor.black, for: .normal)
        monthlyButton.backgroundColor = UIColor.clear
        monthlyButton.setTitleColor(UIColor.black, for: .normal)
    }
    @IBAction func oneTimeTapped(_ sender: Any) {
        oneTimeButton.backgroundColor = Constants.APP_COLOR
        oneTimeButton.setTitleColor(UIColor.white, for: .normal)
        weeklyButton.backgroundColor = UIColor.clear
        weeklyButton.setTitleColor(UIColor.black, for: .normal)
        monthlyButton.backgroundColor = UIColor.clear
        monthlyButton.setTitleColor(UIColor.black, for: .normal)
    }
    @IBAction func cardTapped(_ sender: Any) {
        cardButton.backgroundColor = Constants.APP_COLOR
        cardButton.setTitleColor(UIColor.white, for: .normal)
        paypalButton.backgroundColor = UIColor.clear
        paypalButton.setTitleColor(UIColor.black, for: .normal)
    }
    @IBAction func paypalTapped(_ sender: Any) {
        paypalButton.backgroundColor = Constants.APP_COLOR
        paypalButton.setTitleColor(UIColor.white, for: .normal)
        cardButton.backgroundColor = UIColor.clear
        cardButton.setTitleColor(UIColor.black, for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension DDCheckOutTableViewCell: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Special Instructions"
            textView.textColor = UIColor.lightGray
        }
    }
}
