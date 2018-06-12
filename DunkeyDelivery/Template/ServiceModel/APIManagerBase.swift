


import UIKit
import Alamofire
import SwiftyJSON

enum Route: String {
    
    //MARK: - Post
    
    case post = "/post"
    
    //MARK: - Get
    
    case get = "/get"
    

    //MARK: - User
    
    case Login = "User/Login"
    case Register = "User/Register"
    case addAddress = "User/AddAddress"
    case editProfile = "User/EditProfile"
    case emailUs = "User/SubmitContactUs"
    case addCreditCard = "User/AddCreditCard"
    case gmailLogin = "User/RegisterWithGmail"
    case editUserAddress = "User/EditUserAddress"
    case RegisterWithImage = "User/RegisterWithImage"
    case editUserCreditCard = "User/EditUserCreditCards"
    case changePasswordMobile = "User/ChangePasswordMobile"
    case getUserAddress = "User/GetUserAddresses?User_id={User_id}"
    case getUserCreditCards = "User/GetUserCreditCards?User_id={User_id}"
    case forgotPasswordWithEmail = "User/PasswordResetThroughEmail?email={Email}"
    case removeAddress = "User/RemoveAddress?address_id={address_id}&User_Id={User_Id}"
    case removeCreditCard = "User/RemoveCreditCard?Card_Id={Card_Id}&User_Id={User_Id}"
    case updateUserAddressById = "User/UpdateUserAddressesById?User_id={User_id}&Address_Id={Address_Id}"
    case getUpdateUserCreditCard = "User/UpdateCreditCardById?User_id={User_id}&Creditcard_Id={Creditcard_Id}&Mark={Mark}"
    case externalLogin = "User/ExternalLogin?userId={userId}&accessToken={accessToken}&socialLoginType={socialLoginType}"

    
    //MARK: - Shop
    
    case cusinie = "Shop/GetCousines"
    case storeInfo = "/Shop/GetStoreByIdMobile?Id={storeId}"
    case getSchedule = "Shop/GetStoreSchedule?Store_Id={Store_Id}"
    case homeCategory = "Shop/GetStoresByCategories?Category_id={Category_id}&Lat={Lat}&Lng={Lng}"
    case categoryDetail = "Shop/StoreCategories?Store_id={store_id}&Page={page_no}&Items={num_items}"
    case filterStore = "Shop/FilterStore?CategoryName={CategoryName}&SortBy={SortBy}&Rating={Rating}&MinDeliveryTime={MinDeliveryTime}&PriceRanges={PriceRanges}&MinDeliveryCharges={MinDeliveryCharges}&IsSpecial={IsSpecial}&IsFreeDelivery={IsFreeDelivery}&IsNewRestaurants={IsNewRestaurants}&Cuisines={Cuisines}&latitude={latitude}&longitude={longitude}"
    
    
    //MARK: - Order
    
    case getCartMobile = "Order/GetCartMobile"
    case insertOrder = "Order/InsertOrderMobile"
    case getOrdersHistory = "Order/GetOrdersHistoryMobile?UserId={UserID}&SignInType={SignInType}&IsCurrentOrder={IsCurrentOrder}&PageSize={PageSize}&PageNo={PageNo}"
    case getOrderNotification = "Order/GetOrdersHistoryByIdMobile?UserId={UserId}&OrderId={OrderId}&StoreOrder_Id={StoreOrder_Id}&SignInType={SignInType}&IsCurrentOrder={IsCurrentOrder}&PageSize={PageSize}&PageNo={PageNo}"
    

    //MARK: - Products
    
    case medicationValues = "Products/GetMedicationNames?Store_id={Store_id}&search_string={search_string}"
    case getProductByName = "Products/ProductByName?search_string={search_string}&Store_id={Store_id}&Items={Items}&Page={Page}"
    case getGernalProductByName = "Products/ProductByName?search_string={search_string}&Items={Items}&Page={Page}"
    case categoryProduct = "Products/GetCategoryProducts?Category_Id={Category_Id}&Page={page_no}&Items={num_items}"
    
    
    //MARK: - Alcohol
    
