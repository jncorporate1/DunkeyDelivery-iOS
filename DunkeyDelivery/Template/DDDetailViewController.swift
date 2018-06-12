//
//  DDDetailViewController.swift
//  Template
//
//  Created by Ingic on 7/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import MapKit
class DDDetailViewController: BaseController {
    
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var sunTime: UILabel!
    @IBOutlet weak var saturdayTime: UILabel!
    @IBOutlet weak var fridayTime: UILabel!
    @IBOutlet weak var thursdayTime: UILabel!
    @IBOutlet weak var wedTime: UILabel!
    @IBOutlet weak var tuesdayTime: UILabel!
    @IBOutlet weak var mondayTime: UILabel!
    @IBOutlet weak var phnNum: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var aboutStarView: DDStarView!
    @IBOutlet weak var tag5: UILabel!
    @IBOutlet weak var tag4: UILabel!
    @IBOutlet weak var tag3: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var restaurantViewHeight: NSLayoutConstraint!
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var starMedium5: DDStarMediumView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var starMedium4: DDStarMediumView!
    @IBOutlet weak var starMedium3: DDStarMediumView!
    @IBOutlet weak var starMedium2: DDStarMediumView!
    @IBOutlet weak var starLarge: DDStarLargeView!
    @IBOutlet weak var starMedium1: DDStarMediumView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progBar1: CustomProgressBar!
    @IBOutlet weak var progBar2: CustomProgressBar!
    @IBOutlet weak var progBar3: CustomProgressBar!
    @IBOutlet weak var progBar4: CustomProgressBar!
    @IBOutlet weak var progBar5: CustomProgressBar!
    
    
    //MARK: - Variable
    
