//
//  CameraSetup.swift
//  InCourage
//
//  Created by Eric Andersen on 2/3/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CameraSetup: NSObject {
    var flashMode = AVCaptureDevice.FlashMode.off
    //camera session
    var captureSession = AVCaptureSession()
    //camera available in iphone
    var frontCam: AVCaptureDevice?
    var rearCam: AVCaptureDevice?
    var currentCam: AVCaptureDevice?
    //input and output
    var captureInput: AVCaptureDeviceInput?
    var captureOutput: AVCapturePhotoOutput?
    //camera preview layer
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
}



extension CameraSetup {
    
    func captureDevice() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video , position: .unspecified)
        for d in discoverySession.devices {
            if d.position == .front{
                frontCam = d
            }
                
            else if d.position == .back {
                rearCam = d
                do {
                    try rearCam?.lockForConfiguration()
                    rearCam?.focusMode = .continuousAutoFocus
                    rearCam?.unlockForConfiguration()
                }
                    
                catch let error{
                    print(error)
                }
            }
        }
    }
    
    
    func configureCaptureInput() {
        currentCam = rearCam!
        do {
            captureInput = try AVCaptureDeviceInput(device: currentCam!)
            if captureSession.canAddInput(captureInput!) {
                captureSession.addInput(captureInput!)
            }
        }
            
        catch let error {
            print(error)
        }
    }
    
    
    func configureCaptureOutput() {
        captureOutput = AVCapturePhotoOutput()
        captureOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        if captureSession.canAddOutput(captureOutput!) {
            captureSession.addOutput(captureOutput!)
        }
        
        captureSession.startRunning()
    }
    
    
    func configurePreviewLayer(view: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(previewLayer!, at: 0)
        previewLayer?.frame = UIScreen.main.bounds
    }
    
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        let settings = AVCapturePhotoSettings()
        
//        guard let frontCam = frontCam,
//            let rearCam = rearCam else { return }
//        if frontCam.hasFlash {
//            settings.flashMode = self.flashMode
//        } else {
//            settings.flashMode = .off
//        }
//        if rearCam.hasFlash {
//            settings.flashMode = self.flashMode
//        } else {
//            settings.flashMode = .off
//        }
        
        settings.flashMode = .off
        
        self.captureOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
        self.photoCaptureCompletionBlock = completion
    }
    
    
    func toggleCam() {
        captureSession.beginConfiguration()
        let newCam = (currentCam?.position == .front) ? rearCam : frontCam
        
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        currentCam = newCam
        do {
            captureInput = try AVCaptureDeviceInput(device: currentCam!)
            if captureSession.canAddInput(captureInput!){
                captureSession.addInput(captureInput!)
            }
        }
            
        catch let error {
            print(error)
        }
        
        captureSession.commitConfiguration()
    }
}



extension CameraSetup: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let x = error {
            self.photoCaptureCompletionBlock?(nil, x)
            
        }
            
        else if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            self.photoCaptureCompletionBlock?(image, nil)
        }
    }
}
