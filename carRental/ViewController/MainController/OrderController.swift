//
//  OrderController.swift
//  carRental
//
//  Created by  zholon on 27/06/2021.
//

import UIKit
import Firebase

class OrderController: UITableViewController {
    var orderCara: [ForCellModel]!
    var orderCars: [ForCellModel] = []
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCars()
    }
    func loadCars() {
        
        db.collection(Constants.FireBase.collectionNameOrder).addSnapshotListener { (querySnapshot, err) in
            self.orderCars = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    var underTable: ForCellModel
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let model = data[Constants.FireBase.modelFS] as? String, let price = data[Constants.FireBase.priceFS] as? Double,
                           let isReserve = data[Constants.FireBase.reserveFS] as? Bool,
                           let user = data[Constants.FireBase.senderFS] as? String
                        {
                            let newCar = ForCellModel(name: model, price: price, user: user, isReserve: isReserve)
                            
                            
                            self.orderCars.append(newCar)
                            self.sortForCurrentUser()
                            //                            let currentSum = self.sumPrice(prices: self.orderCars)
                            //                            underTable = ForCellModel(name: "All Price", price: currentSum, user: user, isReserve: false)
                            //                            self.orderCars.append(underTable)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
                
                
            }
        }
        
        
    }
    func addListToDb(addArray: [ForCellModel], nameCollection: String) {
        for order in addArray {
            
            let model = order.name
            let price = order.price
            let isReserve = order.isReserve
            if let user = Auth.auth().currentUser?.email
            {
                db.collection(nameCollection).addDocument(data: [Constants.FireBase.senderFS: user, Constants.FireBase.modelFS: model, Constants.FireBase.priceFS: price,
                                                                 Constants.FireBase.reserveFS:
                                                                    isReserve]) {
                    (error) in
                    
                    if let e = error {
                        print("Saving data firestore\(e)")
                    } else {
                        print("Successfully saved data.")
                    }
                }
            }
        }
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderCars.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)
        
        let currentOrders = orderCars[indexPath.row]
        
        cell.textLabel?.text = currentOrders.name
        cell.imageView?.image = UIImage(named: currentOrders.name)
        cell.detailTextLabel?.text = currentOrders.priceString
        
        
        return cell
    }
    func sumPrice(prices: [ForCellModel]) -> Double {
        var sumPrice: Double = 0.0
        for price in prices{
            sumPrice += price.price
        }
        return sumPrice
    }
    func sortForCurrentUser() {
        let newArray = orderCars
        orderCars = []
        for element in newArray{
            if Auth.auth().currentUser!.email == element.user {
                orderCars.append(element)
            }
        }
        
    }
    
    @IBAction func censelAction(_ sender: UIBarButtonItem) {
        if let indexPath = tableView.indexPathForSelectedRow {
            print("indexPath: \(indexPath.row)")
            let updateReference = self.db.collection(Constants.FireBase.collectionNameOrder).document(String(indexPath.row))
            updateReference.getDocument { (document, err) in
                if let err = err {
                    print(err.localizedDescription)
                }
                else {
                    document?.reference.updateData([
                        Constants.FireBase.reserveFS: false
                        
                    ])
                }
            }
            db.collection(Constants.FireBase.collectionNameOrder).document().delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    
}
