//
//  ComposeReminderGramViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ComposeReminderGramViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var reminderGramPhotoContainer: UIView!
    @IBOutlet weak var reminderGramPhoto: UIImageView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var reminderGramMessageTextView: UITextView!
    
    
    
    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    var reminderGram: ReminderGram?
    var selectedPhoto: UIImage?
//    var usernameArray: [String] = []
//    var receiver: User?
//    var searching = false
//
//    var filteredUser: [User] = [] {
//        didSet{
//            DispatchQueue.main.async {
//                self.recipientTableView.reloadData()
//            }
//        }
//    }
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // addStateDidChangeListener
        setUpUI()
        updateView()
    }
    
    
    
    // MARK: - Functions
    func setUpUI() {
        
        view.addVerticalGradientLayer(topColor: #colorLiteral(red: 0.4054282904, green: 0.6722337604, blue: 0.9481148124, alpha: 1), bottomColor: #colorLiteral(red: 0.8486813903, green: 0.935580194, blue: 0.9688618779, alpha: 1))
        
        reminderGramPhotoContainer.layer.borderWidth = 1
        reminderGramPhotoContainer.layer.masksToBounds = false
        reminderGramPhotoContainer.layer.borderColor = UIColor.clear.cgColor
        reminderGramPhotoContainer.layer.cornerRadius = reminderGramPhotoContainer.frame.height / 8
        reminderGramPhotoContainer.clipsToBounds = true
        
        reminderGramPhoto.layer.borderWidth = 1
        reminderGramPhoto.layer.masksToBounds = false
        reminderGramPhoto.layer.borderColor = UIColor.clear.cgColor
        reminderGramPhoto.layer.cornerRadius = reminderGramPhoto.frame.height / 8
        reminderGramPhoto.clipsToBounds = true
    }
    
    
    func updateView() {
//        recipientTextField.delegate = self
//        recipientTextField.clearButtonMode = .always
//        recipientTableView.delegate = self
//        recipientTableView.dataSource = self
//        recipientTableView.keyboardDismissMode = .onDrag
//        recipientTableView.isHidden = true
        reminderGramPhoto.image = selectedPhoto
        subjectTextField.delegate = self
        reminderGramMessageTextView.delegate = self
        reminderGramMessageTextView.text = "Enter your message..."
        reminderGramMessageTextView.textColor = UIColor.lightGray
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {

        guard let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue

        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardFrame.height
            view.layoutIfNeeded()
            
        } else if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
            view.layoutIfNeeded()
        }
    }
    
    
//    func uploadReminderGramImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
//
//        guard let data = image.jpegData(compressionQuality: 0.4) else { fatalError() }
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpeg"
//
//        let reminderGramImageStoragePath = Storage.storage().reference(withPath: "reminderGramImages").child("\(uid).png")
//
//        reminderGramImageStoragePath.putData(data, metadata: metaData) { (_, error) in
//
//            if let error = error {
//                print(error)
//                completion(nil)
//                return
//            }
//
//            reminderGramImageStoragePath.downloadURL { (url, error) in
//                if let error = error {
//                    print("🙇🏽‍♀️\(error) \(error.localizedDescription)")
//                    completion(nil)
//                }
//                guard let url = url else { fatalError() }
//                completion(url)
//            }
//        }
//    }
    
    
//    func saveReminderGram(_ reminderGram: ReminderGram) {
//        Endpoint.database.collection("reminderGrams").addDocument(data: reminderGram.firebaseDictionary) { error in
//            if let error = error {
//                print("Error sending message: \(error.localizedDescription)")
//                return
//            }
//        }
//    }
    
    
//    func saveReminderGram(_ reminderGram: ReminderGram) {
//        Endpoint.database.collection("reminderGrams").document(reminderGram.uid).setData(reminderGram.firebaseDictionary) { error in
//            if let error = error {
//                print("Error sending message: \(error.localizedDescription)")
//                return
//            }
//        }
//    }
    
    
//    func saveReminderGram(reminderGram: ReminderGram, completion: @escaping (Bool) -> ()) {
//        let dataToSave = reminderGram.firebaseDictionary
//        if reminderGram.uid != "" {
//            let ref = Endpoint.database.collection("reminderGrams").document(reminderGram.uid)
//            ref.setData(dataToSave, completion: { (error) in
//                if let error = error {
//                    print("***Error Saving ReminderGram \(error) \(error.localizedDescription)")
//                    completion(false)
//                } else {
//                    print("^^^Successfully saved ReminderGram!! UID: \(reminderGram.uid)")
//                    completion(true)
//                }
//            })
//        } else {
//            var ref: DocumentReference? = nil // Let firestore create the new document
//            ref = Endpoint.database.collection("reminderGrams").addDocument(data: dataToSave) { error in
//                if let error = error {
//                    print("*^*Error creating new ReminderGram \(error) \(error.localizedDescription)")
//                    completion(false)
//                } else {
//                    print("^*^Successfully created ReminderGram!! UID: \(reminderGram.uid)")
//                    reminderGram.uid = (ref?.documentID)!
//                    completion(true)
//                }
//            }
//        }
//    }
    
