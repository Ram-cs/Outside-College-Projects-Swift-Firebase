//
//  CameraController.swift
//  Instagram
//
//  Created by Ram Yadav on 9/19/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//


//video - 30, capture photo
import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
  func handleCapturePhoto() {
        print("caputring photo")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHUD()
        setUpCaptureSession()
    }
    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(left: nil, leftPadding: 0, right: nil, rightPadding: 0, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -24, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(left: nil, leftPadding: 0, right: view.rightAnchor, rightPadding: -12, top: view.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, width: 50, height: 50)
    }
    
    fileprivate func setUpCaptureSession() {
        let captureSession = AVCaptureSession()
       //1. setUpInput
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
        } catch let error {
            print("could not setup Camera input", error)
        }
        
        
        //2. setUpOutput
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        //3. setUpOutputPreview
        
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {return}
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
}
