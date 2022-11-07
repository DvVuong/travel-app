//
//  Data.swift
//  Travel
//
//  Created by mr.root on 11/1/22.
//

import Foundation
class DetailCountrys {
    let name: String
    let image: String
    let descriptions: String
    let point_evaluation: Int
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.descriptions = dict["descriptions"] as? String ?? ""
        self.point_evaluation = dict["point_evaluation"] as? Int ?? 0
    }
    private enum codingKeys: String, CodingKey {
        case pointevaluation = "point_evaluation"
    }
}
