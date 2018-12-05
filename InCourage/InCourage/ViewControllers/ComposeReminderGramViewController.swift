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
    @IBOutlet weak var recipientTextField: UITextField!
    @IBOutlet weak var recipientTableView: UITableView!
    @IBOutlet weak var reminderGramPhoto: UIImageView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var reminderGramMessageTextView: UITextView!
    
    
    
    // MARK: - Properties
    var reminderGram: ReminderGram?
    var selectedPhoto: UIImage?
    var usernameArray: [String] = []
    var receiver: User?
    var searching = false
    var activeTextField = UITextField()
    
    var filteredUser: [User] = [] {
        didSet{
            DispatchQueue.main.async {
                self.recipientTableView.reloadData()
            }
        }
    }
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // addStateDidChangeListener
        updateView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // removeStateDidChangeListener
    }
    
    
    
    // MARK: - Functions
    func updateView() {
        recipientTextField.delegate = self
        recipientTextField.clearButtonMode = .always
        recipientTableView.delegate = self
        recipientTableView.dataSource = self
        recipientTableView.keyboardDismissMode = .onDrag
        recipientTableView.isHidden = true
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
        
        if view.frame.origin.y == 0 && recipientTextField != activeTextField {
            view.frame.origin.y -= keyboardFrame.height
        } else if view.frame.origin.y != 0 && recipientTextField != activeTextField {
            view.frame.origin.y = 0
        }
    }
    
    
    func uploadReminderGramImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        
        if let data = image.jpegData(compressionQuality: 0.4) {
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let reminderGramImageStoragePath = Storage.storage().reference(withPath: "reminderGramImages").child("\(String(describing: self.receiver?.uid))").child("\(String(describing: self.reminderGram?.uid)).png")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            reminderGramImageStoragePath.putData(data, metadata: metaData) { (_, error) in
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
            }
            
            reminderGramImageStoragePath.downloadURL { (url, error) in
                guard let url = url else { return }
                completion(url)
            }
        }
    }
    
    
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
    
    
    func saveReminderGram(reminderGram: ReminderGram, completion: @escaping (Bool) -> ()) {
        let dataToSave = reminderGram.firebaseDictionary
        if reminderGram.uid != "" {
            let ref = Endpoint.database.collection("reminderGrams").document(reminderGram.uid)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("***Error Saving ReminderGram \(error) \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("^^^Successfully saved ReminderGram!! UID: \(reminderGram.uid)")
                    completion(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // Let firestore create the new document
            ref = Endpoint.database.collection("reminderGrams").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*^*Error creating new ReminderGram \(error) \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("^*^Successfully created ReminderGram!! UID: \(reminderGram.uid)")
                    reminderGram.uid = (ref?.documentID)!
                    completion(true)
                }
            }
        }
    }

    
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func recipeintTextFieldEditingDidChange(_ sender: UITextField) {
        
        if let searchText = recipientTextField.text, !searchText.isEmpty {
            
            filteredUser.removeAll()
            recipientTableView.isHidden = false
            
            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)
            
            Endpoint.database.collection("users").whereField("FBSearchDictionary", arrayContains: trimmedSearchText.lowercased()).getDocuments { (snapshot, error) in
                guard let docs = snapshot?.documents else { return }
                if let error = error {
                    print("Error fetching users \(error) \(error.localizedDescription)")
                } else {
                    for doc in docs {
                        guard let user = User(userDictionary: doc.data()) else { return }
                        
                        self.filteredUser.append(user)
                        self.searching = true
                        print(searchText)
                        print(user.username)
                    }
                }
            }
            
        } else {
            searching = false
            recipientTableView.isHidden = true
        }
        
        
    }
    
    
    @IBAction func colorPickerButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        let uid = UUID().uuidString
        
        guard let sender = UserController.shared.currentUser,
            let receiver = receiver,
            let image = reminderGramPhoto.image,
            let subject = subjectTextField.text,
            let message = reminderGramMessageTextView.text,
            recipientTextField.text != nil else { return }
        
        uploadReminderGramImage(image) { (url) in
            guard let url = url else { return }
            guard var reminderGram = self.reminderGram else { return }
            reminderGram = ReminderGram(uid: uid, sender: sender, receiver: receiver, image: url.absoluteString, subject: subject, message: message, loveRating: 0)
            self.saveReminderGram(reminderGram: reminderGram, completion: { (success) in
                if success {
                    print("SUCCESS!!")
                } else {
                    print("👓 Couldn't save data")
                }
            })
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}



extension ComposeReminderGramViewController: UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reminderGramMessageTextView.textColor == UIColor.lightGray {
            reminderGramMessageTextView.text = nil
            reminderGramMessageTextView.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reminderGramMessageTextView.text.isEmpty {
            reminderGramMessageTextView.text = "Enter your message..."
            reminderGramMessageTextView.textColor = UIColor.lightGray
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            reminderGramMessageTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUser.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipientTableView.dequeueReusableCell(withIdentifier: "recipientCell", for: indexPath)
        
        // Configure the cell
        let filteredDataItem = filteredUser[indexPath.row].username
        cell.textLabel?.text = filteredDataItem
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        receiver = filteredUser[indexPath.row]
        recipientTextField.text = receiver?.username
        recipientTableView.isHidden = true
        recipientTextField.resignFirstResponder()
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
