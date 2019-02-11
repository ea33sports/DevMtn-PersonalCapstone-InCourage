//
//  ProfileTableViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var profileHeaderView: UIView!
    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var whatIsLifeTextView: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    // MARK: - Variables
    var statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    var reminderGrams: [ReminderGram] = []
    
    var hideTableViewView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    var hideHeight: CGFloat?
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateReminderGrams), name: NSNotification.Name(rawValue: "load"), object: nil)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.isUserInteractionEnabled = false
        setUpGestures()
        spinner.isHidden = true
        whatIsLifeTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUPUI()
        updateView()
    }
    
    
    
    // MARK: - Functions
    func setUPUI() {
        
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        tableView.contentInset.top = -statusBarHeight
        
        guard let tableViewHeaderView = tableView.tableHeaderView else { return }
        tableViewHeaderView.frame.size = CGSize(width: tableView.frame.width, height: 334 + statusBarHeight)
        
        profileTitleLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: statusBarHeight + 12).isActive = true
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.hideTableViewView.alpha = 0
        }, completion: nil)
    }
    
    
    func setUpGestures() {
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapImage)
        
        let tapAway: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapAway)
        tapAway.cancelsTouchesInView = false
    }
    
    
    func updateView() {
        
        guard let currentProfile = ProfileController.shared.currentProfile,
            let profilePic = ProfileController.shared.currentProfile?.profilePic else { return }
        
        
        if profilePic != "" {
            StorageManager.shared.downloadProfileImages(folderPath: "profileImages", success: { (image) in
                DispatchQueue.main.async {
                    self.profileImageView.image = image
//                    print("🌷 Got the image to load!")
                }
            }) { (error) in
//                print(error, error.localizedDescription)
            }
        } else {
            profileImageView.image = #imageLiteral(resourceName: "user-male")
        }
        
        whatIsLifeTextView.text = currentProfile.lifePerspective
        
        ReminderGramController.shared.fetchReminderGrams(ids: currentProfile.reminderGramIDs) { (reminderGrams) in
            self.reminderGrams = reminderGrams.sorted(by: { $0.loveRating > $1.loveRating })
            self.tableView.reloadData()
            
            self.hideHeight = CGFloat(reminderGrams.count) * 80
            self.setupHideTableViewView()
            self.tableView.isUserInteractionEnabled = true
            
//            print("🛠 Successfully fetched reminderGrams!!")
//            print("🚴🏽‍♂️ \(self.reminderGrams.count)")
        }
    }
    
    
    func clearView() {
        profileImageView.image = #imageLiteral(resourceName: "profileIcon")
        whatIsLifeTextView.text = ""
        tableView.reloadData()
    }
    
    @objc func updateReminderGrams() {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.hideTableViewView.alpha = 0
        }, completion: nil)
        
        updateView()
    }
    
    
