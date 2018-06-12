//
//  DCCustomTableCellForCol.swift
//  Template
//
//  Created by Jamil Khan on 8/2/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

protocol DCTailoringTableCellForColDelegate {
     func stepperValueChanged(value:Int , indexPath:IndexPath)
}

@IBDesignable
class DCTailoringTableCellForCol: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Variables
    
    var delegate:DCTailoringTableCellForColDelegate!
    var selectedImages = ["hemming_selected_icon","button_selected_icon","patch_selected_icon","zipper_selected_icon"]
    var unSelectedImages = ["hemming_unselected_icon","button_icon","patch_unselected_icon","zipper_unselected_icon"]
    var name = ["Hemming","Button","Patch","Zipper"]
    
    //MARK: - View lifecyle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        bindNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.collectionView.reloadData()
        super.setSelected(selected, animated: animated)
    }
    
    func bindNib(){
        let colletionViewSecondCellNibName = UINib(nibName: "DCCollectionCell", bundle:nil)
        self.collectionView.register(colletionViewSecondCellNibName, forCellWithReuseIdentifier: "cell")
    }
}


//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DCTailoringTableCellForCol : UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tailorProduct.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DCCollectionCell
        let item = tailorProduct[indexPath.row]
        cell.view.selectedImageName = item.Image_Selected//tailorSelectedImage[indexPath.row]
        cell.view.imageName = item.Image//tailorUnSelectedImage[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.view.isCellValueChanged = false
        cell.view.selectedLaudaryProduct = item
        cell.view.updateCellUI()
        cell.view.title.text = item.Name //tailorNameArray[indexPath.row]
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //    NotificationCenter.default.post(name: Notification.Name("collectionViewItem"), object: nil)
    }
}

//MARK: - DCCollectionCellDelegate

extension DCTailoringTableCellForCol: DCCollectionCellDelegate{
    func stepperValueChanged(value: Int, indexPath: IndexPath) {
        delegate.stepperValueChanged(value: value,indexPath: indexPath)
    }
}
