//
//  CaraDetaileControllerViewController.swift
//  carRental
//
//  Created by  zholon on 26/06/2021.
//

import UIKit

class CaraDetaileControllerViewController: UIViewController {
    var carDetaile: ForCellModel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var nameCarLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        priceLable.text = carDetaile.priceString + "$ "
        nameCarLabel.text = carDetaile.name
        imageView.image = carDetaile.image
    }
    

  
 

}
