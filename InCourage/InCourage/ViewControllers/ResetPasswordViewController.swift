//
//  ResetPasswordViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 11/13/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var errorMessageStackView: UIStackView!
    @IBOutlet weak var errorMessage1: UILabel!
    @IBOutlet weak var errorMessage2: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    


    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Actions
    @IBAction func sendEmailButtonTapped(_ sender: UIButton) {
    }
}



// MARK: - Navigation
extension ResetPasswordViewController {
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
}
