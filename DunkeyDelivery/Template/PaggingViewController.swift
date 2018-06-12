//
//  PaggingViewController.swift
//  Template
//
//  Created by Ingic on 7/3/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PaggingViewController: UIViewController, IndicatorInfoProvider {
    var itemInfo = IndicatorInfo(title: "View")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "two")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
