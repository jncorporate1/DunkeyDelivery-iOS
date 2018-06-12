
import UIKit
import Alamofire
extension APIManager{
    
    func authenticateUserWith(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        
        authenticationManagerAPI.authenticateUserWith(parameters: parameters, success: success, failure: failure)
    }

    func registerUserWith(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        authenticationManagerAPI.registerWith(parameters: parameters,success:success,failure:failure)
    }
}
