//
//  ForCellModel.swift
//  carRental
//
//  Created by  zholon on 26/06/2021.
//

import UIKit

struct ForCellModel {
    let name: String
    let price: Double
    var priceString: String{
        return "\(price)"
    }
    let image: UIImage
}
