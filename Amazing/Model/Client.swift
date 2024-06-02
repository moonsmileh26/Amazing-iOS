//
//  Client.swift
//  Amazing
//
//  Created by Humberto Solano on 29/05/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Client: Codable {
    var user: String = "user@default.com"
    var visits: Int = 0
}

class ClientRepository {
    let collection = "Client"

    var db = Firestore.firestore()
}

extension ClientRepository {
    
    func fetchClient(user: String, completionBlock: @escaping (Result<Client, Error>) -> Void) {
        
        db.document("Client/\(user)").getDocument(completion: { query, error in
            do {
                let client = try query?.data(as: Client.self)
                completionBlock(.success(client ?? Client()))
                print("Fetched and decoded client \(client)")
            } catch {
                print("Error fetching client")
                completionBlock(.failure(error))
                print(error)
            }
            
        })
    
    }
    
    func saveNewClient(userId: String, client: Client) {
        do {
            print("")
            try db.collection(self.collection).document(userId).setData(from: client)
        } catch {
            print(error.localizedDescription)
        }
    }
}
