//
//  WineFilterMetaCollectionCell.swift
//  Template
//
//  Created by Jamil Khan on 8/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class WineFilterMetaCollectionCell: UICollectionViewCell {
    
    //MARK: - IBoutlet
    
    @IBOutlet weak var view: WineFilterMetaCollectionCellView!
    
    //MARK:- Varaible
    
    var manger = AppStateManager.sharedInstance
    
    
    //MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCellView()
    }
    
    
    //MARK: -  Selection Method
    
    override var isSelected: Bool {
        didSet{
            if (isMultipleTouchEnabled) {
                if view.view.backgroundColor != Constants.APP_COLOR  {
                     setUpColor(true)
                }
                else {
                    setUpColor(false)
                }
            }
            else {
                if(isSelected){
                    setUpColor(true)
                }else{
                    setUpColor(false)
                }
            }
        }
    }
    
    func setUpCellView(){
        view.view.backgroundColor = UIColor.white
        view.term.textColor = UIColor.darkGray
    }

    func setUpColor(_ allowMuliple: Bool){
        if allowMuliple {
            view.view.backgroundColor = Constants.APP_COLOR
            view.term.textColor = UIColor.white
           // view.term.tintColor = UIColor.white
        }
        else {
            view.view.backgroundColor = UIColor.white
            view.term.textColor = UIColor.darkGray
            //view.term.tintColor = Constants.APP_COLOR
        }
    }
}
