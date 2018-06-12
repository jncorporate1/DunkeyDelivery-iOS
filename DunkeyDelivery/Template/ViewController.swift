//
//  ViewController.swift
//  Template
//
//  Created by Ingic on 6/9/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit



class ViewController: UIViewController{
    @IBOutlet weak var viewLabel: UILabel!
    var textLabel : String!
    

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if textLabel != nil{
            self.viewLabel.text = textLabel
        }
        
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void) // Swift 3 fix
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
