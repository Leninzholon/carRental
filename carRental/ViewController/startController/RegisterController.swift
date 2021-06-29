//
//  RegisterController.swift
//  carRental
//
//  Created by  zholon on 28/06/2021.
//

import UIKit
import Firebase

class RegisterController: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var errorLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLable.isHidden = true
        
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        if let email = emailTF.text, let password = passwordTF.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorLable.text = e.localizedDescription
                    self.errorLable.isHidden = false
                    
                } else {
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
            }
        }
    }
    
}
