//
//  DetailCountry.swift
//  Travel
//
//  Created by mr.root on 11/5/22.
//

import Foundation
class DetailCountry {
    var name: String
    var image: String
    var descriptions: String
    init(dict: [String: Any]) {
        self.image = dict["image"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.descriptions = dict["descriptions"] as? String ?? ""
    }
}
