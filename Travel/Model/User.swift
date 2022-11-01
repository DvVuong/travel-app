//
//  User.swift
//  Travel
//
//  Created by mr.root on 10/23/22.
//

import Foundation
import Combine
class User {
    @Published var Avatar: String
    @Published var userName: String
    let massage: String
    let id: String
    
    init (dict: [String: Any]) {
        self.Avatar = dict["Avatar"] as? String ?? ""
        self.userName = dict["userName"] as? String ?? ""
        self.massage = dict["massage"] as? String ?? ""
        self.id = dict["id"] as? String ?? ""
    }
    
    
}