//    func saveReminderGram(reminderGram: ReminderGram, completion: @escaping (Bool) -> ()) {
//        let dataToSave = reminderGram.firebaseDictionary
//        let ref = Endpoint.database.collection("reminderGrams").document(reminderGram.uid)
//        ref.setData(dataToSave, completion: { (error) in
//            if let error = error {
//                print("***Error Saving ReminderGram \(error) \(error.localizedDescription)")
//                completion(false)
//            } else {
//                print("^^^Successfully saved ReminderGram!! UID: \(reminderGram.uid)")
//                completion(true)
//            }
//        })
//    }

    
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func recipeintTextFieldEditingDidChange(_ sender: UITextField) {
        
//        if let searchText = recipientTextField.text, !searchText.isEmpty {
//
//            filteredUser.removeAll()
//            recipientTableView.isHidden = false
//
//            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)
//
//            Endpoint.database.collection("users").whereField("username", isEqualTo: trimmedSearchText.lowercased()).getDocuments { (snapshot, error) in
//                guard let docs = snapshot?.documents else { return }
//                if let error = error {
//                    print("Error fetching users \(error) \(error.localizedDescription)")
//                } else {
//                    for doc in docs {
//                        guard let user = User(userDictionary: doc.data()) else { fatalError() }
//                        self.filteredUser.append(user)
//                        print(searchText)
//                        print(user.username)
//                    }
//                }
//            }
        
//            Endpoint.database.collection("users").whereField("FBSearchDictionary", arrayContains: trimmedSearchText.lowercased()).getDocuments { (snapshot, error) in
//                guard let docs = snapshot?.documents else { return }
//                if let error = error {
//                    print("Error fetching users \(error) \(error.localizedDescription)")
//                } else {
//                    for doc in docs {
//                        guard let user = User(userDictionary: doc.data()) else { fatalError() }
//
//                        self.filteredUser.append(user)
//                        self.searching = true
//                        print(searchText)
//                        print(user.username)
//                    }
//                }
//            }
            
//        } else {
//            searching = false
//            recipientTableView.isHidden = true
//        }
    }
    
    
    @IBAction func colorPickerButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        let uid = UUID().uuidString
        
        guard let image = reminderGramPhoto.image,
            let subject = subjectTextField.text,
            let message = reminderGramMessageTextView.text else { return }
        
        ReminderGramController.shared.createReminderGram(uid: uid, image: image, subject: subject, message: message)
        self.dismiss(animated: true, completion: nil)
        
        
        
//        uploadReminderGramImage(image) { (url) in
//            guard let url = url else { fatalError() }
//            self.reminderGram = ReminderGram(uid: self.uid, sender: sender.uid, receiver: receiver.uid, image: url.absoluteString, subject: subject, message: message)
//
////            guard let reminderGram = self.reminderGram else { return }
//            sender.reminderGramOutboxIDs.append(self.reminderGram!.uid)
//            receiver.reminderGramInboxIDs.append(self.reminderGram!.uid)
//            sender.totalReminderGramsSent += 1
//
//            print("🐝\(String(describing: sender.reminderGramOutboxIDs.last))")
//            print("🦅\(String(describing: sender.totalReminderGramsSent))")
//            print("🌯\(String(describing: receiver.reminderGramInboxIDs.last))")
//
//            self.saveReminderGram(reminderGram: self.reminderGram!, completion: { (success) in
//
//                print("🍣\(String(describing: sender.reminderGramOutboxIDs.last))")
//                print("🍼\(String(describing: receiver.reminderGramInboxIDs.last))")
//
//                if success {
//                    Endpoint.database.collection("users").document(sender.uid).updateData(["reminderGramOutboxIDs" : sender.reminderGramOutboxIDs])
//                    Endpoint.database.collection("users").document(receiver.uid).updateData(["reminderGramInboxIDs" : receiver.reminderGramInboxIDs])
//                    Endpoint.database.collection("users").document(sender.uid).updateData(["totalReminderGramsSent" : sender.totalReminderGramsSent])
//                    print("SUCCESS!!!")
//                } else {
//                    print("👓 Couldn't save data")
//                }
//            })
//        }
    }
}



extension ComposeReminderGramViewController: UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: - UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if reminderGramMessageTextView.textColor == UIColor.lightGray {
            reminderGramMessageTextView.text = nil
            reminderGramMessageTextView.textColor = UIColor.black
        }
        
        view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if reminderGramMessageTextView.text.isEmpty {
            reminderGramMessageTextView.text = "Enter your message..."
            reminderGramMessageTextView.textColor = UIColor.lightGray
        }
        
        view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + 8).isActive = true
            reminderGramMessageTextView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    
    
    // MARK: - UITableView DataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredUser.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = recipientTableView.dequeueReusableCell(withIdentifier: "recipientCell", for: indexPath)
//
//        // Configure the cell
//        let filteredDataItem = filteredUser[indexPath.row].username
//        cell.textLabel?.text = filteredDataItem
//
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        receiver = filteredUser[indexPath.row]
//        recipientTextField.text = receiver?.username
//        recipientTableView.isHidden = true
//        recipientTextField.resignFirstResponder()
//    }
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
