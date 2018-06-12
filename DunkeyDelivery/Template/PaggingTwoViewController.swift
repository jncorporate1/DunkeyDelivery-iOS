//
//  PaggingTwoViewController.swift
//
//
//  Created by Ingic on 7/3/17.
//
//

import UIKit
import XLPagerTabStrip
class PaggingTwoViewController: UIViewController, IndicatorInfoProvider {
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "two")
    }
}

