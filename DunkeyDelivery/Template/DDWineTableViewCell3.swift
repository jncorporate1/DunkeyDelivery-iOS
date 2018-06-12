//
//  DDWineTableViewCell3.swift
//  Template
//
//  Created by Jamil Khan on 7/27/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

protocol DDWineCategoryDelegate {
    func seeAllTappped(storeID: Int, categoryID: Int, categoryName: String)
}
protocol DDWineCategoryCollectionDelegate {
    func alcoholCellTapped(item: ProductItem)
}

class DDWineTableViewCell3: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var categoryView: DDWineCategoryView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Varialbes
    
    var index = IndexPath()
    var product = [ProductItem]()
    var delegate: DDWineCategoryDelegate!
    var storeData = Category()
    var colDelegate: DDWineCategoryCollectionDelegate!
    var storeID = 0
    var categoryID = 0
    var categoryName = ""
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let colletionViewSecondCellNibName = UINib(nibName: "DDWineCollectionViewCell", bundle:nil)
        self.collectionView.register(colletionViewSecondCellNibName, forCellWithReuseIdentifier: "cell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helping Method
    
    func setUpData(product: [ProductItem], title: String, isMain: Bool) {
        self.product = product
        self.categoryView.categoryTitle.text = title.capitalized
        if isMain {
            if product.count > 1 {
                self.categoryView.sellAllCategories.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
                self.categoryView.sellAllCategories.isHidden = false
            } else {
                self.categoryView.sellAllCategories.isHidden = true
            }
        }
        collectionView.reloadData()
    }
    
    func viewEsssentials(storeID: Int, categoryID: Int, categoryName: String){
        self.storeID = storeID
        self.categoryID = categoryID
        self.categoryName = categoryName
    }
    
    func seeAllTapped(){
        delegate.seeAllTappped(storeID: storeID, categoryID: categoryID, categoryName: categoryName)
    }
}


//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DDWineTableViewCell3 : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if product.count == 0 {
           Utility.emptyCollectionViewMessage(message: "No Products Found", viewController: self, collectionView: collectionView)
            return 0
        }
        collectionView.backgroundView = UIView()
        return product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DDWineCollectionViewCell
        cell.dataView.title.text = product[indexPath.row].Name
        cell.dataView.detail.text = "Price $" + String(describing: product[indexPath.row].Price.value!)
        if let uri = product[indexPath.row].Image {
            let url = URL(string: Constants.ImageBaseURl + uri)
            cell.dataView.icon.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            }
           // else{
//            cell.dataView.icon.image = nil
//        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = product[indexPath.row]
        colDelegate.alcoholCellTapped(item: selectedItem)
        print(" Section: \(indexPath.section)\n Row: \(indexPath.row)")
    }
}
