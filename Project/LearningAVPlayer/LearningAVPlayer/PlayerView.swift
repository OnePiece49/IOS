//
//  PlayerView.swift
//  LearningAVPlayer
//
//  Created by Long Bảo on 21/06/2023.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    //MARK: - Properties
    
    private var playerItem: AVPlayerItem?
    private var playerLayer: AVPlayerLayer!
    
    var player: AVPlayer?
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        print("deinit of PlayerView")
        
    }
    
    //MARK: - Helpers

    func configureUI() {
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.frame = self.layer.bounds

        layer.addSublayer(playerLayer)
    }
    
    
    private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVAsset(url: url)
        
        print("DEBUG: duration \(asset.duration)")
        print("DEBUG: creationDate \(asset.creationDate)")
        print("DEBUG: \(asset.metadata.count)")
        asset.loadValuesAsynchronously(forKeys: ["playable", "creationDate", "isExportable"]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                print("DEBUG: duration \(asset.duration)")
                print("DEBUG: creationDate \(asset.metadata.count)")
                completion?(asset)
            case .failed:
                print("DEBUG: error")
            case .cancelled:
                print(".cancelled")
            default:
                print("default")
            }
        }
    }
    
    private var playerItemContext = 0
    private func setUpPlayerItem(with asset: AVAsset) {
        playerItem = AVPlayerItem(asset: asset)
        
        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(playerItem: self?.playerItem!)
            self?.configureUI()
            self?.player?.play()
            self?.player?.addObserver(self!, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &self!.playerItemContext)
        }
    }
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == &playerItemContext else {
            return
        }
            
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            switch status {
            case .readyToPlay:
                print(".readyToPlay")
                player?.play()
            case .failed:
                print(".failed")
            case .unknown:
                print(".unknown")
            @unknown default:
                print("@unknown default")
            }
        }
    }
    
    
    func play(with url: URL) {
        setUpAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.setUpPlayerItem(with: asset)
        }
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
