//
//  FirstViewController.swift
//  Template
//
//  Created by Ingic on 6/30/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

//import InteractiveSideMenu

class FirstViewController: UIViewController{
    @IBOutlet weak var menuItem6: tabSummaryView!
    @IBOutlet weak var menuItem5: tabSummaryView!
    @IBOutlet weak var menuItem4: tabSummaryView!
    @IBOutlet weak var menuItem3: tabSummaryView!
    @IBOutlet weak var menuItem2: tabSummaryView!
    @IBOutlet weak var menuItem1: tabSummaryView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var EmailField: DDTextView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        //setTabBarAppearence()
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void) // Swift 3 fix
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.setView()
        //EmailField.setFieldAsVerified()
        //EmailField.setLeftImage(named: "user")
//        EmailField.view.textField.text = "hello"
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
    }
    func setView(){
        let greyColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        self.menuItem1.menuTitle.textColor = UIColor.white
        self.menuItem1.setMenuItem(color: UIColor.orange, title: "Food", icon: "food_icon")
        self.menuItem2.setMenuItem(color: greyColor, title: "Alcohol", icon: "alcohol_icon")
        self.menuItem3.setMenuItem(color: greyColor, title: "Grocery", icon: "grocery_icon")
        self.menuItem4.setMenuItem(color: greyColor, title: "Laundry", icon: "laundry_icon")
        self.menuItem5.setMenuItem(color: greyColor, title: "Pharmacy", icon: "pharmacy_icon")
        self.menuItem6.setMenuItem(color: greyColor, title: "Retail", icon: "retail_icon")
    }
    func setTabBarAppearence(){
        let tabBar = self.tabBarController?.tabBar
        let numberOfItems = CGFloat((tabBar?.items!.count)!)
       //let tabBarItemSize = CGSize(width: (tabBar?.frame.width)! / numberOfItems, height: (tabBar?.frame.height)!)
        let tabBarItemSize = CGSize(width: (tabBar?.frame.width)! / numberOfItems, height: 50)
        tabBar?.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        // remove default border
        tabBar?.frame.size.width = self.view.frame.width + 4
        tabBar?.frame.origin.x = -2
        
    }
//    private func contentControllers() -> [MenuItemContentViewController] {
//        var contentList = [MenuItemContentViewController]()
//        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "First") as! MenuItemContentViewController)
//        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "Second") as! MenuItemContentViewController)
//        return contentList
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func menuItemSixButtonTapped(_ sender: Any) {
    }
    @IBAction func menuItemFiveButtonTapped(_ sender: Any) {
    }
    @IBAction func menuItemFourButtonTapped(_ sender: Any) {
    }
    @IBAction func menuItemThreeButtonTapped(_ sender: Any) {
    }
    @IBAction func menuItemTwoButtonTapped(_ sender: Any) {
    }
    @IBAction func menuItemOneButtonTapped(_ sender: Any) {
    }

}
extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! DDHomeCollectionViewCell
//        cell.summaryView.companyName.text = "hello"
        return cell
    }
}
extension FirstViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDRestaurantDetailViewController") as! DDRestaurantDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect : CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        //        let rect: CGRect = CGRect(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
