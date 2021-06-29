//
//  LoginController.swift
//  carRental
//
//  Created by  zholon on 28/06/2021.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var errorLable: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        errorLable.isHidden = true
        
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        if let email = emailTF.text,
           let password = passwordTF.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    self!.errorLable.text = e.localizedDescription
                } else {
                    self!.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
            }
        }
    }
    
}
