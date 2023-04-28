//
//  ViewController.swift
//  LearningAVFoundation
//
//  Created by Long Bảo on 21/04/2023.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {
    //MARK: - Properties
    private var captureSession: AVCaptureSession!
    private var backCamera: AVCaptureDevice!
    private var frontCamera: AVCaptureDevice!
    private var backInputCamera: AVCaptureDeviceInput!
    private var frontInputCamera: AVCaptureDeviceInput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var videoOutput: AVCaptureVideoDataOutput!
    
    private var isTakePicture = false
    private var isBackCameraOn = true
    private var isFlashModeOn = false

    private lazy var capturedImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var capturedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.handleCaptureButtonTapped), for: .touchUpInside)
        button.setTitle("Chụp ảnh", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
//        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        return button
    }()
    
    private lazy var toggleFlashModeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.handleToggleFlashModeButtonModeTapped), for: .touchUpInside)
        button.setTitle("Flash", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
//        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        return button
    }()
    
    private lazy var switchCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.handleSwitchCameraButtonTapped), for: .touchUpInside)
        button.setTitle("Switch Camera", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
//        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        return button
    }()
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.configureUI()
        self.requestAuthorization()
        self.setupAndStartCaptureSession()
    }
    
    func configureUI() {
        view.addSubview(capturedImage)
        view.addSubview(capturedButton)
        view.addSubview(switchCameraButton)
        view.addSubview(toggleFlashModeButton)
        
        self.capturedImage.backgroundColor = .white
        NSLayoutConstraint.activate([
            capturedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            capturedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            capturedImage.widthAnchor.constraint(equalToConstant: 115),
            capturedImage.heightAnchor.constraint(equalToConstant: 180),
            capturedImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            capturedImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            switchCameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            switchCameraButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            toggleFlashModeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            toggleFlashModeButton.rightAnchor.constraint(equalTo: switchCameraButton.leftAnchor, constant: -25),
        ])
    }
    
    //MARK: - Helpers
    private func requestAuthorization() {
        if PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized {
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .denied:
                print("DEBUG: user denied")
            case .authorized:
                print("DEBUG: user authorized")
            case .limited:
                print("DEBUG: user limited")
            default:
                print("DEBUG: default")
            }
        }
            
    }
    
    
    
    private func setupAndStartCaptureSession() {
        DispatchQueue.global().async {
            self.captureSession = AVCaptureSession()
            
            self.captureSession.beginConfiguration()
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            
            self.setupInputs()
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            self.setupOutput()
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()

        }

    }
    
    private func setupInputs() {
        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            self.backCamera = backCamera
        } else {
            print("DEBUG: No back camera")
        }
        
        if let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            self.frontCamera = frontCamera
        } else {
            print("DEBUG: No font camera")
        }
        
        guard let bInput = try? AVCaptureDeviceInput(device: self.backCamera) else {
            print("DEBUG: No back camera available")
            return
        }
        
        self.backInputCamera = bInput
        
        if !self.captureSession.canAddInput(self.backInputCamera) {
            print("DEBUG: Can not add back Input")
        }
        
        guard let fInput = try? AVCaptureDeviceInput(device: self.frontCamera) else {
            print("DEBUG: No front camera available")
            return
        }
        self.frontInputCamera = fInput
        
        if !self.captureSession.canAddInput(self.frontInputCamera) {
            print("DEBUG: Can not add front Input")
        }
  
        self.captureSession.addInput(self.backInputCamera)
    }
    
    private func setupOutput() {
        self.videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue")
        self.videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if self.captureSession.canAddOutput(videoOutput) {
            self.captureSession.addOutput(self.videoOutput)
        } else {
            print("DEBUG: Cannot add video Output")
        }
        
        self.videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func setupPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.view.layer.insertSublayer(self.previewLayer, at: 0)
        
        self.previewLayer.frame = self.view.layer.frame
    }
    
    func switchCameraInputs() {

        self.captureSession.beginConfiguration()
        if isBackCameraOn {
            self.captureSession.removeInput(backInputCamera)
            self.captureSession.addInput(frontInputCamera)
        } else {
            self.captureSession.removeInput(frontInputCamera)
            self.captureSession.addInput(backInputCamera)
        }
        
        self.videoOutput.connections.first?.videoOrientation = .portrait
        self.videoOutput.connections.first?.isVideoMirrored = isBackCameraOn
        self.isBackCameraOn = !isBackCameraOn
        self.captureSession.commitConfiguration()
        
    }
    
    //MARK: - Selector
    @objc func handleCaptureButtonTapped() {
        self.isTakePicture = true
    }
    
    @objc func handleSwitchCameraButtonTapped() {
        self.switchCameraInputs()
    }
    
    @objc func handleToggleFlashModeButtonModeTapped() {
        self.isFlashModeOn = !self.isFlashModeOn
        if self.isFlashModeOn {
            try? self.backCamera.lockForConfiguration()
            try? self.frontCamera.lockForConfiguration()
            if self.backCamera.isTorchModeSupported(.on) {
                self.backCamera.torchMode = .on
            }
            
            if self.frontCamera.isTorchModeSupported(.on) {
                self.frontCamera.torchMode = .on
            }
    
            self.backCamera.unlockForConfiguration()
            self.frontCamera.unlockForConfiguration()
        } else {
            try? self.backCamera.lockForConfiguration()
            try? self.frontCamera.lockForConfiguration()
            if self.backCamera.isTorchModeSupported(.on) {
                self.backCamera.torchMode = .off
            }
            
            if self.frontCamera.isTorchModeSupported(.on) {
                self.frontCamera.torchMode = .off
            }
            self.backCamera.unlockForConfiguration()
            self.frontCamera.unlockForConfiguration()
        }
        
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !self.isTakePicture {
            return
        }
        
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return}
  
        let uiImage = UIImage(cgImage: cgImage)
        DispatchQueue.main.async {
            self.capturedImage.image = uiImage
            self.isTakePicture = false

            
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
            } completionHandler: { success, error in
                if let error = error {
                    print("DEBUG: cannot save photo \(error.localizedDescription)")
                } else {
                    print("DEBUG: save image success")
                }
            }

        }
    }
}

