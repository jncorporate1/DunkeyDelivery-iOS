//
//  DDMainCollectionCell.swift
//  Template
//
//  Created by Ingic on 9/14/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

protocol DDMainCollectionViewDelegate {
    func collectionRowSelect(data: StoreItem)
//    func openFilter()
    //    func setTableHeight()
}

class DDMainCollectionCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var viewValue = ""
    var foodArray = [StoreItem]()
    var groceryArray = [StoreItem]()
    var laundryArray = [StoreItem]()
    var pharmacyArray = [StoreItem]()
    var retailArray = [StoreItem]()
    var delegate: DDMainCollectionViewDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCollectionCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func registerCollectionCell(){
        let colletionViewSecondCellNibName = UINib(nibName: "DDHomeCollectionViewSecondCell", bundle:nil)
        self.collectionView.register(colletionViewSecondCellNibName, forCellWithReuseIdentifier: "secondCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

    }
    func didSelectMenu(sender: UIButton){
        let index = sender.tag
        var storeData = StoreItem()
        switch viewValue {
        case "Restaurants":
            storeData = foodArray[index]
        case "Grocery":
            storeData = groceryArray[index]
        case "Laundry":
            storeData = laundryArray[index]
        case "Pharmacy":
            storeData = pharmacyArray[index]
        case "Retail":
            storeData = retailArray[index]
            
        default:
            break
        }
        self.rowSelect(storeData: storeData)
    }
    func rowSelect(storeData: StoreItem){
        delegate.collectionRowSelect(data: storeData)
    }
    func setFoodArray(array: [StoreItem]){
        self.foodArray = array
        self.collectionView.reloadData()
    }
    func setGroceryArray(array : [StoreItem]){
        self.groceryArray = array
        self.collectionView.reloadData()
    }
    func setLaundryArray(array: [StoreItem]){
        self.laundryArray = array
        self.collectionView.reloadData()
    }
    func setPharmacyArray(array: [StoreItem]){
        self.pharmacyArray = array
        self.collectionView.reloadData()
    }
    func setRetailArray(array: [StoreItem]){
        self.retailArray = array
        self.collectionView.reloadData()
    }
}
extension DDMainCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewValue {
        case "Restaurants":
            print("food")
            return foodArray.count
        case "Grocery":
            print("grocery")
            return groceryArray.count
        case "Laundry":
            print("laundry")
            return laundryArray.count
        case "Pharmacy":
            print("pharmacy")
            return pharmacyArray.count
        case "Retail":
            print("retail")
            return retailArray.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewValue {
        case "Restaurants":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            let foodItem = foodArray[indexPath.row]
            let url = foodItem.ImageUrl?.getURL()
            cell.summaryView.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.summaryView.companyName.text = foodItem.BusinessName
            let rating = Int (foodItem.AverageRating)
            cell.summaryView.starView.starSmall(items: rating)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
            
        case "Grocery":
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            let groceryItem = groceryArray[indexPath.row]
            let url = groceryItem.ImageUrl?.getURL()
            cell.summaryView.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.summaryView.companyName.text = groceryItem.BusinessName
            let rating = Int (groceryItem.AverageRating)
            cell.summaryView.starView.starSmall(items: rating)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        case "Laundry":
            print("laundry")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            let laundryItem = laundryArray[indexPath.row]
            let url = laundryItem.ImageUrl?.getURL()
            cell.summaryView.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.summaryView.companyName.text = laundryItem.BusinessName
            let rating = Int (laundryItem.AverageRating)
            cell.summaryView.starView.starSmall(items: rating)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        case "Pharmacy":
            print("pharmacy")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            let pharmacyItem = pharmacyArray[indexPath.row]
            let url = pharmacyItem.ImageUrl?.getURL()
            cell.summaryView.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.summaryView.companyName.text = pharmacyItem.BusinessName
            let rating = Int (pharmacyItem.AverageRating)
            cell.summaryView.starView.starSmall(items: rating)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        case "Retail":
            print("retail")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            let retailItem = retailArray[indexPath.row]
            let url = retailItem.ImageUrl?.getURL()
            cell.summaryView.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.summaryView.companyName.text = retailItem.BusinessName
            let rating = Int (retailItem.AverageRating)
            cell.summaryView.starView.starSmall(items: rating)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DDHomeCollectionViewCell
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        }
    }
}
