//
//  ContactsController.swift
//  carRental
//
//  Created by  zholon on 06/07/2021.
//

import UIKit
import MapKit

class ContactsController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    let location = "Полтава, улица Зыгина 4"
let name = "title Avto"
    let  type = "me here"
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.layer.cornerRadius = 30
        setupPlacemark()
        
    }
    
    private func setupPlacemark() {
        
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.name
            annotation.subtitle = self.type
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    


}
