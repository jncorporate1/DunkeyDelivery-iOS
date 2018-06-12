//
//  DDWineAllCategoriesTableViewCell.swift
//  Template
//
//  Created by Jamil Khan on 7/31/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
protocol DDWineAllCategoriesDelegate {
    func productCellTapped(item: ProductItem)
}
class DDWineAllCategories: UIView {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet  var title: UILabel!
    
    //MARK: - Variable
    
    var delegate: DDWineAllCategoriesDelegate!
    var collectionData = [ProductItem]()
    var view: UIView!
    
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    //MARK: - Helping Method
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask
            = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        collectionView.delegate = self
        collectionView.dataSource = self
        let colletionViewSecondCellNibName = UINib(nibName: "DDWineAllCategoriesCollectionViewCell", bundle:nil)
        self.collectionView.register(colletionViewSecondCellNibName, forCellWithReuseIdentifier: "cell")
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func setupData(productData: [ProductItem]) {
        collectionData = productData
        self.collectionView.reloadData()
    }
}

//MARK: -  UICollectionViewDataSource, UICollectionViewDelegate

extension DDWineAllCategories : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DDWineAllCategoriesCollectionViewCell
        let data = collectionData[indexPath.row]
        let url = data.Image?.getURL()
        cell.itemView.icon.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
        cell.itemView.title.text = data.Name
        cell.itemView.detail.text = "$ \(data.Price.value!)"
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = collectionData[indexPath.row]
        delegate.productCellTapped(item: selectedItem)
    }
    
    /*func itemDetailButtonDown(data: ProductItem) {
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SingleWineViewController") as! SingleWineViewController
        controller.productData = data
        self.navigationController?.pushViewController(controller, animated: true)
    }*/
}
