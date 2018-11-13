//
//  SnapPhotoViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Camera
enum CameraType {
    case Front
    case Back
}

class SnapPhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var capturedImageImageView: UIImageView!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var profileIcon: UIButton!
    @IBOutlet weak var searchIcon: UIButton!
    @IBOutlet weak var photoLibraryIcon: UIButton!
    @IBOutlet weak var snapPhotoButton: UIButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var camera: AVCaptureDevice?
    var cameraCheck = CameraType.Back
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var photoData: Data?
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification,  object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        spinner.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
        resetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        setupCamera()
    }
    
    
    
    // MARK: - Functions
    fileprivate func setupCamera() {
        if cameraCheck == CameraType.Front {
            
            camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
            
            do {
                
                let input = try AVCaptureDeviceInput(device: camera!)
                stillImageOutput = AVCapturePhotoOutput()
                
                if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addInput(input)
                    captureSession.addOutput(stillImageOutput)
                    profileIcon.layer.zPosition = 2
                    searchIcon.layer.zPosition = 2
                    photoLibraryIcon.layer.zPosition = 2
                    snapPhotoButton.layer.zPosition = 2
                    flipCameraButton.layer.zPosition = 2
                    setupLivePreview()
                }
                
            } catch let error {
                print("Error, Unable to initialize back camera: \(error.localizedDescription)")
            }
            
        } else if cameraCheck == CameraType.Back {
            
            camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
            
            do {
                
                let input = try AVCaptureDeviceInput(device: camera!)
                stillImageOutput = AVCapturePhotoOutput()
                
                if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addInput(input)
                    captureSession.addOutput(stillImageOutput)
                    profileIcon.layer.zPosition = 2
                    searchIcon.layer.zPosition = 2
                    photoLibraryIcon.layer.zPosition = 2
                    snapPhotoButton.layer.zPosition = 2
                    flipCameraButton.layer.zPosition = 2
                    setupLivePreview()
                }
                
            } catch let error {
                print("Error, Unable to initialize back camera: \(error.localizedDescription)")
            }
        }
    }

    
    func setupLivePreview() {
        previewView.isHidden = false
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    
    func configureSearchIcon() {
        
        if searchIcon.tag == 0 {
            searchIcon.backgroundColor = .yellow
            searchIcon.setImage(#imageLiteral(resourceName: "search"), for: .normal)
            
        } else if searchIcon.tag == 1 {
            searchIcon.backgroundColor = .blue
            searchIcon.setImage(#imageLiteral(resourceName: "cancelButton"), for: .normal)
        }
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        } else {
            photoData = photo.fileDataRepresentation()
            guard let image = UIImage(data: photoData!) else { return }
            capturedImageImageView.image = image
            
            spinner.stopAnimating()
            spinner.isHidden = true
            
            snapPhotoButton.tag = 1
            configureSnapSendButton()
        }
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

        dismiss(animated: true) {
            self.previewView.isHidden = true
            self.captureSession.stopRunning()
        }
        
        guard let chosenImage = info[.originalImage] as? UIImage else { return }//2
        capturedImageImageView.contentMode = .scaleAspectFit //3
        capturedImageImageView.image = chosenImage //4
        
        searchIcon.tag = 1
        configureSearchIcon()
        
        snapPhotoButton.tag = 1
        configureSnapSendButton()
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func hidesSearchBar() {
        searchBarContainer.isHidden = true
        
        profileIcon.isHidden = false
        
        searchIcon.tag = 0
        searchIcon.isHidden = false
        configureSearchIcon()
        
        photoLibraryIcon.isHidden = false
        snapPhotoButton.isHidden = false
        flipCameraButton.isHidden = false
        
        previewView.isHidden = false
        captureSession.startRunning()
    }
    
    
    func configureSnapSendButton() {
        if snapPhotoButton.tag == 0 {
            snapPhotoButton.backgroundColor = .yellow
            snapPhotoButton.setImage(#imageLiteral(resourceName: "snapPhoto"), for: .normal)
            
        } else if snapPhotoButton.tag == 1 {
            snapPhotoButton.backgroundColor = .blue
            snapPhotoButton.setImage(#imageLiteral(resourceName: "addBucketListItem"), for: .normal)
            shouldPerformSegue(withIdentifier: "sendReminderGram", sender: nil)
        }
    }
    
    func resetView() {
        capturedImageImageView.image = nil
        searchIcon.tag = 0
        configureSearchIcon()
        snapPhotoButton.tag = 0
        configureSnapSendButton()
    }
    
    
    @objc func appMovedToBackground() {
        captureSession.stopRunning()
    }
    
    
    @objc func appMovedToForeground() {
        captureSession.startRunning()
    }

    
    
    // MARK: - Actions
    @IBAction func searchCancelButtonTapped(_ sender: UIButton) {
        
        if searchIcon.tag == 0 {
            
            searchIcon.tag = 1
            searchBarContainer.isHidden = false
            
            profileIcon.isHidden = true
            searchIcon.isHidden = true
            photoLibraryIcon.isHidden = true
            snapPhotoButton.isHidden = true
            flipCameraButton.isHidden = true
            
            captureSession.stopRunning()
            previewView.isHidden = true
            
        } else if searchIcon.tag == 1 {
            
            searchIcon.tag = 0
            spinner.stopAnimating()
            spinner.isHidden = true
            capturedImageImageView.image = nil
            previewView.isHidden = false
            
            snapPhotoButton.tag = 0
            configureSnapSendButton()
            
            captureSession.startRunning()
        }
        
        configureSearchIcon()
    }
    
    
    @IBAction func photoLibraryButtonTapped(_ sender: UIButton) {
        getImage(fromSourceType: .photoLibrary)
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    
    @IBAction func snapPhotoButtonTapped(_ sender: UIButton) {
        
        if snapPhotoButton.tag == 0 {
            spinner.isHidden = false
            spinner.startAnimating()
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
            captureSession.stopRunning()
            previewView.isHidden = true
            sender.setImage(#imageLiteral(resourceName: "addBucketListItem"), for: .normal)
            searchIcon.tag = 1
            configureSearchIcon()
        } else if snapPhotoButton.tag == 1 {
//            guard let image = capturedImageImageView.image else { return }
//            ReminderGramController.shared.appendImage(image: image)
            performSegue(withIdentifier: "sendReminderGram", sender: nil)
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
    
    
    @IBAction func flipCameraButtonTapped(_ sender: UIButton) {
        
        captureSession.stopRunning()
        
        guard let oldInput = captureSession.inputs.first else { return }
        guard let oldOutput = captureSession.outputs.first else { return }
        captureSession.removeOutput(oldOutput)
        captureSession.removeInput(oldInput)

        if cameraCheck == CameraType.Back {
            cameraCheck = CameraType.Front
        } else {
            cameraCheck = CameraType.Back
        }
        
        setupCamera()
        captureSession.startRunning()
    }
}



extension SnapPhotoViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        let searchResultsVC = SearchReminderGramViewController()
        let searchController = UISearchController(searchResultsController: searchResultsVC)
        
        searchBarContainer.addSubview(searchController.searchBar)
        searchController.searchBar.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
        
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.autocorrectionType = .default
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.placeholder = "Search ReminderGrams"
        searchController.searchBar.barTintColor = .clear
        searchController.searchBar.tintColor = .black
        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchController.searchBar.layer.cornerRadius = 5
        searchController.searchBar.isTranslucent = true
        
        searchController.searchResultsUpdater = searchResultsVC
        definesPresentationContext = true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBarContainer.isHidden = true
        profileIcon.isHidden = false
        searchIcon.isHidden = false
        photoLibraryIcon.isHidden = false
        snapPhotoButton.isHidden = false
        flipCameraButton.isHidden = false
        
        searchIcon.tag = 0
        configureSearchIcon()
        
        previewView.isHidden = false
        captureSession.startRunning()
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        hidesSearchBar()
//    }
}



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
