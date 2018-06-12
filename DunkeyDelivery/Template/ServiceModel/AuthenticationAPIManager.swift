

import UIKit
import Alamofire
import SwiftyJSON
class AuthenticationAPIManager: APIManagerBase {


    func authenticateUserWith(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
    
       
        let route: URL = POSTURLforRoute(route: Route.Login.rawValue)!
      self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    func registerWith(parameters: Parameters,success:@escaping DefaultArrayResultAPISuccessClosure,
                      failure:@escaping DefaultAPIFailureClosure){
        
        if parameters.keys.contains("file") {
            let route: URL = POSTURLforRoute(route: Route.RegisterWithImage.rawValue)!
            self.postRequestWithMultipart(route: route, parameters: parameters, success: success, failure: failure)
        } else {
            let route: URL = POSTURLforRoute(route: Route.Register.rawValue)!
            self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
        }
    }
}
