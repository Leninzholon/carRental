//
//  CarRentalViewController.swift
//  carRental
//
//  Created by  zholon on 26/06/2021.
//

import UIKit
import Firebase

class CarRentalViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var orderCars = [ForCellModel]()
    var dateCars: [ForCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCars()
        
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dateCars.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as! AutoViewCell
        cell.nameLable.textColor = UIColor.init(named: "cellTextColor")
        cell.nameLable.shadowColor = UIColor.init(named: "cellTextColor")
        cell.priceLable.textColor = UIColor.init(named: "cellTextColor")
        cell.priceLable.shadowColor = UIColor.init(named: "cellTextColor")
        cell.nameLable.text = dateCars[indexPath.row].name
        cell.priceLable.text = dateCars[indexPath.row].priceString + "$ "
        cell.imageAutoView.image = UIImage(named: dateCars[indexPath.row].name)
        
        isReserve(cell, isReserve: dateCars[indexPath.row].isReserve)
        
        
        
        return cell
    }
    func isReserve(_ cell: UITableViewCell, isReserve: Bool)  {
        cell.accessoryType = isReserve ? .checkmark : .none
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
    func loadCars() {
       
        db.collection(Constants.FireBase.collectionName).addSnapshotListener { (querySnapshot, err) in
            self.dateCars = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let model = data[Constants.FireBase.modelFS] as? String, let price = data[Constants.FireBase.priceFS] as? Double,
                           let isReserve = data[Constants.FireBase.reserveFS] as? Bool
                        {
                            let newCar = ForCellModel(name: model, price: price, user: nil, isReserve: isReserve)
                            
                           
                            self.dateCars.append(newCar)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                
                
            }
        }
        
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    //MARK: Move row
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let order = UIContextualAction(style: .normal, title: "Order") { action,view,completionHandler  in
            print("Order\(self.dateCars[indexPath.row])")
            self.dateCars[ indexPath.row].isReserve = true
            
            
            let updateReference = self.db.collection(Constants.FireBase.collectionName).document(String(indexPath.row))
                    updateReference.getDocument { (document, err) in
                        if let err = err {
                            print(err.localizedDescription)
                        }
                        else {
                            document?.reference.updateData([
                                Constants.FireBase.reserveFS: true
                            ])
                            
                        }
                    }
            let newElement = self.dateCars[indexPath.row]
            
            self.orderCars.append(newElement)
            self.tableView.reloadData()
            
            
            print("Array Order: \(self.orderCars)")
            completionHandler(true)
        }
        order.backgroundColor = .red
        let swipe = UISwipeActionsConfiguration(actions: [order])
        return swipe
    }
    // MARK: Navigation
    
    
    @IBAction func goToOrder(_ sender: UIButton) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "orderCell"{
            let orderVC = segue.destination as! OrderController
            orderVC.orderCara = orderCars
            addListToDb(addArray: orderCars, nameCollection: Constants.FireBase.collectionNameOrder)
        } else {
            if let indexPath = tableView.indexPathForSelectedRow{
                let detaileVC = segue.destination as! CaraDetaileControllerViewController
                detaileVC.carDetaile = dateCars[indexPath.row]
                
                
            }
        }
        
    }
    
}
