//
//  ViewController.swift
//  carRental
//
//  Created by  zholon on 26/06/2021.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    enum UserAction: String,CaseIterable {
        case pontOne   = "About us"
        case pontTwo = "Car rental"
        case pontTree = "Your order"
    }
    private let userActions = UserAction.allCases
    override func viewDidLoad() {
        super.viewDidLoad()


    }

// MARK: Navigation
    
// Mark: Extension
}
extension MainViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = UIColor.init(named: "cellTextColor")
        cell.textLabel?.shadowColor = UIColor.init(named: "cellTextColor")
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = userActions[indexPath.row].rawValue
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.row]
        
        switch userAction {
        case .pontOne:
            performSegue(withIdentifier: "aboutUs", sender: self)
        case .pontTwo:
            performSegue(withIdentifier: "carRental", sender: self)
        case .pontTree:
            performSegue(withIdentifier: "yourOrder", sender: self)
        }
    }
    
    
}

