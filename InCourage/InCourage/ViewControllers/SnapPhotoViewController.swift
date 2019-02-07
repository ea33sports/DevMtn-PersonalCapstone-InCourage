//
//  SnapPhotoViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseDatabase

// MARK: - Camera
enum CameraType {
    case Front
    case Back
}

class SnapPhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var capturedImageImageView: UIImageView!
    @IBOutlet weak var profileIcon: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var photoLibraryIcon: UIButton!
    @IBOutlet weak var snapPhotoButton: UIButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!



    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var cameraSetup: CameraSetup!
    var photoData: Data?
    
//    var camera: AVCaptureDevice?
//    var cameraCheck = CameraType.Back
//
//    var captureSession: AVCaptureSession!
//    var stillImageOutput: AVCapturePhotoOutput!
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    



    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification,  object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

//        captureSession = AVCaptureSession()
//        setupCamera()
//        setupLivePreview()
        initialize()
        fetchCurrentProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setUpUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if cameraSetup.captureSession.isRunning == false {
            cameraSetup.captureSession.startRunning()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        cameraSetup.captureSession.stopRunning()
        resetView()
    }



    // MARK: - Functions
    func initialize() {
        cameraSetup = CameraSetup()
        cameraSetup.captureDevice()
        cameraSetup.configureCaptureInput()
        cameraSetup.configureCaptureOutput()
        cameraSetup.configurePreviewLayer(view: previewView)
    }
    
    
    func setUpUI() {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        spinner.isHidden = true
    }


    func fetchCurrentProfile() {

        let fileURL = ProfileController.shared.fileURL()

        ProfileController.shared.loadFromPersistentStorage { (success) in
            if success {
                ProfileController.shared.fetchCurrentProfile(completion: { (success) in
                    if success {
                        self.profileIcon.isEnabled = true
                        self.photoLibraryIcon.isEnabled = true
                        self.snapPhotoButton.isEnabled = true
                        self.flipCameraButton.isEnabled = true
                        print("💰 SUCCESS ♔ We have a fetched profile!!")
                        print("🏗\(fileURL)")
                    }
                })

            } else {
                let uid = UUID().uuidString
                ProfileController.shared.createProfile(uid: uid)
                self.profileIcon.isEnabled = true
                self.photoLibraryIcon.isEnabled = true
                self.snapPhotoButton.isEnabled = true
                self.flipCameraButton.isEnabled = true
                print("🇰🇭✑ Welp we had to create a new profile, but we should be good now...")
                print("📫\(fileURL)")
            }
        }
    }


//    func fetchLoggedInUser() {
//
//        if Auth.auth().currentProfile?.uid != nil {
//            guard let uid = Auth.auth().currentProfile?.uid else { return }
//            Endpoint.database.collection("users").document(uid).getDocument { (snapshot, error) in
//                if let error = error {
//                    print("🎩 Error fetching user \(error) \(error.localizedDescription)")
//                }
//
//                if let document = snapshot {
//                    guard let userDictionary = document.data() else { return }
//                    ProfileController.shared.currentProfile = User(userDictionary: userDictionary)!
//                    ProfileController.shared.isUserLoggedIn = true
//                    print("✅ Successfully Fetched logged in user! \(Auth.auth().currentProfile?.email) 🐩\(ProfileController.shared.currentProfile?.username)")
//                }
//            }
//
//        } else {
//            print("⚠️User isn't logged in")
//        }
//    }


