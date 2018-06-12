//
//  DDAddPaymentViewController.swift
//  Template
//
//  Created by Ingic on 8/4/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDAddPaymentViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variable
    
    var menuIcons = [String]()
    var menuTitles = [String]()
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMenuItems()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Payment Method"
        self.addBackButtonToNavigationBar()
        self.view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Helping Method
    
    func setMenuItems(){
        self.menuIcons.append("credit_card_icon")
        self.menuIcons.append("paypal_icon")
        self.menuTitles.append("Credit Card")
        self.menuTitles.append("Paypal")
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension DDAddPaymentViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DDAddPaymentTableViewCell
        let item = self.menuTitles[indexPath.row]
        let icon = self.menuIcons[indexPath.row]
        cell.menuIcon.image = UIImage(named: icon)
        cell.menuTitle.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DDAddCreditCardViewController") as! DDAddCreditCardViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
