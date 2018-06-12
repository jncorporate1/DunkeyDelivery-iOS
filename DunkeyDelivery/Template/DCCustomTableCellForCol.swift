//
//  DCCustomTableCellForCol.swift
//  Template
//
//  Created by Jamil Khan on 8/2/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import GMStepper
import Realm
import RealmSwift

protocol DCCustomTableCellForColDelegate {
    func stepperValueChanged(value:Int , indexPath:IndexPath)
}

@IBDesignable
class DCCustomTableCellForCol: UITableViewCell {
    
    //MARK: - IBoutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    
    var delegate:DCCustomTableCellForColDelegate!
    var selectionHandler = [Int: Bool]()
    var observerContext = 0
    var cellCheck = false
    var nameArray = [String] ()
    let selectedImages : [Int: String] = [0: "pants_selected_icon", 1 :"top_selected_icon", 2:"sweater_selected_icon", 3:"tie_selected_icon", 4:"shorts_selected_icon", 5:"comforter_selected_icon", 6:"blanket_selected_icon", 7:"cover_selected_icon", 8:"cover_selected_icon", 9:"skirt_selected_icon", 10:"jacket_selected_icon", 11:"suit_selected_icon", 12:"skirt_selected_icon", 13:"coat_selected_icon", 14:"sweater_selected_icon", 15:"scarf_selected_icon", 16:"shorts_selected_icon"]
    let unselectedImages : [Int: String] = [0: "pants_unselected_icon", 1 :"top_unselected_icon", 2:"sweater_unselected_icon", 3:"tie_unselected_icon", 4:"shorts_unselected_icon", 5:"comforter_unselected_icon", 6:"blanket_unselected_icon", 7:"cover_unselected_icon", 8:"cover_unselected_icon", 9:"skirt_unselected_icon", 10:"jacket_unselected_icon", 11:"suit_unselected_icon", 12:"skirt_unselected_icon", 13:"coat_unselected_icon", 14:"sweater_unselected_icon", 15:"scarf_unselected_icon", 16:"shorts_unselected_icon"]
    let names = ["Pants","Blouse/Top","Sweater","Tie","Shorts","Comforter","Blanket","Dauvet Cover","Pillow Case","Dress","Jacket","Suit","Skirt","Coat","Sweater","Scarf","Shorts"]
    
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        bindNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helping Method
    
    func bindNib(){
        let colletionViewSecondCellNibName = UINib(nibName: "DCCollectionCell", bundle:nil)
        self.collectionView.register(colletionViewSecondCellNibName, forCellWithReuseIdentifier: "cell")
    }
}


//MARK: -  UICollectionViewDataSource, UICollectionViewDelegate

extension DCCustomTableCellForCol : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dryCleanProduct.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DCCollectionCell
        let item = dryCleanProduct[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.view.selectedImageName = item.Image_Selected //selectedItemizeImages[indexPath.row]
        cell.view.imageName = item.Image //unseletedItemizeImages[indexPath.row]
        cell.view.isCellValueChanged = false
        cell.view.selectedLaudaryProduct =  item
        cell.view.updateCellUI()
        cell.view.title.text = item.Name //sendNameArray[indexPath.row]
        return cell;
    }
}

//MARK: - DCCollectionCellDelegate

extension DCCustomTableCellForCol: DCCollectionCellDelegate{
    func stepperValueChanged(value: Int, indexPath: IndexPath) {
        delegate.stepperValueChanged(value: value,indexPath: indexPath)
    }
}
