//
//  DDPharmacyDetailViewController.swift
//  Template
//
//  Created by Ingic on 8/13/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import HTagView
import SwiftValidator
import IQKeyboardManagerSwift
import Alamofire

class DDPharmacyDetailViewController: BaseController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var autoCompleteTableView: UITableView!
    @IBOutlet weak var tag5: UILabel!
    @IBOutlet weak var tag4: UILabel!
    @IBOutlet weak var tag3: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var dispDistance: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var minOrder: UILabel!
    @IBOutlet weak var deliverFee: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var starView: DDStarView!
    @IBOutlet weak var patientGender: DDSimpleTextField!
    @IBOutlet weak var patientDOB: DDSimpleTextField!
    @IBOutlet weak var patientLastName: DDSimpleTextField!
    @IBOutlet weak var patientFirstName: DDSimpleTextField!
    @IBOutlet weak var doctorPhnNum: DDSimpleTextField!
    @IBOutlet weak var doctorLastName: DDSimpleTextField!
    @IBOutlet weak var doctorFirstName: DDSimpleTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var meditationField: DDSimpleTextField!
    @IBOutlet weak var tagView: HTagView!
    @IBOutlet weak var foodBgImage: UIImageView!
    
    
    //MARK: - Varaiables
    
    var uiColorArray = [UIColor]()
    var tagView2_data = [String]()
    let validator = Validator()
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    let gender = ["Male", "Female"]
    let genderIndex = ["1", "2"]
    var selectedPickerIndex = 0
    var DOBCheck = false
    var genderCheck = false
    var storeData : StoreItem!
    var medicineArr = [Medicine]()
    var selectedMedArr = [Medicine]()
    var medicineStoreArray = [Medicine]()
    var medicineIdArray = [Int]()
    var sendDate = ""
    var sendGender = ""
    var storeRatingStar = 0
    var blurEffectView = UIVisualEffectView()
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpData()
        self.tagViewInit()
        self.setUpView()
        self.addBackButtonToNavigationBar()
        
        self.setUpAutCompleteTable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.hideTabBarAnimated(hide: true)
        self.setFieldValidation()
        self.meditationField.rightButton.isUserInteractionEnabled = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    
    func setUpView(){
        patientDOB.textField.addDoneOnKeyboardWithTarget(self, action: #selector(doneTapped), shouldShowPlaceholder: true)
        patientGender.textField.addDoneOnKeyboardWithTarget(self, action: #selector(doneTapped), shouldShowPlaceholder: true)
        meditationField.rightButton.addTarget(self, action: #selector(addTag), for: .touchUpInside)
        setColorArray()
        self.setNavigationRightItems()
        self.starView.setWhite(items: storeRatingStar)
        self.patientDOB.textField.addTarget(self, action: #selector(DOBDidBegin), for: .editingDidBegin)
        self.patientDOB.textField.addTarget(self, action: #selector(DOBDidEnd), for: .editingDidEnd)
        self.patientGender.textField.addTarget(self, action: #selector(genderDidBegin), for: .editingDidBegin)
        self.patientGender.textField.addTarget(self, action: #selector(genderDidEnd), for: .editingDidEnd)
    }
    func tagViewInit(){
        tagView.delegate = self
        tagView.dataSource = self
        tagView.multiselect = false
        tagView.marg = 5
        tagView.btwTags = 5
        tagView.btwLines = 5
        tagView.tagMainTextColor = UIColor.white
        tagView.backgroundColor = UIColor.white
        tagView.tagSecondBackColor = UIColor.lightGray
        tagView.tagSecondTextColor = UIColor.darkText
        tagView.tagCornerRadiusToHeightRatio = 0.4
        tagView.reloadData()
    }
    func setUpData(){
        if storeData != nil{
            var tags = [String]()
            for tag in storeData.storeTags{
                tags.append(tag.Tag)
            }
            self.addTags(tagArr: tags)
        }
        
        self.address.text = storeData.Address
        self.companyName.text = storeData.BusinessName
        self.title = storeData.BusinessName
        self.dispDistance.text = (storeData.Distance).description + " m"
        
        if storeData.MinOrderPrice.value != nil{
            self.minOrder.text = "$" + (storeData.MinOrderPrice.value!).description}
        
        if storeData.MinDeliveryTime.value != nil{
            self.deliveryTime.text = (storeData.MinDeliveryTime.value!).description + " min"}
        if storeData.MinDeliveryCharges.value != nil{
            self.deliverFee.text = "$" + (storeData.MinDeliveryCharges.value!).description}
        storeRatingStar = Int(storeData.AverageRating)
        self.starView.starSmall(items: Int(storeData.AverageRating))
        
        /* if storeData.ImageUrl != nil{
         print(storeData.ImageUrl)
         let url = storeData.ImageUrl.getURL()
         self.foodBgImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "table_bg"))
         }*/
        blurView()
        self.foodBgImage.image = #imageLiteral(resourceName: "pharmacyBg")
    }
    
    func blurView() {
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.foodBgImage.frame.size.width + 50 , height: self.foodBgImage.frame.size.height))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        self.foodBgImage.addSubview(overlay)
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
    func DOBDidBegin(){
        self.DOBCheck = true
    }
    func DOBDidEnd(){
        self.DOBCheck = false
    }
    func genderDidBegin(){
        self.genderCheck = true
    }
    func genderDidEnd(){
        self.genderCheck = false
    }
    func doneTapped(){
        if (self.DOBCheck){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd"
            self.patientDOB.textField.text = dateFormatter.string(for: datePicker.date)
            self.view.endEditing(true)
        }
        else if (self.genderCheck){
            self.patientGender.textField.text = "\(gender[self.selectedPickerIndex])"
            self.view.endEditing(true)
        }
    }
    func setUpAutCompleteTable(){
        self.autoCompleteTableView.delegate = self
        self.autoCompleteTableView.dataSource = self
        self.autoCompleteTableView.isHidden = true
        self.autoCompleteTableView.isScrollEnabled = true
        self.meditationField.textField.delegate = self
        
    }
    func setFieldValidation(){
        validator.registerField(doctorFirstName.textField, errorLabel: doctorFirstName.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a valid name"), MaxLengthRule(length: 50, message: "")])
        validator.registerField(doctorLastName.textField, errorLabel: doctorLastName.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a valid name"), MaxLengthRule(length: 50, message: "")])
        validator.registerField(patientLastName.textField, errorLabel: patientLastName.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a valid name"), MaxLengthRule(length: 50, message: "")])
        validator.registerField(patientFirstName.textField, errorLabel: patientFirstName.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a valid name"), MaxLengthRule(length: 50, message: "")])
        validator.registerField(patientGender.textField, errorLabel: patientGender.errorLabel, rules: [RequiredRule()])
        validator.registerField(patientDOB.textField, errorLabel: patientDOB.errorLabel, rules: [RequiredRule()])
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        validator.registerField(doctorPhnNum.textField, errorLabel: doctorPhnNum.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 10, message: "Please enter a valid phone number"), MaxLengthRule(length: 15, message: "Phone number should be least 10 digits")])
        patientGender.textField.inputView = pickerView
        datePicker.datePickerMode = .date
        patientDOB.textField.inputView = datePicker
        self.setUpDatePicker()
        doctorPhnNum.textField.keyboardType = .numberPad
    }
    
    func setUpDatePicker(){
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        datePicker.backgroundColor = UIColor.white
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.patientDOB.textField.text = dateFormatter.string(for: sender.date)
        sendDate = self.patientDOB.textField.text!
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
    
    func addTag(){
        if meditationField.textField.text != ""{
            
            let item = self.selectedMedArr[meditationField.tag]
            let itemID = item.Id
            
            if medicineIdArray.contains(itemID) {
                self.showErrorWith(message: "Selected medicine already exists.")
            } else {
                medicineIdArray.append(itemID)
                self.tagView2_data.append(meditationField.textField.text!)
            }
            
            self.meditationField.endEditing(true)
            self.meditationField.rightButton.isUserInteractionEnabled = false
            self.tagView.reloadData()
            self.setScrollContent()
            self.medicineArr.removeAll()
            self.selectedMedArr.removeAll()
            self.autoCompleteTableView.isHidden = true
            self.meditationField.textField.text = ""
        }
        else{
            if tagView2_data.count == 0{
                meditationField.setErrorWith(message: "At least add one medication")
            }
            else{
                meditationField.resetError()
            }
        }
    }
    
    func setScrollContent(){
        var contentRect : CGRect = CGRect.zero
        for views in self.scrollView.subviews{
            contentRect = contentRect.union(views.frame)
        }
        self.scrollView.contentSize = contentRect.size
        self.view.layoutIfNeeded()
    }
    
    func setColorArray(){
        self.uiColorArray.append(UIColor(red:0.09, green:0.58, blue:0.81, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.61, green:0.41, blue:0.68, alpha:1.0))
    }
    
    func resetErrorForTextFields(){
        self.doctorPhnNum.resetError()
        self.doctorLastName.resetError()
        self.doctorFirstName.resetError()
        self.patientGender.resetError()
        self.patientFirstName.resetError()
        self.patientLastName.resetError()
        self.patientDOB.resetError()
        self.meditationField.resetError()
    }
    
    func moveToAddress(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddAddressViewController") as! DDAddAddressViewController
        controller.setButtonTilte = "Continue"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Actions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if tagView2_data.count == 0{
            meditationField.setErrorWith(message: "At least add one medication")
            self.resetErrorForTextFields()
            validator.validate(self)
        }
        else{
            meditationField.resetError()
            self.resetErrorForTextFields()
            validator.validate(self)
        }
    }
    
    @IBAction func reviewTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDDetailViewController") as! DDDetailViewController
        vc.storeData = self.storeData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func aboutTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDDetailViewController") as! DDDetailViewController
        vc.viewCheck = true
        vc.storeData = self.storeData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDSearchViewController") as! DDSearchViewController
        vc.proStoreId = (storeData.Id).description
        vc.viewCheck = true
        vc.searchTile = "Kru"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - UITextfiled Delegate

extension DDPharmacyDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.length >= 3{
            if (newString.length % 3 == 0){
                var searchValue = newString as String
                searchValue = searchValue.replacingOccurrences(of: " ", with: "%20")
                self.getSearchedValues(string: String(searchValue))
            }
        }
        self.autoCompleteTableView.isHidden = false
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.meditationField.textField{
            self.autoCompleteTableView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.meditationField.textField{
            self.autoCompleteTableView.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
}


//MARK: - HTagViewDelegate, HTagViewDataSource

extension DDPharmacyDetailViewController : HTagViewDelegate, HTagViewDataSource {
    
    func numberOfTags(_ tagView: HTagView) -> Int {
        return tagView2_data.count
    }
    
    
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        if index % 2 == 0{
            tagView.tagMainBackColor = self.uiColorArray[0]
        }
        else{
            tagView.tagMainBackColor = self.uiColorArray[1]
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
        medicineIdArray.remove(at: index)
        tagView2_data.remove(at: index)
        tagView.reloadData()
        self.setScrollContent()
    }
    
    
    func getMedicineIdArr(){
        for item in self.medicineStoreArray{
            self.medicineIdArray.append(item.Id)
        }
    }
}


//MARK: - ValidationDelegate

extension DDPharmacyDetailViewController: ValidationDelegate{
    func validationSuccessful() {
        if tagView2_data.count == 0{
            meditationField.setErrorWith(message: "At least add one medication")
        }
        else{
            meditationField.resetError()
            submitPharmacy()
        }
    }
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            if tagView2_data.count == 0{
                meditationField.setErrorWith(message: "At least add one medication")
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
}


//MARK: -  UIPickerViewDelegate

extension DDPharmacyDetailViewController: UIPickerViewDelegate{
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gender.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.selectedPickerIndex = row
        self.patientGender.textField.text = "\(gender[row])"
        sendGender = genderIndex[row]
    }
}


//MARK: -  UITableViewDelegate, UITableViewDataSource


extension DDPharmacyDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.medicineArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = self.medicineArr[indexPath.row]
        cell.textLabel?.text = item.Name
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.medicineArr[indexPath.row]
        self.meditationField.tag = indexPath.row
        self.meditationField.rightButton.isUserInteractionEnabled = true
        self.meditationField.endEditing(true)
        self.meditationField.textField.text = item.Name
        self.autoCompleteTableView.isHidden = true
        self.selectedMedArr = self.medicineArr
        self.medicineArr.removeAll()
        self.autoCompleteTableView.reloadData()
    }
}


//MARK: - WebService

extension DDPharmacyDetailViewController{
    func getSearchedValues(string: String){
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "Store_id":"\(self.storeData.Id)",
            "search_string":"\(string)"]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                if self.medicineArr.count != 0{
                    self.medicineArr.removeAll()
                }
                
                let responseResult = result["Result"] as! NSDictionary
                let medications = responseResult["medications"] as! NSArray
                
                for med in medications{
                    let medDic = Medicine(value: med as! NSDictionary)
                    self.medicineArr.append(medDic)
                    
                    // self.medicineIdArray.append(medDic.Id)
                }
                self.autoCompleteTableView.reloadData()
                
            }else if(response?.intValue == 403){
                self.showErrorWith(message: "Error")
                return
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.getMedicationValues(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    // SUBMIT PHARMACY REQUEST
    
    func submitPharmacy(){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let genderString = self.patientGender.textField.text
        
        if genderString == "Male" {
            sendGender = "1"
        } else {
            sendGender = "2"
        }
        
        let parameters: Parameters = [
            
            "Doctor_FirstName": self.doctorFirstName.textField.text! ,
            "Doctor_LastName": self.doctorLastName.textField.text! ,
            "Doctor_Phone": self.doctorPhnNum.textField.text!,
            "Patient_FirstName": self.patientFirstName.textField.text!,
            "Patient_LastName": self.patientLastName.textField.text!,
            "Patient_DOB": sendDate,
            "Gender": sendGender,
            "User_Id": AppStateManager.sharedInstance.loggedInUser.Id,
            "Product_Ids": medicineIdArray,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.navigationController?.popViewController(animated: true)
                self.showSuccessWith(message: "Details submitted successfully.")
            }
            else if (response?.intValue == 404){
                let responseResult = result["Result"] as! NSDictionary
                //let message = responseResult["ErrorMessage"] as! String
                self.showErrorWith(message: "User address not found, Please provide delivery address." )
                // self.moveToAddress()
                
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.submitPharmacyRequest(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
