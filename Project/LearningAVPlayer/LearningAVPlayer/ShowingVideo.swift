//
//  ShowingVideo.swift
//  LearningAVPlayer
//
//  Created by Long Bảo on 21/06/2023.
//

import UIKit
import Photos

class ShowingController: UIViewController {
    //MARK: - Properties
    let playerContainerView = UIView()
    var imagePick: UIImagePickerController! = UIImagePickerController()
    var playerItem: AVPlayerItem!
    var player: AVPlayer? = AVPlayer()
    var playerLayer: AVPlayerLayer!
    var slider: UISlider = UISlider()
    var durationTime: CMTime?
    var asset: PHAsset?
    
    private lazy var exportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Export", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleExportButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.font = .systemFont(ofSize: 15)
        label.text = "0.0"
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.font = .systemFont(ofSize: 15)
        label.text = "0.0"
        return label
    }()
    
    private lazy var pickButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Siuuuuuuuuu", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePickButtontapped), for: .touchUpInside)
        return button
    }()
    

    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestData()
    }
    
    func requestData() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                
                // Handle restricted or denied state
                if status == .restricted || status == .denied
                {
                    print("Status: Restricted or Denied")
                }
                
                // Handle limited state
                if status == .limited
                {
                    
                    print("Status: Limited")
                }
                
                // Handle authorized state
                if status == .authorized
                {
                    print("DEBUG: \(Thread.isMainThread)")
                    DispatchQueue.main.async {
                        self?.configureUI()
                        print("Status: Full access")
                    }
            
                }
            }
        }
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(playerContainerView)
        view.addSubview(pickButton)
        view.addSubview(durationLabel)
        view.addSubview(progressLabel)
        view.addSubview(slider)
        view.addSubview(exportButton)
   
        playerContainerView.backgroundColor = .black
        view.backgroundColor = .white
        slider.thumbTintColor = .red
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderMoved), for: .valueChanged)
        playerContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            playerContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            playerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            pickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            exportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exportButton.centerYAnchor.constraint(equalTo: pickButton.bottomAnchor, constant: 30),
            
            progressLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            progressLabel.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor, constant: 10),
            
            slider.leftAnchor.constraint(equalTo: progressLabel.rightAnchor, constant: 5),
            slider.rightAnchor.constraint(equalTo: durationLabel.leftAnchor, constant: -5),
            slider.centerYAnchor.constraint(equalTo: progressLabel.centerYAnchor),
            
            durationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            durationLabel.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor, constant: 10),
        ])
    }
    
    func playVideo(asset: PHAsset) {
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: .none) { asset, auio, dictionaries in
            guard let asset = asset else {
                return
            }
            

            DispatchQueue.main.async {
                self.playerItem = AVPlayerItem(asset: asset)
                self.player?.replaceCurrentItem(with: self.playerItem)
                self.playerLayer = AVPlayerLayer(player: self.player)
                self.playerContainerView.layer.addSublayer(self.playerLayer)
                self.view.layoutIfNeeded()
                let time = asset.duration
                self.playerLayer.frame = self.playerContainerView.bounds
                
                self.player?.play()
                self.durationTime = time
                self.updateDurationLabel(time: time)
                self.player?.addPeriodicTimeObserver(forInterval: CMTime(value: 5, timescale: 10), queue: .main, using: { time in
                    self.updateProgressLabel(time: time)
                })
            }
        }
    }
    
    func getTimeString(time: CMTime) -> String? {
        let totalSeconds = CMTimeGetSeconds(time)
        guard !(totalSeconds.isNaN || totalSeconds.isInfinite) else {
            return nil
        }
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i",arguments: [hours, minutes, seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes, seconds])
        }
    }
    
    func updateProgressLabel(time: CMTime) {
        let timeString = getTimeString(time: time)
        self.progressLabel.text = timeString
    }
    
    func updateDurationLabel(time: CMTime) {
        let timeString = getTimeString(time: time)
        self.durationLabel.text = timeString
    }
    
    func configureImagePicker() {
        imagePick = UIImagePickerController()
        imagePick.delegate = self
        imagePick.sourceType = .savedPhotosAlbum
        imagePick.mediaTypes = ["public.movie"]
        imagePick.allowsEditing = false
        present(imagePick, animated: true, completion: .none)
    }
    
    func updateVideo(time: CMTime) {
        player?.seek(to: time)
    }
    
    //MARK: - Selectors
    @objc func handlePickButtontapped() {
        configureImagePicker()
    }
    
    @objc func handleExportButtonTapped() {
        guard let asset = asset, let avasset = player?.currentItem?.asset else {
            return
        }
        guard let urlAsset = (avasset as? AVURLAsset)?.url else {return}
        print("DEBUG: \(urlAsset) siuuuu")
        
        let fileManage = FileManager.default
        let filename = asset.value(forKey: "filename") as! String
        guard let document = fileManage.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        print("DEBUG: \(document)")
        let pathFoloder = document.appendingPathComponent("Folder-Luffy")
        try? fileManage.createDirectory(at: pathFoloder, withIntermediateDirectories: true, attributes: .none)
        let outputURL = pathFoloder.appendingPathComponent("\(filename).mp4")
        
        guard let exportSession = AVAssetExportSession(asset: avasset, presetName: AVAssetExportPresetHighestQuality) else {return}
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4

        exportSession.timeRange = CMTimeRange(start: CMTime(value: 50, timescale: 10), end: CMTime(value: 10, timescale: 1))
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("DEBUG: complete")
            case .failed:
                print("DEBUG: failed")
            default:
                break
            }
        }
    }
    
    @objc func handleSliderMoved(slider: UISlider) {
        guard let durationTime = durationTime else {
            return
        }

        let time = CMTimeGetSeconds(durationTime)
        let current = Double(time) * Double(slider.value)
        let currentTime =  CMTimeMakeWithSeconds(current, preferredTimescale: 1000)
        updateProgressLabel(time: currentTime)
        updateVideo(time: currentTime)
    }
    
}
//MARK: - delegate
extension ShowingController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: .none)

        guard let asset = info[.phAsset] as? PHAsset else {
            print("DEBUG: failed and \(info[.phAsset])")
            return
        }
        self.asset = asset

        playVideo(asset: asset)

    }
    
}
