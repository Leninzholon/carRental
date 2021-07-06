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
    var database : Firestore!
    var idArray: [String] = []
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        loadCars()
        
    }
    func loadCars() {
        
        db.collection(Constants.FireBase.collectionNameOrder).addSnapshotListener { (querySnapshot, err) in
            if let snapshot = querySnapshot?.documents {
                for document in snapshot {
                    let data = document.data()
                    let user =  data[Constants.FireBase.senderFS] as! String
                    if Auth.auth().currentUser!.email == user{
                        let newElement = document.documentID
                        self.idArray.append(newElement)
                    }
                }
            }
            self.orderCars = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let model = data[Constants.FireBase.modelFS] as? String, let price = data[Constants.FireBase.priceFS] as? Double,
                           let isReserve = data[Constants.FireBase.reserveFS] as? Bool,
                           let user = data[Constants.FireBase.senderFS] as? String
                        {
                            let newCar = ForCellModel(name: model, price: price, user: user, isReserve: isReserve)
                            
                            
                            self.orderCars.append(newCar)
                            self.sortForCurrentUser()
                            
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
                                                                 Constants.FireBase.reserveFS: isReserve]) {
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
    
    
    @IBAction func canselAction(_ sender: Any) {
       
        
        for id in idArray {
            db.collection(Constants.FireBase.collectionNameOrder).document(id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.tableView.reloadData()
                    print("Document successfully removed!")
                }
            }
        }
        
        for item in 0...6 {
            let updateReference = self.db.collection(Constants.FireBase.collectionName).document(String(item))
            updateReference.getDocument { (document, err) in
                if let err = err {
                    print(err.localizedDescription)
                }
                else {
                    let user = document?.data()![Constants.FireBase.senderFS] as? String
                    if Auth.auth().currentUser?.email == user{
                        
                        document?.reference.updateData([
                            
                            Constants.FireBase.reserveFS: false
                            
                        ])
                       
                    }
                }
            }
        }
    }
}

