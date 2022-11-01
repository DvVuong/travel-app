//
//  Hobby.swift
//  Travel
//
//  Created by mr.root on 10/31/22.
//

import Foundation
import Combine
class Hobby {
    let name: String
    let image: String
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
    }
}
