//
//  CountryCollectionViewCell.swift
//  Travel
//
//  Created by mr.root on 10/30/22.
//

import UIKit

open class CountryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imgCountry: UIImageView!
    @IBOutlet private weak var lbNameCountry: UILabel!
    @IBOutlet weak var view: UIView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgCountry.layer.cornerRadius = 8
        imgCountry.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
    }
    func updateUI(_ country: Country) {
        lbNameCountry.text = country.name
        ImageCache.share.fetchImage(country.image) { image in
            self.imgCountry.image = image
        }
    }

}
