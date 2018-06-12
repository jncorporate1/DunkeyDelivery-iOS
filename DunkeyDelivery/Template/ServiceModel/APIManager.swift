
import UIKit

typealias DefaultAPIFailureClosure = (NSError) -> Void
typealias DefaultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultBoolResultAPISuccesClosure = (Bool) -> Void
typealias DefaultArrayResultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void


protocol APIErrorHandler {
    func handleErrorFromResponse(response: Dictionary<String,AnyObject>)
    func handleErrorFromERror(error:NSError)
}


class APIManager: NSObject {
    static let sharedInstance = APIManager()
    var serverToken: String? {
        get{
           return "bearer " + AppStateManager.sharedInstance.loggedInUser.Token.access_token
        }
    }
    let authenticationManagerAPI = AuthenticationAPIManager()
    let deliveryManagerAPI =  DeliveryManagerAPI()
}
