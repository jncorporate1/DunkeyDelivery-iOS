//
//  PointsEarnedView.swift
//  Template
//
//  Created by zaidtayyab on 15/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

class PointsEarnedView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var pointSix: UIButton!
    @IBOutlet weak var pointFive: UIButton!
    @IBOutlet weak var pointFour: UIButton!
    @IBOutlet weak var pointThree: UIButton!
    @IBOutlet weak var pointOne: UIButton!
    @IBOutlet weak var pointTwo: UIButton!
    
    
    //MARK: - Variables
    
    var view: UIView!
    
    
    //MARK: - View Lifecycle
    
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
    }
    
    func setPoints(points: Int){
        let pointsArr = points.array
        switch pointsArr.count {
        case 0:
            viewWidth.constant =  60
            pointOne.isHidden = false
            pointTwo.isHidden = true
            pointThree.isHidden = true
            pointFour.isHidden = true
            pointFive.isHidden = true
            pointSix.isHidden = true
            break
        case 1:
            viewWidth.constant =  60
            pointOne.setTitle("\(pointsArr[0])", for: .normal)
            pointOne.isHidden = false
            pointTwo.isHidden = true
            pointThree.isHidden = true
            pointFour.isHidden = true
            pointFive.isHidden = true
            pointSix.isHidden = true
            break
        case 2:
            viewWidth.constant = 120
            pointOne.setTitle("\(pointsArr[0])", for: .normal)
            pointTwo.setTitle("\(pointsArr[1])", for: .normal)
            pointOne.isHidden = false
            pointTwo.isHidden = false
            pointThree.isHidden = true
            pointFour.isHidden = true
            pointFive.isHidden = true
            pointSix.isHidden = true
            break
        case 3:
            viewWidth.constant = 180
            pointOne.setTitle("\(pointsArr[0])", for: .normal)
            pointTwo.setTitle("\(pointsArr[1])", for: .normal)
            pointThree.setTitle("\(pointsArr[2])", for: .normal)
            pointOne.isHidden = false
            pointTwo.isHidden = false
            pointThree.isHidden = false
            pointFour.isHidden = true
            pointFive.isHidden = true
            pointSix.isHidden = true
            break
        case 4:
            viewWidth.constant = 240
            pointOne.setTitle("\(pointsArr[0])", for: .normal)
            pointTwo.setTitle("\(pointsArr[1])", for: .normal)
            pointThree.setTitle("\(pointsArr[2])", for: .normal)
            pointFour.setTitle("\(pointsArr[3])", for: .normal)
            pointOne.isHidden = false
            pointTwo.isHidden = false
            pointThree.isHidden = false
            pointFour.isHidden = false
            pointFive.isHidden = true
            pointSix.isHidden = true
            break
        case 5:
            viewWidth.constant = 300
            pointOne.setTitle("\(pointsArr[0])", for: .normal)
            pointTwo.setTitle("\(pointsArr[1])", for: .normal)
            pointThree.setTitle("\(pointsArr[2])", for: .normal)
            pointFour.setTitle("\(pointsArr[3])", for: .normal)
            pointFive.setTitle("\(pointsArr[4])", for: .normal)
            pointOne.isHidden = false
            pointTwo.isHidden = false
            pointThree.isHidden = false
            pointFour.isHidden = false
            pointFive.isHidden = false
            pointSix.isHidden = true
            break
        case 6:
            viewWidth.constant = 360
            pointOne.setTitle("\(pointsArr[0])", for: .normal)
            pointTwo.setTitle("\(pointsArr[1])", for: .normal)
            pointThree.setTitle("\(pointsArr[2])", for: .normal)
            pointFour.setTitle("\(pointsArr[3])", for: .normal)
            pointFive.setTitle("\(pointsArr[4])", for: .normal)
            pointSix.setTitle("\(pointsArr[5])", for: .normal)
            pointOne.isHidden = false
            pointTwo.isHidden = false
            pointThree.isHidden = false
            pointFour.isHidden = false
            pointFive.isHidden = false
            pointSix.isHidden = false
            break
        default:
            break
        }
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}


//MARK: -

extension Int {
    var array: [Int] {
        return String(self).characters.flatMap{ Int(String($0)) }
    }
}