//    func fetchUser() {
//        Endpoint.database.collection("users").document((ProfileController.shared.currentProfile?.uid)!).getDocument { (snapshot, error) in
//            if let error = error {
//                print("😤 Error getting user \(error) \(error.localizedDescription)")
//            }
//            
//            if let documents = snapshot {
//                guard let profileDictionary = documents.data() else { return }
//                ProfileController.shared.currentProfile = Profile(profileDictionary: profileDictionary)
//            }
//        }
//    }
//    
//    
//    func fetchReminderGrams(ids: [String], completion: @escaping ([ReminderGram]) -> Void) {
//
//        Endpoint.database.collection("reminderGrams").getDocuments { (snapshot, error) in
//            if let error = error {
//                print("😤 Error getting reminderGrams \(error) \(error.localizedDescription)")
//            }
//
//            if let documents = snapshot {
//                let reminderGramDictionaries = documents.documents.map({ $0.data() })
//                let result = reminderGramDictionaries.map({ ReminderGram.init(reminderGramDictionary: $0) }).compactMap({ $0 }).filter({ ids.contains( ($0.uid) ) })
//                completion(result)
//            }
//        }
//    }
    
    
    func saveChanges() {
        guard let currentProfile = ProfileController.shared.currentProfile else { return }
        currentProfile.lifePerspective = whatIsLifeTextView.text
        Endpoint.database.collection("profiles").document(currentProfile.uid).updateData(["lifePerspective" : currentProfile.lifePerspective])
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
        guard let chosenImage = info[.originalImage] as? UIImage else { return }//2
        
        guard let currentProfile = ProfileController.shared.currentProfile else { return }
        StorageManager.shared.uploadProfileImage(chosenImage) { (url) in
            if let url = url {
                currentProfile.profilePic = url.absoluteString
                Endpoint.database.collection("profiles").document(currentProfile.uid).updateData(["profilePic" : url.absoluteString], completion: { (errer) in
                    
                    if let error = errer {
                        print(error)
                    }
                    
                    self.profileImageView.image = chosenImage //4
//                    print("⚡︎ We have Image \(currentProfile.profilePic)")
                })
            }
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func imageTapped() {
        getImage(fromSourceType: .photoLibrary)
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        saveChanges()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 164
    }
    
    
    @objc func dismissKeyboard(){
        saveChanges()
        whatIsLifeTextView.endEditing(true)
        tableView.isUserInteractionEnabled = true
    }
    
    
    fileprivate func setupHideTableViewView() {
        
        guard let header = tableView.tableHeaderView,
            let hideHeight = hideHeight else { fatalError() }
        
        view.addSubview(hideTableViewView)
        hideTableViewView.translatesAutoresizingMaskIntoConstraints = false
        
        hideTableViewView.topAnchor.constraint(equalTo: header.topAnchor, constant: (334 + statusBarHeight)).isActive = true
        hideTableViewView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 0).isActive = true
        hideTableViewView.rightAnchor.constraint(equalTo: header.rightAnchor, constant: 0).isActive = true
        hideTableViewView.heightAnchor.constraint(equalToConstant: hideHeight).isActive = true
        
        hideTableViewView.updateConstraints()
        hideTableViewView.layoutIfNeeded()
    }

    
    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(transition, forKey: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        dismiss(animated: false, completion: nil)
    }
    
    
//    @IBAction func menuButtonTapped(_ sender: UIButton) {
//
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        let loginButton = UIAlertAction(title: "Log In", style: .default) { (action) in
//            // Present LoginVC
//            self.performSegue(withIdentifier: "inAppLogin", sender: self)
//        }
//
//        let logoutButton = UIAlertAction(title: "Log Out", style: .default) { (action) in
//            do {
//                try Endpoint.auth.signOut()
//                ProfileController.shared.currentProfile = nil
//                self.clearView()
//                print("Logged out. \(String(describing: Auth.auth().currentUser?.email))")
//            } catch {
//                print("Could not log out the user")
//            }
//            ProfileController.shared.isUserLoggedIn = false
//        }
//
//        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        actionSheet.addAction(loginButton)
//        actionSheet.addAction(logoutButton)
//        actionSheet.addAction(cancelButton)
//
//        present(actionSheet, animated: true)
//    }
    
    
//    @IBAction func reminderGramSegmentedControllerChanged(_ sender: UISegmentedControl) {
//        tableView.reloadData()
//    }
}



extension ProfileTableViewController {
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminderGrams.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reminderGramCell", for: indexPath) as? MyReminderGramsTableViewCell else { return UITableViewCell() }
        let reminderGram = reminderGrams[indexPath.row]
        cell.reminderGram = reminderGram
        
        return cell
        
//        var cell = UITableViewCell()
//
//        if self.reminderGramSegmentedControl.selectedSegmentIndex == 0 {
//            let inboxCell = tableView.dequeueReusableCell(withIdentifier: "inboxCell", for: indexPath) as? MyInboxTableViewCell
//            let reminderGramsReceived = inbox[indexPath.row]
//            inboxCell?.reminderGram = reminderGramsReceived
//            cell = inboxCell!
//        } else if self.reminderGramSegmentedControl.selectedSegmentIndex == 1 {
//            let outboxCell = tableView.dequeueReusableCell(withIdentifier: "outboxCell", for: indexPath) as? MyOutboxTableViewCell
//            let reminderGramsSent = outbox[indexPath.row]
//            outboxCell?.reminderGram = reminderGramsSent
//            cell = outboxCell!
//        }
//
//        return cell
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
            let reminderGram = reminderGrams[indexPath.row]
            guard let index = reminderGrams.index(of: reminderGram) else { return }
            reminderGrams.remove(at: index)
            ReminderGramController.shared.removeReminderGram(reminderGram: reminderGram)
        
            tableView.deleteRows(at: [indexPath], with: .fade)
        
            hideTableViewView.updateConstraints()
        
       } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       }
    }

    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailVC" {
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.hideTableViewView.alpha = 1
            }, completion: nil)
            
            let destinationVC = segue.destination as? MessageDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let reminderGram = reminderGrams[indexPath.row]
            destinationVC?.reminderGram = reminderGram
        }
        
//        if segue.identifier == "inboxToDetailVC" {
//            let destinationVC = segue.destination as? MessageDetailViewController
//            guard let indexPath = tableView.indexPathForSelectedRow else { return }
//            let reminderGram = inbox[indexPath.row]
//            destinationVC?.reminderGram = reminderGram
//            destinationVC?.fetchSender(id: reminderGram.sender, completion: { (sender) in
//                destinationVC?.senderUser = sender
//                destinationVC?.loveRatingView.isHidden = false
//                destinationVC?.updateView()
//            })
//        } else if segue.identifier == "outboxToDetailVC" {
//            let destinationVC = segue.destination as? MessageDetailViewController
//            guard let indexPath = tableView.indexPathForSelectedRow else { return }
//            let reminderGram = outbox[indexPath.row]
//            destinationVC?.reminderGram = reminderGram
//            destinationVC?.fetchReceiver(id: reminderGram.receiver, completion: { (receiver) in
//                destinationVC?.receiverUser = receiver
//                destinationVC?.loveRatingView.isHidden = true
//                destinationVC?.updateView()
//            })
//        }
    }
}