    var storeRatingArray = [StoreRating]()
    var viewCellCheck = false
    var selectedTabPoint : CGPoint!
    var viewCheck = false
    var navigationTilte : String!
    var storeData : StoreItem!
    var deliveryTime : deliveryHours!
    let regionRadius: CLLocationDistance = 1000
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNavigationBar()
        if navigationTilte != nil{
            self.title = navigationTilte
        }
        else{
            self.title = storeData.BusinessName
        }
        getStoreDetail()
    }
    
    override func viewDidLayoutSubviews() {
        if (viewCheck){
            self.aboutTapped(UIButton())
            self.reviewButton.isSelected = false
            self.aboutButton.isSelected = true
        }
        else{
            self.reviewButton.isSelected = true
        }
        if (viewCellCheck){
            self.restaurantView.isHidden = true
            self.restaurantViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }
        else{
            self.restaurantView.isHidden = false
            self.restaurantViewHeight.constant = 90
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.homeNavigationBar()
        self.reviewButton.isSelected = false
        hideTabBarAnimated(hide:true)
    }
    
    //MARK: - Helping Method
    
    func setUpData(){
        companyName.text = storeData.BusinessName
        address.text = storeData.Address
        phnNum.text = storeData.ContactNumber
        self.aboutStarView.starSmall(items: Int(storeData.AverageRating))
        if storeData != nil{
            var tags = [String]()
            for tag in storeData.storeTags{
                tags.append(tag.Tag)
            }
            self.addTags(tagArr: tags)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(storeData.Latitude), longitude: CLLocationDegrees(storeData.Longitude))
        self.mapView.delegate = self
        self.mapView.addAnnotation(annotation)
        let location = CLLocation(latitude: (annotation.coordinate.latitude), longitude: (annotation.coordinate.longitude))
        centerMapOnLocation(location: location)
        addDeliveryHours()
    }
    
    func addTags(tagArr: [String]){
        switch tagArr.count {
        case 0:
            tag1.isHidden = true
            tag2.isHidden = true
            tag3.isHidden = true
            tag4.isHidden = true
            tag5.isHidden = true
        case 1:
            tag1.text = "   \(tagArr[0])   "
            tag2.isHidden = true
            tag3.isHidden = true
            tag4.isHidden = true
            tag5.isHidden = true
        case 2:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.isHidden = true
            tag4.isHidden = true
            tag5.isHidden = true
        case 3:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.text = "   \(tagArr[2])   "
            tag4.isHidden = true
            tag5.isHidden = true
        case 4:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.text = "   \(tagArr[2])   "
            tag4.text = "   \(tagArr[3])   "
            tag5.isHidden = true
        case 5:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.text = "   \(tagArr[2])   "
            tag4.text = "   \(tagArr[3])   "
            tag5.text = "   \(tagArr[4])   "
        default:
            break
        }
    }
    
    
    func addDeliveryHours(){
        
        if let deliveryHours = storeData.StoreDeliveryHours{
            self.fridayTime.text = self.getTime(from: deliveryHours.Friday_From, to: deliveryHours.Friday_To)
            self.mondayTime.text = self.getTime(from: deliveryHours.Monday_From, to: deliveryHours.Monday_To)
            self.tuesdayTime.text = self.getTime(from: deliveryHours.Tuesday_From, to: deliveryHours.Tuesday_To)
            self.wedTime.text = self.getTime(from: deliveryHours.Wednesday_From, to: deliveryHours.Wednesday_To)
            self.thursdayTime.text = self.getTime(from: deliveryHours.Thursday_From, to: deliveryHours.Thursday_To)
            self.saturdayTime.text = self.getTime(from: deliveryHours.Saturday_From, to: deliveryHours.Saturday_To)
            self.sunTime.text = self.getTime(from: deliveryHours.Sunday_From, to: deliveryHours.Sunday_To)
        }
    }
    
    func getTime(from: String, to: String)-> String{
        if !(from.isEmpty) && !(to.isEmpty){
            return from + " to " + to
        }
        else{
            return "Closed"
        }
    }
    
    func setAboutView(){
        self.scrollView.setContentOffset(CGPoint(x:self.view.frame.size.width ,y:0), animated: false)
        selectedTabPoint = CGPoint(x:self.view.frame.size.width , y: 0)
        
        reviewButton.isSelected = false
        aboutButton.isSelected = true
    }
    
    func setReviewLabel(){
        ratingLabel.text = "\(Int(storeData.AverageRating))" + " Rating"
        reviewLabel.text = "0 Review"
    }
    
    
    func setUpView(){
        starMedium1.starMedium(items: 5)
        starMedium2.starMedium(items: 4)
        starMedium3.starMedium(items: 3)
        starMedium4.starMedium(items: 2)
        starMedium5.starMedium(items: 1)
        progBar1.setProgress(value: storeData.RatingType.FiveStar, progValue: Float(storeData.RatingType.FiveStar))
        progBar1.count.text = "\(storeData.RatingType.FiveStar)"
        progBar2.setProgress(value: storeData.RatingType.FourStar, progValue: Float(storeData.RatingType.FourStar))
        progBar2.count.text = "\(storeData.RatingType.FourStar)"
        progBar3.setProgress(value: storeData.RatingType.ThreeStar, progValue: Float(storeData.RatingType.ThreeStar))
        progBar3.count.text = "\(storeData.RatingType.ThreeStar)"
        progBar4.setProgress(value: storeData.RatingType.TwoStar, progValue: Float(storeData.RatingType.TwoStar))
        progBar4.count.text = "\(storeData.RatingType.TwoStar)"
        progBar5.setProgress(value: storeData.RatingType.OneStar, progValue: Float(storeData.RatingType.OneStar))
        progBar5.count.text = "\(storeData.RatingType.OneStar)"
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK: - Action
    
    @IBAction func reviewTapped(_ sender: UIButton) {
        self.scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        selectedTabPoint = CGPoint(x: 0, y: 0)
        reviewButton.isSelected = true
        aboutButton.isSelected = false
    }
    
    @IBAction func aboutTapped(_ sender: UIButton) {
        self.scrollView.setContentOffset(CGPoint(x:self.view.frame.size.width ,y:0), animated: true)
        selectedTabPoint = CGPoint(x:self.view.frame.size.width , y: 0)
        
        reviewButton.isSelected = false
        aboutButton.isSelected = true
    }
}


//MARK: -  UITableViewDelegate, UITableViewDataSource

extension DDDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeRatingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! DDDetailTableViewCell
        let item = storeRatingArray[indexPath.row]
        cell.rankingDesc.text = item.Feedback
        cell.userName.text = item.User.FullName
        cell.starView.starSmall(items: item.Rating)
        cell.userDate.text = self.getDate(str: item.DateOfRating)//item.DateOfRating
        cell.userReviews.text = "\(item.User.TotalReviews)" + " reviews"
        cell.starView.smallCount.isHidden = true
        if (viewCellCheck){
            cell.orderView.isHidden = false
        }
        else{
            cell.orderView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


//MARK: - MKMapViewDelegate

extension DDDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let visibleRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 40.738045, 53.084488)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Location"
        mapView.addAnnotation(myAnnotation)
    }
}


//MARK: - Web Service

extension DDDetailViewController{
    func getStoreDetail(){
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let parameters: Parameters = [
            
            "storeId": String(storeData.Id)  //"\(storeData.Id)"
        ]
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                let responseResult = result["Result"] as! NSDictionary
                self.storeData = StoreItem(value: responseResult)
                self.starLarge.starLarge(items: Int(self.storeData.AverageRating))
                self.setUpData()
                self.setUpView()
                self.setReviewLabel()
                self.title = self.storeData.BusinessName
                self.tableView.reloadData()
                
            }else if(response?.intValue == 403){
                
                self.showErrorWith(message: "Error")
                
                return
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
            
        }
        APIManager.sharedInstance.getStoreInfo(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
