//
//  ProfileTableViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var profileHeaderView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var myLoveRatingLabel: UILabel!
    @IBOutlet weak var totalMessagesSentLabel: UILabel!
    @IBOutlet weak var whatIsLifeTextView: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        profileHeaderView.layer.shadowColor = UIColor.black.cgColor
        profileHeaderView.layer.shadowOpacity = 1
        profileHeaderView.layer.shadowOffset = CGSize.zero
        profileHeaderView.layer.shadowRadius = 2
        
        spinner.isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    
    // MARK: - Functions
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            present(imagePickerController, animated: true) {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        let chosenImage = info[.originalImage] as? UIImage //2
        profileImageView.image = chosenImage //4
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateView() {
        
    }

    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        getImage(fromSourceType: .photoLibrary)
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
}

extension ProfileTableViewController {
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MockReminderGrams.mockReminderGrams.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myMessagesCell", for: indexPath) as? MyMessagesTableViewCell
     
    // Configure the cell...
    let reminderGram = MockReminderGrams.mockReminderGrams[indexPath.row]
    cell?.reminderGram = reminderGram
    return cell ?? UITableViewCell()
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           // Delete the row from the data source
           tableView.deleteRows(at: [indexPath], with: .fade)
       } else if editingStyle == .insert {
           // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "cellToMessageVC" {
            let destinationVC = segue.destination as? MessageDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let reminderGram = MockReminderGrams.mockReminderGrams[indexPath.row]
            destinationVC?.reminderGram = reminderGram
        }
    }
}
