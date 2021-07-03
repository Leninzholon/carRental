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
    let user: String?
    var priceString: String{
        return "\(price)"
    }
    var isReserve: Bool
    
    
}