    case alcoholFilterStore = "Alcohol/AlcoholFilterStore?latitude={latitude}&longitude={longitude}&SortBy={SortBy}&Country={Country}&Price={Price}&ProductNetWeight={ProductNetWeight}"
    case alcoholStoreCategoryDetail = "Alcohol/AlcoholStoreCategoryDetails?Store_Id={Store_Id}&Category_Id={Category_Id}"
    case changeAlcoholStore = "Alcohol/ChangeStore?Type={Type}&latitude={latitude}&longitude={longitude}&Page={Page}&Items={Items}"
    case alcoholHomeScreen = "Alcohol/AlcoholHomeScreen?latitude={latitude}&longitude={longitude}&Page={Page}&Items={Items}&Store_Ids={Store_Ids}"
    case alcoholSubFilters = "Alcohol/AlcoholFilterTypeStoreCategoryDetails?SortBy={SortBy}&Country={Country}&Price={Price}&Size={Size}&Type_Id={Type_Id}&ParentName={ParentName}?ProductNetWeight={ProductNetWeight}"
    
    
    
    //MARK: - Pharmacy
    
    case submitPharmacyRequest = "Pharmacy/SubmitPharmacyRequestMobile"
    

    
    //MARK: - Laundry
    
    case requestGetColthes = "Laundry/RequestGetClothMobile"
    case laundryParentCategory = "Laundry/GetParentCategories?Store_id={Store_id}&Page={Page}&Items={Items}"
    case getCategoryItems = "Laundry/GetCategoryItems?Store_id={Store_id}&ParentCategory_id={ParentCategory_id}&Page={Page}&Items={Items}"

    
    
    //MARK: - Ride
    
    case rideRegister = "Ride/Register"
    
    
    //MARK: - Reward
    
    case getRewardPrizes = "Reward/GetRewardPrizes?UserID={UserID}"
    case redeemPrize = "Reward/RedeemPrize?UserID={UserID}&RewardID={RewardID}"
    

    //MARK: - Settings
    
    case setting = "Settings/GetSettings"
    
    
    //MARK: - Deals

    case getOfferPackage = "Deals/GetOfferPackage"

    
    //MARK: - Notification
    
    case registerPushNotification = "Notification/RegisterPushNotification"
    
    
    //MARK: - RAW
    
    case CompleteRegister = "/register-2"
    
    
    //MARK: - Base URL
    
    func url() -> String{
        return Constants.BaseURL + self.rawValue
    }
    
}

enum BaseURL: String{
    case Live = "http://35.160.175.165:8090/DunkeyAPI/api/"
    case Dev = "http://10.100.28.38/api/"
}

class APIManagerBase: NSObject {
    
