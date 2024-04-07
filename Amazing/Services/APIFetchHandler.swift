//
//  APIFetchHandler.swift
//  Amazing
//
//  Created by Humberto Solano on 09/03/24.
//

import Foundation
import Alamofire

class APIFetchHandler {
    static let sharedInstance = APIFetchHandler()
    func fetchAPIData(handler: @escaping(_ apiData:  UserModel) -> (Void)) {
        let url = "https://amazingconcepts.onrender.com/getClientById"
        AF.request(url, method: .post, parameters: ["email": "autogeorge8.5@gmail.com"], encoding: URLEncoding.httpBody, headers: nil, interceptor: nil).response {
            response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(UserModel.self, from: data!)
                    handler(jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            case.failure(let error):
                
                print(error.localizedDescription)
                
            }
        
        }
    }
    
}
