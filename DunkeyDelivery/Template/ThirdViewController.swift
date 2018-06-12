//
//  ThirdViewController.swift
//  Template
//
//  Created by Ingic on 6/30/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class ThirdViewController: BaseController {
    
    
    //MARK: - IBoutlets
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var pointsEarned = 0
    
    //MARK: - Varaiables
    
    var revealController = SWRevealViewController()
    var tapGesture : UITapGestureRecognizer!
    var rewards = [Reward]()
    var redemCheck : Bool = false
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Delivery Points"
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> () -> Void)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabBarAnimated(hide: false)
        self.tabBarController?.tabBar.tag = 2
        setViewToggle()
        getRewardPrize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    func setViewToggle(){
        self.revealViewController().delegate = self
        self.tapGesture = UITapGestureRecognizer(target: self.revealViewController(), action: #selector(revealViewController().rightRevealToggle(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.tapGesture.isEnabled = false
        self.view.addGestureRecognizer(revealController.panGestureRecognizer())
    }

    //MARK: - Action
    
    func redeeemTapped(sender: UIButton){
        let isEnable = rewards[sender.tag].PointsRequired
          if pointsEarned >= Int(isEnable){
            let item = self.rewards[sender.tag]
            self.redeemPrize(rewId: item.Id)
        }

        else{
            self.showErrorWith(message: "You don't have enough points to redeem this reward.")
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension ThirdViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5{
            return self.rewards.count
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath) as! DDPointsTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTwo", for: indexPath) as! DDPointsTableViewCell
            cell.pointView.setPoints(points: pointsEarned)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellThree", for: indexPath) as! DDPointsTableViewCell
            cell.setUpProgressBar(value: Float(self.pointsEarned))
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFour", for: indexPath) as! DDPointsTableViewCell
            cell.selectionStyle = .none
            cell.bringLabelFront()
            return cell
        }
        else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFive", for: indexPath) as! DDPointsTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else {
            let item = self.rewards[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellSix", for: indexPath) as! DDPointsTableViewCell
            if item.RewardPrize != nil{
                cell.rewardCashView.isHidden = true
                cell.rewardPrizeView.isHidden = false
                let url = item.RewardPrize.ImageUrl?.getURL()
                cell.rewardPrizeView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            }
            else{
                cell.rewardCashView.isHidden = false
                cell.rewardPrizeView.isHidden = true
                cell.redemPriceLabel.text = "\(Int(item.AmountAward))"
            }
            if pointsEarned >= Int(item.PointsRequired){
                redemCheck = true
               // cell.redeemButton.isUserInteractionEnabled = true
                cell.redeemButton.setBackgroundColor(Constants.APP_COLOR, for: .normal)
            }
            else{
                redemCheck = false
                //cell.redeemButton.isUserInteractionEnabled = false
                cell.redeemButton.setBackgroundColor(UIColor.lightGray, for: .normal)
            }
            cell.redeemButton.tag = indexPath.row
            cell.redeemButton.addTarget(self, action: #selector(redeeemTapped(sender:)), for: .touchUpInside)
            cell.redemPointLabel.text = "\(Int(item.PointsRequired))"+" Points Reward"
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 80
        }
        else if indexPath.section == 1{
            return 124
        }
        else if indexPath.section == 2{
            return 124
        }
        else if indexPath.section == 3{
            return 259
        }
        else if indexPath.section == 4{
            return 48
        }
        else{
            return 220
        }
    }
}

//MARK: - SWRevealViewControllerDelegate

extension ThirdViewController: SWRevealViewControllerDelegate{
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPosition.right{
            self.tapGesture.isEnabled = true
            self.view.isUserInteractionEnabled = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
        else if position == FrontViewPosition.left{
            self.tapGesture.isEnabled = false
            self.view.isUserInteractionEnabled = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
    }
}

//MARK:- Web Service

extension ThirdViewController {
    
    func getRewardPrize(){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let parameters: Parameters = [
            
            "UserID":"\(AppStateManager.sharedInstance.loggedInUser.Id)"
        ]
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                if self.rewards.count != 0{
                    self.rewards.removeAll()
                }
                let responseResult = result["Result"] as! NSDictionary
                let userPoints = responseResult["UserPoints"] as! NSDictionary
                self.pointsEarned = userPoints["RewardPoints"] as! Int
                let rewards = responseResult["Rewards"] as! NSArray
                for item in rewards{
                    let rewObj = item as! NSDictionary
                    let rew = Reward(value: rewObj)
                    self.rewards.append(rew)
                }
                self.tableView.reloadData()
            }
            else if(response?.intValue == 403){
                
                self.showErrorWith(message: "Error")
                
                return
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
                
            }
        }
        APIManager.sharedInstance.getRewardPrizes(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
            
        }
        
    }
    func redeemPrize(rewId: Int){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let parameters: Parameters = [
            
            "UserID":"\(AppStateManager.sharedInstance.loggedInUser.Id)",
            "RewardID":"\(rewId)"
        ]
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.showSuccessWith(message: "Reward redeemed successfully.")
                self.getRewardPrize()
            }
            else if(response?.intValue == 403){
                
                self.showErrorWith(message: "Error")
                
                return
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
                
            }
        }
        APIManager.sharedInstance.redeemPrize(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
            
        }
        
    }
}