//    fileprivate func setupCamera() {
//        if cameraCheck == CameraType.Front {
//
//            camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
//
//            do {
//
//                let input = try AVCaptureDeviceInput(device: camera!)
//                stillImageOutput = AVCapturePhotoOutput()
//
//                if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
//                    captureSession.addInput(input)
//                    captureSession.addOutput(stillImageOutput)
//                    profileIcon.layer.zPosition = 2
//                    cancelButton.layer.zPosition = 2
//                    photoLibraryIcon.layer.zPosition = 2
//                    snapPhotoButton.layer.zPosition = 2
//                    flipCameraButton.layer.zPosition = 2
////                    setupLivePreview()
//                }
//
//            } catch let error {
//                print("Error, Unable to initialize back camera: \(error.localizedDescription)")
//            }
//
//        } else if cameraCheck == CameraType.Back {
//
//            camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
//
//            do {
//
//                let input = try AVCaptureDeviceInput(device: camera!)
//                stillImageOutput = AVCapturePhotoOutput()
//
//                if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
//                    captureSession.addInput(input)
//                    captureSession.addOutput(stillImageOutput)
//                    profileIcon.layer.zPosition = 2
//                    cancelButton.layer.zPosition = 2
//                    photoLibraryIcon.layer.zPosition = 2
//                    snapPhotoButton.layer.zPosition = 2
//                    flipCameraButton.layer.zPosition = 2
////                    setupLivePreview()
//                }
//
//            } catch let error {
//                print("Error, Unable to initialize back camera: \(error.localizedDescription)")
//            }
//        }
//    }
//
//
//    func switchCamera() {
//        captureSession.beginConfiguration()
//        guard let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput else { fatalError() }
//        captureSession.removeInput(currentInput)
//
//        guard let newCameraDevice = currentInput.device.position == .back ? getCamera(with: .front) : getCamera(with: .back),
//            let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice) else { fatalError() }
//        captureSession.addInput(newVideoInput)
//        captureSession.commitConfiguration()
//    }
//
//
//    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
//        guard let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] else {
//            return nil
//        }
//
//        return devices.filter {
//            $0.position == position
//            }.first
//    }
//
//
//    func setupLivePreview() {
//        previewView.isHidden = false
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer.videoGravity = .resizeAspect
//        videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//        previewView.layer.addSublayer(videoPreviewLayer)
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.captureSession.startRunning()
//
//            DispatchQueue.main.async {
//                self.videoPreviewLayer.frame = self.previewView.bounds
//            }
//        }
//    }


