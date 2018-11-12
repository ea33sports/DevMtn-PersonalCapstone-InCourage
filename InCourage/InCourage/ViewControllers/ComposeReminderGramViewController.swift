//
//  ComposeReminderGramViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class ComposeReminderGramViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var recipientTextField: UITextField!
    @IBOutlet weak var recipientTableView: UITableView!
    @IBOutlet weak var reminderGramPhoto: UIImageView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var reminderGramMessageTextView: UITextView!
    
    
    
    // MARK: - Properties
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    var searching = false
    var filteredData: [String] = []
    
    
    
    // MARK: - Properties
    var selectedPhoto: UIImage?
    
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    
    
    // MARK: - Functions
    func updateView() {
        recipientTextField.delegate = self
        recipientTableView.delegate = self
        recipientTableView.dataSource = self
        recipientTableView.keyboardDismissMode = .onDrag
        recipientTableView.isHidden = true
        reminderGramPhoto.image = selectedPhoto
    }

    
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recipeintTextFieldEditingDidChange(_ sender: UITextField) {
        
        if let searchText = recipientTextField.text, !searchText.isEmpty {
            filteredData.removeAll()
            recipientTableView.isHidden = false
            for item in data {
                if item.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(item)
                }
            }
            searching = true
            print(searchText)
            print(filteredData)
        } else {
            searching = false
            recipientTableView.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.recipientTableView.reloadData()
        }
    }
    
    @IBAction func colorPickerButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
    }
}



extension ComposeReminderGramViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recipientTextField.resignFirstResponder()
        return true
    }
    
    
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? filteredData.count : data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipientTableView.dequeueReusableCell(withIdentifier: "recipientCell", for: indexPath)
        
        // Configure the cell
        let filteredDataItem = searching ? filteredData[indexPath.row] : data[indexPath.row]
        cell.textLabel?.text = filteredDataItem
        
        return cell
    }
}



extension ComposeReminderGramViewController {
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
