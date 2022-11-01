//
//  Country.swift
//  Travel
//
//  Created by mr.root on 10/30/22.
//

import Foundation
import UIKit
struct Country {
    let name: String
    let image: String
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.image = dict["image"] as? String  ?? ""
    }
}