//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let error = error {
//            debugPrint("🧛🏽‍♀️ \(error) \(error.localizedDescription)")
//        } else {
//            photoData = photo.fileDataRepresentation()
//            guard let image = UIImage(data: photoData!) else { return }
//            capturedImageImageView.image = image
//
//            spinner.stopAnimating()
//            spinner.isHidden = true
//
//            snapPhotoButton.tag = 1
//            configureSnapSendButton()
//        }
//    }


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
        
        previewView.isHidden = true
        cameraSetup.captureSession.stopRunning()

        guard let chosenImage = info[.originalImage] as? UIImage else { return }//2
        capturedImageImageView.contentMode = .scaleAspectFit //3
        capturedImageImageView.image = chosenImage //4

        profileIcon.isHidden = true
        cancelButton.isHidden = false
        photoLibraryIcon.isHidden = true
        flipCameraButton.isHidden = true
        
        snapPhotoButton.tag = 1
        configureSnapSendButton()
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    func configureSnapSendButton() {
        if snapPhotoButton.tag == 0 {
            snapPhotoButton.setImage(#imageLiteral(resourceName: "snapPhoto-main"), for: .normal)

        } else if snapPhotoButton.tag == 1 {
            snapPhotoButton.setImage(#imageLiteral(resourceName: "okPhoto"), for: .normal)
            shouldPerformSegue(withIdentifier: "sendReminderGram", sender: nil)
        }
    }


    func resetView() {
        spinner.stopAnimating()
        spinner.isHidden = true
        capturedImageImageView.image = nil
        previewView.isHidden = false
        profileIcon.isHidden = false
        cancelButton.isHidden = true
        photoLibraryIcon.isHidden = false
        snapPhotoButton.tag = 0
        configureSnapSendButton()
        flipCameraButton.isHidden = false
    }


    @objc func appMovedToBackground() {
        cameraSetup.captureSession.stopRunning()
    }


    @objc func appMovedToForeground() {
        cameraSetup.captureSession.startRunning()
    }



    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        resetView()
        cameraSetup.captureSession.startRunning()
    }


    @IBAction func photoLibraryButtonTapped(_ sender: UIButton) {
        getImage(fromSourceType: .photoLibrary)
        spinner.isHidden = false
        spinner.startAnimating()
    }


    @IBAction func snapPhotoButtonTapped(_ sender: UIButton) {

        if snapPhotoButton.tag == 0 {
            
            sender.setImage(#imageLiteral(resourceName: "snapPhoto-animate"), for: .normal)
            spinner.isHidden = false
            spinner.startAnimating()
            cameraSetup.captureImage {(image, error) in
                
                sender.setImage(#imageLiteral(resourceName: "snapPhoto-main"), for: .normal)
                
                guard let image = image else {
                    print(error ?? "🛠 Image capture error: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                self.previewView.isHidden = true
                self.profileIcon.isHidden = true
                self.cancelButton.isHidden = false
                self.photoLibraryIcon.isHidden = true
                self.flipCameraButton.isHidden = true
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                
                self.capturedImageImageView.image = image
                self.snapPhotoButton.tag = 1
                self.configureSnapSendButton()
            }
            
//            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
//            stillImageOutput.capturePhoto(with: settings, delegate: self)
            
        } else if snapPhotoButton.tag == 1 {
            performSegue(withIdentifier: "sendReminderGram", sender: nil)
            resetView()
        }

//        snapPhotoButton.tag += 1
//        if snapPhotoButton.tag > 1 { snapPhotoButton.tag = 0 }
//        switch snapPhotoButton.tag {
//        case 0:
//            spinner.isHidden = false
//            spinner.startAnimating()
//            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
//            stillImageOutput.capturePhoto(with: settings, delegate: self)
//            captureSession.stopRunning()
//            previewView.isHidden = true
//            sender.setImage(#imageLiteral(resourceName: "addBucketListItem"), for: .normal)
//            searchIcon.tag = 1
//            configureSearchIcon()
//        case 1:
//            performSegue(withIdentifier: "sendReminderGram", sender: self)
//        default:
//            snapPhotoButton.tag = 0
//        }
    }


    @IBAction func unwindToSnapPhotoVC(segue: UIStoryboardSegue) { }


    @IBAction func flipCameraButtonTapped(_ sender: UIButton) {

        let blurView = UIVisualEffectView(frame: previewView.bounds)
        blurView.effect = UIBlurEffect(style: .light)
        previewView.addSubview(blurView)

        if cameraSetup.currentCam?.position == .back {
            UIView.transition(with: previewView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil) { (success) in
                self.cameraSetup.toggleCam()
                blurView.removeFromSuperview()
            }

        } else {
            UIView.transition(with: previewView, duration: 0.5, options: .transitionFlipFromRight, animations: nil) { (success) in
                self.cameraSetup.toggleCam()
                blurView.removeFromSuperview()
            }
        }
    }
}



//extension SnapPhotoViewController: UISearchBarDelegate {
//
//    func setupSearchBar() {
//        let searchResultsVC = SearchReminderGramViewController()
//        let searchController = UISearchController(searchResultsController: searchResultsVC)
//
//        searchBarContainer.addSubview(searchController.searchBar)
//        searchController.searchBar.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
//        searchController.searchBar.delegate = self
//        searchController.dimsBackgroundDuringPresentation = true
//        navigationItem.searchController = searchController
//
//        searchController.searchBar.searchBarStyle = .minimal
//        searchController.searchBar.autocorrectionType = .default
//        searchController.searchBar.enablesReturnKeyAutomatically = true
//        searchController.searchBar.placeholder = "Search ReminderGrams"
//        searchController.searchBar.barTintColor = .clear
//        searchController.searchBar.tintColor = .black
//        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        searchController.searchBar.layer.cornerRadius = 5
//        searchController.searchBar.isTranslucent = true
//
//        searchController.searchResultsUpdater = searchResultsVC
//        definesPresentationContext = true
//    }
//
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//
//        searchBarContainer.isHidden = true
//        profileIcon.isHidden = false
//        searchIcon.isHidden = false
//        photoLibraryIcon.isHidden = false
//        snapPhotoButton.isHidden = false
//        flipCameraButton.isHidden = false
//
//        searchIcon.tag = 0
//        configureSearchIcon()
//
//        previewView.isHidden = false
//        captureSession.startRunning()
//    }
//
//
////    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////
////        hidesSearchBar()
////    }
//}



extension SnapPhotoViewController {

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        if segue.identifier == "sendReminderGram" {
            let destinationVC = segue.destination as? ComposeReminderGramViewController
            destinationVC?.selectedPhoto = capturedImageImageView.image
        }
    }
}
