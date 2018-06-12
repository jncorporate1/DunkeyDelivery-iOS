//
//  DDDealAndPromotionsViewController.swift
//  Template
//
//  Created by zaidtayyab on 27/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Alamofire
import DZNEmptyDataSet
import NYAlertViewController
import  Hero
import Kingfisher

class DDDealAndPromotionsViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Variable
    
    var offerPackageArray = [OfferPackage]()
    var productObj = ProductItem()
    var refresher:UIRefreshControl!
    var packageProductArray = [PackageProduct]()

    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Deals and Promotions"
        addBackButtonToNavigationBar()
        self.hideTabBarAnimated(hide: true)
        setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOfferPackage()
    }
    
    //MARK: - Helping Method
    
    func setUpView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        setNavigationRightItems()
        registerCollectionCell()
        setUpCollectionViewLayOut()
        setUpRefreshController()
    }
    
    
    func setUpRefreshController(){
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = Constants.APP_COLOR
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
    }
    
    func loadData() {
        getOfferPackage()
        stopRefresher()
    }
    
    func stopRefresher() {
        self.refresher.endRefreshing()
    }
    
    func registerCollectionCell(){
        let colletionViewSecondCellNibName = UINib(nibName: "DDDealCollectionViewCell", bundle:nil)
        self.collectionView.register(colletionViewSecondCellNibName, forCellWithReuseIdentifier: "dealCell")
        self.collectionView.backgroundColor = UIColor.white
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
    
    func setUpCollectionViewLayOut(){
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: 450, height: 180)
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        _flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        _flowLayout.minimumInteritemSpacing = 0.0
        self.collectionView.collectionViewLayout = _flowLayout
    }
    
    func setNavigationRightItems(){
        let cartItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cart_icon"), style: .plain, target: self, action: #selector(showCart))
        self.navigationItem.rightBarButtonItems = [cartItem]
        
    }
    
    func showCart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func addValueToProduct(offerProObj: OfferPackage){
        productObj.quantity = 0
        productObj.ItemId = 3
        productObj.Id = offerProObj.Id
        productObj.Name = offerProObj.Offer?.Name
        productObj.Image = offerProObj.Offer?.ImageUrl
        productObj.Store_id = (offerProObj.Offer?.Store_Id)!
        productObj.Price.value = (offerProObj.Price.value!)
        productObj.Description = offerProObj.Offer?.Description
        productObj.Category_Id = (packageProductArray[0].Product?.Category_Id)!
        productObj.BusinessName = offerProObj.Offer?.Store?.BusinessName
        productObj.BusinessType = offerProObj.Offer?.Store?.BusinessType
        productObj.MinOrderPrice.value = (offerProObj.Offer?.Store?.MinOrderPrice.value!)!
        productObj.MinDeliveryCharges.value = (offerProObj.Offer?.Store?.MinDeliveryCharges.value)!
        productObj.MinDeliveryTime.value = Double ((offerProObj.Offer?.Store?.MinDeliveryTime.value)!)
    }
    
    func goToNextView(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDProductViewController") as! DDProductViewController
        vc.product = productObj
        vc.isViewDealnPromotion = true
        vc.packageProduct = packageProductArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - UICollectionViewDataSource

extension DDDealAndPromotionsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offerPackageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealCell", for: indexPath) as! DDDealCollectionViewCell
        cell.contentView.backgroundColor = UIColor.white
        let item = offerPackageArray[indexPath.row]


        let url = item.Offer?.ImageUrl?.getURL()
        if url != nil {
            cell.dealImage.contentMode = .scaleToFill
        }
        else{
            cell.dealImage.contentMode = .scaleAspectFit
        }
      //  let resource = ImageResource(downloadURL: url!, cacheKey: "deal_Image_cashe")
      //  cell.dealImage.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "logo_icon"))
        cell.dealImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
        return cell
    }
}


//MARK: - UICollectionViewDelegate

extension DDDealAndPromotionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = offerPackageArray[indexPath.row]
        addValueToProduct(offerProObj: item)
        goToNextView()
    }
}


//MARK: - Web Service

extension DDDealAndPromotionsViewController{
    
    func getOfferPackage(){
        
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [:]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                if self.offerPackageArray.count != 0{
                    self.offerPackageArray.removeAll()
                }
                let responseResult = result["Result"] as! NSDictionary
                let offerData = responseResult["Offer_Packages"] as! NSArray
                print(offerData)
                for item in offerData{
                    let offerDetail = item as! NSDictionary
                    let package = offerDetail["Package"] as! NSDictionary
                    let productPackage = package["Package_Products"] as! NSArray
                    self.getProductPackage(proItem: productPackage)
                    let offerProductObj = OfferPackage(value:offerDetail)
                    self.offerPackageArray.append(offerProductObj)
                }

                print(self.offerPackageArray.count)
                ImageCache.default.clearDiskCache()
                ImageCache.default.clearMemoryCache()
                self.collectionView.reloadData()
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.getOfferPackage(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    func getProductPackage(proItem: NSArray){
      if self.packageProductArray.count != 0{
            self.packageProductArray.removeAll()
        }
        for item in proItem{
            let offerDetail = item as! NSDictionary
            let productObj = PackageProduct(value:offerDetail)
            self.packageProductArray.append(productObj)
        }
    }
}


//MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension DDDealAndPromotionsViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "")
    }
    
    func title(forEmptyDataSet scrollView:
        UIScrollView!) -> NSAttributedString! {
        let text = "No Deals and Promotions are currently available."//"Cart is empty."
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: Constants.CART_COLOR
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = ""//"Looks like you have no items in your cart."
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: Constants.CART_COLOR,
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
     let text = "Refresh"//"Add items in cart"
     let attribs = [
     NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
     NSForegroundColorAttributeName: Constants.APP_COLOR
     ] as [String : Any]
     
     return NSAttributedString(string: text, attributes: attribs)
     }
     func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
            self.loadData()
     }
}
