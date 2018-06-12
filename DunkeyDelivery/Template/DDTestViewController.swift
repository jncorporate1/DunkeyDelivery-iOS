//
//  DDTestViewController.swift
//  Template
//
//  Created by Ingic on 7/31/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import HTagView

class DDTestViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var medicationTextField: DDSimpleTextField!
    @IBOutlet weak var tagView: HTagView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: - Variable
    
    var tagView2_data = [String]()
    var uiColorArray = [UIColor]()
    var tagIndex : Int!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagIndex = 0
        tagView.delegate = self
        tagView.dataSource = self
        tagView.multiselect = false
        tagView.marg = 5
        tagView.btwTags = 5
        tagView.btwLines = 5
        tagView.tagMainTextColor = UIColor.white
        tagView.tagSecondBackColor = UIColor.lightGray
        tagView.tagSecondTextColor = UIColor.darkText
        tagView.tagCornerRadiusToHeightRatio = 0.3
        tagView.reloadData()
        medicationTextField.rightButton.addTarget(self, action: #selector(addTag), for: .touchUpInside)
        setColorArray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    func addTag(){
        self.tagView2_data.append(medicationTextField.textField.text!)
        self.tagView.reloadData()
    }
    
    func setColorArray(){
        self.uiColorArray.append(UIColor(red:0.91, green:0.43, blue:0.18, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.09, green:0.58, blue:0.81, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.61, green:0.41, blue:0.68, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.85, green:0.30, blue:0.36, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.51, green:0.72, blue:0.28, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.87, green:0.65, blue:0.00, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.11, green:0.64, blue:0.69, alpha:1.0))
    }
}


//MARK: - HTagViewDelegate, HTagViewDataSource

extension DDTestViewController : HTagViewDelegate, HTagViewDataSource {
    
    func numberOfTags(_ tagView: HTagView) -> Int {
        return tagView2_data.count
    }
    
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        if index <= 6{
            
            tagView.tagMainBackColor = self.uiColorArray[index]
            
        }
        else if index <= 12{
            let i = index / 2
            tagView.tagMainBackColor = self.uiColorArray[i]
        }
        else{
            tagView.tagMainBackColor = Constants.APP_COLOR
        }
        
        
        return tagView2_data[index]
    }
    
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        return .cancel
    }
    
    func tagView(_ tagView: HTagView, tagWidthAtIndex index: Int) -> CGFloat {
        return 0.0
    }
    
    func tagView(_ tagView: HTagView, tagSelectionDidChange selectedIndices: [Int]) {
        print("tag with indices \(selectedIndices) are selected")
    }
    func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int) {
        print("tag with index: '\(index)' has to be removed from tagView")
        tagView2_data.remove(at: index)
        tagView.reloadData()
    }
    
}
