//
//  CreateAccountViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 11/13/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var errorMessageStackView: UIStackView!
    @IBOutlet weak var errorMessage1: UILabel!
    @IBOutlet weak var errorMessage2: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    // MARK: - Properties
    var activeTextField = UITextField()
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    // MARK: - Functions
    @objc func adjustForKeyboard(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        if passwordTextField == activeTextField && view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if activeTextField == confirmPasswordTextField {
            view.frame.origin.y = 0
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if firstNameTextField == activeTextField {
            lastNameTextField.becomeFirstResponder()
        } else if lastNameTextField == activeTextField {
            emailTextField.becomeFirstResponder()
        } else if emailTextField == activeTextField {
            usernameTextField.becomeFirstResponder()
        } else if usernameTextField == activeTextField {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField == activeTextField {
            confirmPasswordTextField.becomeFirstResponder()
        }
        
//        if activeTextField == confirmPasswordTextField {
//            view.frame.origin.y = 0
//            view.endEditing(true)
//        }
        
        return true
    }
    
    
    
    // MARK: - Actions
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        
//        view.frame.origin.y = 0
//        
//        guard let firstName = firstNameTextField.text,
//            let lastName = lastNameTextField.text,
//            let email = emailTextField.text?.lowercased(),
//            let password = passwordTextField.text,
//            let username = usernameTextField.text?.lowercased()
//            else { return }
//        
//        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespaces)
//        let trimmedLastName = lastName.trimmingCharacters(in: .whitespaces)
//        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
//        
//        Endpoint.auth.createUser(withEmail: trimmedEmail, password: password) { (authDataResult, error) in
//            if let error = error {
//                print("🎩 Error creating user: \(#function) \(error) \(error.localizedDescription)")
//                return
//            }
//            
//            if let user = authDataResult?.user {
//                let currentUser = User(uid: user.uid, email: user.email!, username: username, loggedIn: true, firstName: trimmedFirstName, lastName: trimmedLastName, isPrivate: false, profilePic: "", lifePerspective: "", loveRating: 0, reminderGramInboxIDs: [], reminderGramOutboxIDs: [], totalReminderGramsSent: 0)
//                Endpoint.database.collection("users").document(user.uid).setData(currentUser.firebaseDictionary)
//                
//                Endpoint.auth.signIn(withEmail: trimmedEmail, password: password) { (authDataResult, error) in
//                    if let error = error {
//                        print("Error signing in user: \(#function) \(error) \(error.localizedDescription)")
//                        return
//                    }
//                    
//                    if let user = authDataResult?.user {
//                        Endpoint.database.collection("users").document(user.uid).getDocument(completion: { (snapshot, error) in
//                            if let error = error {
//                                print("🎩 Error fetching current user \(error) \(error.localizedDescription)")
//                            }
//                            
//                            if let document = snapshot?.data() {
//                                let currentUser = User(userDictionary: document)
//                                ProfileController.shared.currentProfile = currentUser
//                                ProfileController.shared.isUserLoggedIn = true
//                                print("🍁\(Auth.auth().currentUser?.email) 📧email: \(currentUser?.email) 📛username: \(currentUser?.username)")
//                            }
//                        })
//                    }
//                    print("successful Sign-in")
//                }
//            }
//        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "createAccountToLoginVC", sender: self)
    }
}



// MARK: - Navigation
extension CreateAccountViewController {
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "createAccountToMainVC" {
            // if email is taken || if username is taken || if password doesn't meet criteria {
//              print("🌂 No can segue")
//              return false
            //}
            // else {
//              print("🧥 Yep we have segue!")
//              return true
            //}
        }
        return true
    }}
