//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text, emailTextfield.hasText else { return }
        guard let password = passwordTextfield.text, passwordTextfield.hasText else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            if let err = error {
                self.showError(err.localizedDescription)
            } else {
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
        }
    }
    func showError(_ description: String) {
        let ac = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
}
