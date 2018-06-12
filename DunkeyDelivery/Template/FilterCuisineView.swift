//
//  FilterCuisineView.swift
//  Template
//
//  Created by Jamil Khan on 8/4/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol FilterCuisineViewDelegate {
    func sendSelectedCuisine(_ value: [String])
    func refreshView()
}

class FilterCuisineView: UIView {
    
    //MARK: - IBOutlet
    
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: -  Variables
    
    var view: UIView!
    var selectedCuisine = [String] ()
    var delegate: FilterCuisineViewDelegate!
    
    //MARK: - View Lifecyle
    
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
        addSubview(view)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        let colletionViewSecondCellNibName = UINib(nibName: "WineFilterMetaCollectionCell", bundle:nil)
        self.collectionView.register(colletionViewSecondCellNibName, forCellWithReuseIdentifier: "cell")
        self.collectionView.allowsMultipleSelection = true
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataOfCollectionView), name: NSNotification.Name(rawValue: "reloadCollectionViewCusine"), object: nil)
        
    }
    
    func getSelected() {
        let indexx = self.collectionView.indexPathsForSelectedItems
        selectedCuisine.removeAll()
        AppStateManager.sharedInstance.forSelectedItems.removeAll()
        for item in indexx!{
            let obj = AppStateManager.sharedInstance.cuisineObj [item.row]
            var value:String = obj.Tag!
            value = value.replacingOccurrences(of: " ", with: "")
            AppStateManager.sharedInstance.forSelectedItems.append(value)
            selectedCuisine.append(value)
        }
        delegate.sendSelectedCuisine(selectedCuisine)
    }

    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func reloadDataOfCollectionView(){
        self.collectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension FilterCuisineView : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppStateManager.sharedInstance.cuisineObj.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WineFilterMetaCollectionCell
        let item = AppStateManager.sharedInstance.cuisineObj [indexPath.row]
        cell.view.term.text = item.Tag
        let name = AppStateManager.sharedInstance.forSelectedItems
        if name.count > 0 {
            for itemss in name {
                let checkName = item.Tag?.replacingOccurrences(of: " ", with: "")
                if checkName == itemss {
                    cell.setUpColor(true)
                }
            }
        }
        else{
            cell.setUpColor(false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        getSelected()
    }
}

//MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension FilterCuisineView : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyIcon")
    }
    
    func title(forEmptyDataSet scrollView:
        UIScrollView!) -> NSAttributedString! {
        let text = "Oops!"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Cuisine(s) are currently available."//"Your streams will be visible here"
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.lightGray,
            NSParagraphStyleAttributeName: para
        ]
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
     let text = "Refresh"
     let attribs = [
     NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
     NSForegroundColorAttributeName: Constants.APP_COLOR
     ] as [String : Any]
     
     return NSAttributedString(string: text, attributes: attribs)
     }
     func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        delegate.refreshView()
     }
}
