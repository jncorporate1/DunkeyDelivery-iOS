//
//  CheckOutHeaderView.swift
//  Template
//
//  Created by zaidtayyab on 02/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
protocol checkOutHeaderViewDelegate {
    func deliverInfoTap()
    func creditCardTap()
    func paymentMethodTapped(value: Int)
    func setFrequencyTapped(value: Int)
    func creditCardInfoTap()
    func addNewAddress()
    func addNewCard()
}


class CheckOutHeaderView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var paypalButton: UIButton!
    @IBOutlet weak var oneTimeButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var addPaymentButton: UIButton!
    @IBOutlet weak var additionalNoteTextView: UITextView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var frequencyView: UIView!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var frequencyInnerView: UIView!
    @IBOutlet weak var frequencyLineView: UIView!
    @IBOutlet weak var frequencyHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var creditCardNumber: UILabel!
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet weak var creditCardMonth: UILabel!
    @IBOutlet weak var addnewAddressButton: UIButton!
    @IBOutlet weak var addnewCardButton: UIButton!
    @IBOutlet weak var deliveryInformationOutlet: UIButton!
    
    
    //MARK: - Variables
    
    var view: UIView!
    var delegate: checkOutHeaderViewDelegate!
    var setting : Setting!
    
    
    //MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    //MARK: - Helping Method
    
    func setOrderSummaryView(sum: OrderSummary){
        totalLabel.text = "$"+"\(sum.Total)"
        tipLabel.text = "$"+"\(sum.Tip)"
        subTotalLabel.text = "$"+"\(sum.SubTotalWDF)"
        taxLabel.text = "$"+"\(sum.Tax)"
        deliveryTime.text = "$"+"\(sum.DeliveryFee)"
    }
    
    func setUserAddress(address: String){
        self.addressLabel.text = address
    }
    
    func setUserCreditCard( card: String , month: String){
        if card != "N/A" {
            let crdlast4 = card.substring(from:card.index(card.endIndex, offsetBy: -4))
            self.creditCardNumber.text = "Ends with "+crdlast4
            self.creditCardMonth.text = month
        }else{
            self.creditCardNumber.text = card
            self.creditCardMonth.text = month
        }
    }
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
        setUpTextView()
        addnewAddressButton.isHidden = true
        addnewCardButton.isHidden = true
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func setUpTextView(){
        self.additionalNoteTextView.text = "Add Special Instructions"
        self.additionalNoteTextView.placeholderText = "Add Special Instructions"
        self.additionalNoteTextView.textColor = UIColor.lightGray
        self.additionalNoteTextView.delegate = self
    }
    
    
    //MARK: - Actions
    
    @IBAction func deliveryInfoTapped(_ sender: Any) {
        delegate.deliverInfoTap()
    }
    
    @IBAction func montlyTapped(_ sender: Any) {
        monthlyButton.backgroundColor = Constants.APP_COLOR
        monthlyButton.setTitleColor(UIColor.white, for: .normal)
        oneTimeButton.backgroundColor = UIColor.clear
        oneTimeButton.setTitleColor(UIColor.black, for: .normal)
        weeklyButton.backgroundColor = UIColor.clear
        weeklyButton.setTitleColor(UIColor.black, for: .normal)
        delegate.setFrequencyTapped(value: 2)
    }
    
    @IBAction func weeklyTapped(_ sender: Any) {
        weeklyButton.backgroundColor = Constants.APP_COLOR
        weeklyButton.setTitleColor(UIColor.white, for: .normal)
        oneTimeButton.backgroundColor = UIColor.clear
        oneTimeButton.setTitleColor(UIColor.black, for: .normal)
        monthlyButton.backgroundColor = UIColor.clear
        monthlyButton.setTitleColor(UIColor.black, for: .normal)
        delegate.setFrequencyTapped(value: 1)
    }
    
    @IBAction func oneTimeTapped(_ sender: Any) {
        oneTimeButton.backgroundColor = Constants.APP_COLOR
        oneTimeButton.setTitleColor(UIColor.white, for: .normal)
        weeklyButton.backgroundColor = UIColor.clear
        weeklyButton.setTitleColor(UIColor.black, for: .normal)
        monthlyButton.backgroundColor = UIColor.clear
        monthlyButton.setTitleColor(UIColor.black, for: .normal)
        delegate.setFrequencyTapped(value: 0)
    }
    
    @IBAction func cardTapped(_ sender: Any) {
        cardButton.backgroundColor = Constants.APP_COLOR
        cardButton.setTitleColor(UIColor.white, for: .normal)
        paypalButton.backgroundColor = UIColor.clear
        paypalButton.setTitleColor(UIColor.black, for: .normal)
        delegate.paymentMethodTapped(value: 0)
    }
    
    @IBAction func paypalTapped(_ sender: Any) {
        paypalButton.backgroundColor = Constants.APP_COLOR
        paypalButton.setTitleColor(UIColor.white, for: .normal)
        cardButton.backgroundColor = UIColor.clear
        cardButton.setTitleColor(UIColor.black, for: .normal)
        delegate.paymentMethodTapped(value: 1)
    }
    
    @IBAction func newCreditCardTapped(_ sender: Any) {
        delegate.creditCardTap()
    }
    
    @IBAction func creditCardButtonAction(_ sender: Any) {
        delegate.creditCardInfoTap()
    }
    
    @IBAction func addNewAddress(_ sender: Any) {
        delegate.addNewAddress()
    }
    
    @IBAction func addNewCard(_ sender: Any) {
        delegate.addNewCard()
    }
}

//MARK: - UITextViewDelegate

extension CheckOutHeaderView: UITextViewDelegate{
    
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
