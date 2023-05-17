//
//  CameraController.swift
//  Instagram
//
//  Created by Long Bảo on 15/05/2023.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    //MARK: - Properties
    var captureSession: AVCaptureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    var frontInput: AVCaptureInput!
    var videoOutput: AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var isCapurePhoto = false
    
    var onFlash: Bool = false

    private lazy var switchCamImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "arrow.triangle.2.circlepath.camera"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        return iv
    }()
        
    private lazy var flashImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "bolt.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFlashButtonTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private lazy var capturePhotoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "circle.circle.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCaptureButtonTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureCaptureSession()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(switchCamImageView)
        view.addSubview(flashImageView)
        view.addSubview(capturePhotoImageView)
        
        NSLayoutConstraint.activate([
            flashImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            flashImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
        ])
        flashImageView.setDimensions(width: 30, height: 25)

        NSLayoutConstraint.activate([
            capturePhotoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -13),
            capturePhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        capturePhotoImageView.setDimensions(width: 80, height: 80)
        
        NSLayoutConstraint.activate([
            switchCamImageView.centerYAnchor.constraint(equalTo: capturePhotoImageView.centerYAnchor),
            switchCamImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -13),
            
        ])
        switchCamImageView.setDimensions(width: 35, height: 40)

    }
    
    func configureCaptureSession() {
        DispatchQueue.global().async {
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.configureInputs()
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            
            self.setupOutput()
            
            self.captureSession.automaticallyConfiguresApplicationAudioSession = true
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    func configureInputs() {
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        self.backCamera = backCamera
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return
        }
        self.frontCamera = frontCamera
        
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            return
        }
        self.backInput = bInput
        
        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            return
        }
        self.frontInput = fInput
        
        if !captureSession.canAddInput(self.backInput) {
            return
        }
        
        captureSession.addInput(self.backInput)
    }
    
    func setupOutput() {
        self.videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue")
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if self.captureSession.canAddOutput(videoOutput) {
            self.captureSession.addOutput(videoOutput)
        }
    }
    
    func setupPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.view.layer.insertSublayer(self.previewLayer, at: 0)
        previewLayer.frame = self.view.layer.frame
        previewLayer.videoGravity = .resizeAspectFill
    }
    
    //MARK: - Selectors
    @objc func handleFlashButtonTapped() {
        if onFlash {
            flashImageView.image = UIImage(systemName: "bolt.slash.fill")
            onFlash = false
        } else {
            flashImageView.image = UIImage(systemName: "bolt.fill")
            onFlash = true
        }
    }
    
    @objc func handleCaptureButtonTapped() {
        self.isCapurePhoto = true
    }
    
}
//MARK: - delegate
extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !self.isCapurePhoto {
            return 
        }
        self.isCapurePhoto = false
        
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return}
        let uiImage = UIImage(cgImage: cgImage)
        
        let captureVC = CapturePhotoController(image: uiImage)
        navigationController?.pushViewController(captureVC, animated: true)
    }
}
