//
//  CarRentalViewController.swift
//  carRental
//
//  Created by  zholon on 26/06/2021.
//

import UIKit

class CarRentalViewController: UITableViewController {
var orderCars = [ForCellModel]()
var dateCars = [ForCellModel(name: "Mercedes", price: 100, image:#imageLiteral(resourceName: "mercedes") ), ForCellModel(name: "BMW", price: 100, image:#imageLiteral(resourceName: "bmw") ), ForCellModel(name: "vw", price: 100, image:#imageLiteral(resourceName: "volkswagen") ),ForCellModel(name: "Mercedes", price: 100, image:#imageLiteral(resourceName: "mercedes") ), ForCellModel(name: "BMW", price: 100, image:#imageLiteral(resourceName: "bmw") ), ForCellModel(name: "vw", price: 100, image:#imageLiteral(resourceName: "volkswagen") ), ForCellModel(name: "Mercedes", price: 100, image:#imageLiteral(resourceName: "mercedes") ), ForCellModel(name: "BMW", price: 100, image:#imageLiteral(resourceName: "bmw") ), ForCellModel(name: "vw", price: 100, image:#imageLiteral(resourceName: "volkswagen") )]
    override func viewDidLoad() {
        super.viewDidLoad()

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
        cell.imageAutoView.image = dateCars[indexPath.row].image
        
        

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    //MARK: Move row
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let order = UIContextualAction(style: .normal, title: "Order") { action,view,completionHandler  in
            print("Order\(self.dateCars[indexPath.row])")
            let newElement = self.dateCars.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.orderCars.append(newElement)
            print("Array Order: \(self.orderCars)")
            completionHandler(true)
        }
        order.backgroundColor = .red
        let swipe = UISwipeActionsConfiguration(actions: [order])
        return swipe
    }
    // MARK: Navigation
    

    @IBAction func goToOrder(_ sender: Any) {
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderCell"{
        let orderVC = segue.destination as! OrderController
            orderVC.orderCara = orderCars
        } else {
        if let indexPath = tableView.indexPathForSelectedRow{
            let detaileVC = segue.destination as! CaraDetaileControllerViewController
            detaileVC.carDetaile = dateCars[indexPath.row]
            
                
            }
        }
        
    }

}
