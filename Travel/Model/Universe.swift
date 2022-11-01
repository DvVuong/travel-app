//
//  Universe.swift
//  Travel
//
//  Created by mr.root on 10/31/22.
//

import Foundation
class Universe {
    var name: String
    var image: String
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
    } 
    
}
