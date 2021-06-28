//
//  OrderController.swift
//  carRental
//
//  Created by  zholon on 27/06/2021.
//

import UIKit

class OrderController: UITableViewController {
    var orderCara: [ForCellModel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentSum = sumPrice(prices: orderCara)
       let underTable = ForCellModel(name: "All Price", price: currentSum, image: #imageLiteral(resourceName: "paypal-logo"))
        orderCara.append(underTable)
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return orderCara.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)
         let currentOrders = orderCara[indexPath.row]
        cell.textLabel?.text = currentOrders.name
        cell.imageView?.image = currentOrders.image
        
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

    

}
