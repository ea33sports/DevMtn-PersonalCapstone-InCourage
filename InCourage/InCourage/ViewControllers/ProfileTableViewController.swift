//
//  ProfileTableViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var profileHeaderView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var myLoveRatingLabel: UILabel!
    @IBOutlet weak var totalMessagesSentLabel: UILabel!
    @IBOutlet weak var whatIsLifeTextView: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var reminderGramSegmentedControl: UISegmentedControl!
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setUPUI()
        setUpGestures()
        spinner.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    // MARK: - Functions
    func setUPUI() {
        profileHeaderView.layer.shadowColor = UIColor.black.cgColor
        profileHeaderView.layer.shadowOpacity = 1
        profileHeaderView.layer.shadowOffset = CGSize.zero
        profileHeaderView.layer.shadowRadius = 2
    }
    
    
    func setUpGestures() {
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapImage)
        
        let tapAway: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapAway)
        tapAway.cancelsTouchesInView = false
    }
    
    
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
    
    
    @objc func imageTapped() {
        getImage(fromSourceType: .photoLibrary)
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    
    @objc func dismissKeyboard(){
        whatIsLifeTextView.endEditing(true)
        tableView.isUserInteractionEnabled = true
    }

    
    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func reminderGramSegmentedControllerChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
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
        
        var returnValue = 0
        
        switch reminderGramSegmentedControl.selectedSegmentIndex {
        case 0:
            returnValue = MockReminderGrams.mockReminderGrams.count
        case 1:
            returnValue = MockReminderGrams.mockReminderGrams.count
        default:
            break
        }
        
        return returnValue
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        guard let inboxCell = tableView.dequeueReusableCell(withIdentifier: "inboxCell", for: indexPath) as? MyMessagesTableViewCell,
            let outboxCell = tableView.dequeueReusableCell(withIdentifier: "outboxCell", for: indexPath) as? MyMessagesTableViewCell else { return UITableViewCell() }
        
        // Configure the cell...]
        let reminderGram = MockReminderGrams.mockReminderGrams[indexPath.row]
        switch reminderGramSegmentedControl.selectedSegmentIndex {
        case 0:
            inboxCell.reminderGram = reminderGram
            cell = inboxCell
        case 1:
            outboxCell.senderNameLabel.text = "Hey"
            outboxCell.messageSubjectLabel.text = "You!"
            cell = outboxCell
        default:
            inboxCell.reminderGram = reminderGram
            cell = inboxCell
        }
        
        return cell
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
    
        if segue.identifier == "inboxToDetailVC" {
            let destinationVC = segue.destination as? MessageDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let reminderGram = MockReminderGrams.mockReminderGrams[indexPath.row]
            destinationVC?.reminderGram = reminderGram
        } else if segue.identifier == "outboxToDetailVC" {
            let destinationVC = segue.destination as? MessageDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let reminderGram = MockReminderGrams.mockReminderGrams[indexPath.row]
            destinationVC?.reminderGram = reminderGram
        }
    }
}