    let baseURL = Constants.BaseURL
    let defaultRequestHeader = ["Content-Type": "application/json"]
    let defaultError = NSError(domain: "ACError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request Failed."])
    
    func getAuthorizationHeader () -> Dictionary<String,String>{
        
        if(AppStateManager.sharedInstance.isUserLoggedIn()){
            if let token = APIManager.sharedInstance.serverToken {
                return ["token":token,"Accept":"application/json"]
            }
        }else if(AppStateManager.sharedInstance.registerUser != nil){
            
            return ["token":"bearer "+AppStateManager.sharedInstance.registerUser.Token.access_token!,"Accept":"application/json"]
            
            
        }
        return ["Content-Type":"application/json"]
    }
    
    
    func getErrorFromResponseData(data: Data) -> NSError? {
        do{
            let result = try JSONSerialization.jsonObject(with: data,options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String,AnyObject>>
            if let message = result?[0]["message"] as? String{
                let error = NSError(domain: "GCError", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                return error;
            }
        }catch{
            NSLog("Error: \(error)")
        }
        return nil
    }
    
    func URLforRoute(route: String,params:Parameters) -> URL? {
        
        if let components: NSURLComponents  = NSURLComponents(string: (Constants.BaseURL+route)){
            var queryItems = [NSURLQueryItem]()
            for(key,value) in params{
                queryItems.append(NSURLQueryItem(name:key,value: value as? String))
            }
            components.queryItems = queryItems as [URLQueryItem]?
            
            return components.url as URL?
        }
        return nil;
    }
    
    func POSTURLforRoute(route:String) -> URL?{
        
        if let components: NSURLComponents = NSURLComponents(string: (Constants.BaseURL+route)){
            return components.url! as URL
        }
        return nil
    }
    
    func GETURLfor(route:String) -> URL?{
        
        if let components: NSURLComponents = NSURLComponents(string: (Constants.BaseURL+route)){
            return components.url! as URL
        }
        return nil
    }
    
    func GETURLforGoogleAPI(route:String) -> URL?{
        let urlStr : NSString = route.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        
        if let components: NSURLComponents = NSURLComponents(string: (Constants.BaseGoogleURL+(urlStr as String))){
            return components.url! as URL
        }
        return nil
    }
    
    func postRequestWith(route: URL,parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
            response in
            debugPrint(response)
            guard response.result.error == nil else{
                print("error in calling post request")
                failure(response.result.error! as NSError)
                return;
            }
            
            if let value = response.result.value {
                print (value)
                if let jsonResponse = response.result.value as? Dictionary<String, AnyObject>{
                    success(jsonResponse)
                } else {
                    success(Dictionary<String, AnyObject>())
                }
            }
        }
    }
    
    
    func getRequestWith(route: URL,parameters: Parameters,
                        success:@escaping DefaultArrayResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        
        Alamofire.request(route, method: .get, encoding: JSONEncoding.prettyPrinted, headers: getAuthorizationHeader()).responseJSON{
            response in
            
            guard response.result.error == nil else{
                
                print("error in calling post request")
                failure(response.result.error! as NSError)
                return;
            }
            
            if response.result.isSuccess {
                if let jsonResponse = response.result.value as? Dictionary<String, AnyObject>{
                    success(jsonResponse)
                } else {
                    success(Dictionary<String, AnyObject>())
                }
            }
        }
    }
    
    func putRequestWith(route: URL,parameters: Parameters,
                        success:@escaping DefaultArrayResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        
        Alamofire.request(route, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            
            guard response.result.error == nil else{
                print("error in calling post request")
                failure(response.result.error! as NSError)
                return;
            }
            
            if let value = response.result.value {
                print (value)
                if let jsonResponse = response.result.value as? Dictionary<String, AnyObject>{
                    success(jsonResponse)
                } else {
                    success(Dictionary<String, AnyObject>())
                }
            }
        }
    }
    
    func deleteRequestWith(route: URL,parameters: Parameters,
                           success:@escaping DefaultArrayResultAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
        
        Alamofire.request(route, method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            
            guard response.result.error == nil else{
                print("error in calling post request")
                failure(response.result.error! as NSError)
                return;
            }
            
            if let value = response.result.value {
                print (value)
                if let jsonResponse = response.result.value as? Dictionary<String, AnyObject>{
                    success(jsonResponse)
                } else {
                    success(Dictionary<String, AnyObject>())
                }
            }
        }
    }
    
    func postRequestWithMultipart(route: URL,parameters: Parameters,
                                  success:@escaping DefaultArrayResultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure){
        
        let URLSTR = try! URLRequest(url: route.absoluteString, method: HTTPMethod.post, headers: getAuthorizationHeader())
        
        Alamofire.upload(multipartFormData: {multipart in
            
            for (key , value) in parameters {
                
                if let data:Data = value as? Data {
                    
                    multipart.append(data, withName: "profile_picture", fileName: "image.jpg", mimeType: "image/jpeg")
                } else {
                    multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
            
        }, with: URLSTR, encodingCompletion: {result in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    debugPrint(response)
                    guard response.result.error == nil else{
                        
                        print("error in calling post request")
                        failure(response.result.error! as NSError)
                        return;
                    }
                    
                    if let value = response.result.value {
                        print (value)
                        if let jsonResponse = response.result.value as? Dictionary<String, AnyObject>{
                            success(jsonResponse)
                        } else {
                            success(Dictionary<String, AnyObject>())
                        }
                        
                    }
                    
                }
            case .failure(let encodingError):
                failure(encodingError as NSError)
            }
        })
    }
    
    fileprivate func multipartFormData(parameters: Parameters) {
        let formData: MultipartFormData = MultipartFormData()
        if let params:[String:AnyObject] = parameters as [String : AnyObject]? {
            for (key , value) in params {
                
                if let data:Data = value as? Data {
                    
                    formData.append(data, withName: "profile_picture", fileName: "image.jpg", mimeType: "image/jpeg")
                } else {
                    formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
            print("\(formData)")
        }
    }
}

public extension Data {
    public var mimeType:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "image/jpeg";
            case 0x89:
                return "image/png";
            case 0x47:
                return "image/gif";
            case 0x49, 0x4D:
                return "image/tiff";
            case 0x25:
                return "application/pdf";
            case 0xD0:
                return "application/vnd";
            case 0x46:
                return "text/plain";
            default:
                print("mimeType for \(c[0]) in available");
                return "application/octet-stream";
            }
        }
    }
}
