import Foundation
import Alamofire

extension WebService {
    
    func getRecentNotices(communityId: Int?, completionHandler: @escaping ([Notice]?) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getRecentNotices(communityId: communityId, completionHandler: completionHandler)
        }
        
        var alamo: DataRequest
        
        if communityId != nil {
            let param = ["communityId" : communityId]
            alamo = AF.request("\(self.base)/notices/recent", method: .get, parameters: param, headers: tokenheader)
        } else {
            alamo = AF.request("\(self.base)/notices/recent", method: .get, headers: tokenheader)
        }
    
        alamo.responseDecodable(of: [String :[Notice]].self) { response in
            guard let json = response.value else {return}
            let notices = json["notices"]
            completionHandler(notices)
        }
    }
    
    func getNotices(communityId: Int?, completionHandler: @escaping (Notices?) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getNotices(communityId: communityId, completionHandler: completionHandler)
        }
        
        
        var param: [String: Any]?

        if communityId == nil {
            param = ["communityId" : ""]
        } else {
            param = ["communityId" : communityId!]
        }

        AF.request("\(self.base)/notices", method: .get, parameters: param, headers: tokenheader)
            .responseDecodable(of: Notices.self) { response in
            guard let notices = response.value else {return}
            completionHandler(notices)
        }
    }
    
}
