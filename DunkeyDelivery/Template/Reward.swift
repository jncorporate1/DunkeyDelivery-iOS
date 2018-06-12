//
//  Reward.swift
//  Template
//
//  Created by zaidtayyab on 15/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class Reward: Object {
    
    dynamic var Id: Int = -1
    dynamic var AmountAward:Double = -1
    dynamic var Description: String? = ""
    dynamic var PointsRequired: Double = -1
    dynamic var RewardPrize: RewardGift!
}


class RewardGift: Object {
    
    dynamic var Id: Int = -1
    dynamic var ImageUrl: String? = ""
    dynamic var Name: String? = ""
}
