//
//  CaraDetaileControllerViewController.swift
//  carRental
//
//  Created by  zholon on 26/06/2021.
//

import UIKit
import Cosmos
import Firebase

class CaraDetaileControllerViewController: UIViewController {
    var currentRatingId: String!
    var currentRating = ""
    
    let db = Firestore.firestore()
    @IBOutlet weak var cosmosView: CosmosView!
    var carDetaile: ForCellModel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var nameCarLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmosView.didTouchCosmos = {
            rating in
            self.loadStars()
            let updateReference = self.db.collection(Constants.FireBase.collectionName).document(self.currentRatingId)
            updateReference.getDocument { (document, err) in
                if let err = err {
                    print(err.localizedDescription)
                }
                else {
                    document?.reference.updateData([
                        Constants.FireBase.ratingFS: rating
                    ])
                    
                }
            }
            
            
        }
        
        priceLable.text = carDetaile.priceString + "$ "
        nameCarLabel.text = carDetaile.name
        imageView.image = UIImage(named: carDetaile.name)
    }
    
    
    
    // !!! Eror
    func loadStars() {
        let docRef = db.collection(Constants.FireBase.collectionName).document(currentRatingId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
              
            } else {
                print("Document does not exist")
            }
        }
       
    }
}


