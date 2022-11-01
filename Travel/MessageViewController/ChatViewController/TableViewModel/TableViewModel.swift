//
//  TableViewModel.swift
//  Travel
//
//  Created by mr.root on 10/24/22.
//

import Foundation
import UIKit
final class TableViewModel {
    
    
    func setHiglight(_ search: String, _ text: String) -> NSAttributedString {
        let range = (text.uppercased() as NSString).range(of: search.uppercased())
        let  mutableAttrinbutedString = NSMutableAttributedString.init(string: text)
        mutableAttrinbutedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
        return mutableAttrinbutedString
    }
}
