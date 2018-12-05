//
//  LoginViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 11/13/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var errorMessageStackView: UIStackView!
    @IBOutlet weak var errorMessage1: UILabel!
    @IBOutlet weak var errorMessage2: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Actions
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        Endpoint.auth.signIn(withEmail: trimmedEmail, password: password) { (authDataResult, error) in
            if let error = error {
                print("Error signing in user: \(#function) \(error) \(error.localizedDescription)")
                return
            }
            
            if let user = authDataResult?.user {
                Endpoint.database.collection("users").document(user.uid).getDocument(completion: { (snapshot, error) in
                    if let error = error {
                        print("🎩 Error fetching current user \(error) \(error.localizedDescription)")
                    }
                    
                    if let document = snapshot?.data() {
                        let currentUser = User(userDictionary: document)
                        UserController.shared.currentUser = currentUser
                        UserController.shared.isUserLoggedIn = true
                        print("🍁 email: \(currentUser?.email) username: \(currentUser?.username)")
                    }
                })
            }
            print("successful Sign-in")
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "loginToCreateAccountVC", sender: self)
    }
}



// MARK: - Navigation
extension LoginViewController {
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
}
