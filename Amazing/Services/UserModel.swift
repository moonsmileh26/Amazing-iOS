//
//  UserModel.swift
//  Amazing
//
//  Created by Humberto Solano on 09/03/24.
//

import Foundation

struct UserModel: Codable {
    var _id: String = ""
    var user: String = ""
    var email: String = ""
    var visits: Int = 0
}
