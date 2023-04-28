//
//  ViewController.swift
//  LearningPhotoKit
//
//  Created by Long Bảo on 19/04/2023.
//

import UIKit
import Photos

enum sections: Int {
    case all
    case smartAlbums
    case userConllection
}

class ViewController: UIViewController {
    var allPhotos = PHFetchResult<PHAsset>()
    var smartAlbum = PHFetchResult<PHAssetCollection>()
    var userCollections = PHFetchResult<PHAssetCollection>()
    private lazy var fetchResult = PHAsset.fetchAssets(with: .image, options: self.fetchOptions())
    
    private lazy var imagePhotokit: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PHPhotoLibrary.shared().register(self)

        configureUI()
        requestAuthorization()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func configureUI() {
        view.backgroundColor = .systemCyan
        
        view.addSubview(imagePhotokit)
        NSLayoutConstraint.activate([
            imagePhotokit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            imagePhotokit.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            imagePhotokit.widthAnchor.constraint(equalToConstant: 100),
            imagePhotokit.heightAnchor.constraint(equalToConstant: 100),
        ])
        
    }
    
    private func requestAuthorization() {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            self.fetchAssests()
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized:
                self.fetchAssests()
            case .denied:
                print("DEBUG: denied")
            case .notDetermined:
                print("DEBUG: not Determine")
            case .limited:
                print("DEBUG: limited")
            default:
                print("DEBUG: default")
            }
        }
    }
    
    private func fetchAssests() {
        DispatchQueue.main.async {
            self.imagePhotokit.image = self.loadImage()
        }
    }
    
    
    private func loadImage() -> UIImage? {
        let manager = PHImageManager.default()
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        let queue1 = DispatchQueue(label: "abc")
        var image: UIImage? = nil {
            didSet {
                DispatchQueue.main.async {
                    self.imagePhotokit.image = image
                }
            }
        }
        
        print("DEBUG: Before change \(fetchResult.count)")
        
        let changeHandler: () -> Void = {
            let request = PHAssetChangeRequest(for: fetchResult.object(at: 0))
            request.isFavorite = false

        }
        
        //PHPhotoLibrary.shared().performChanges(changeHandler, completionHandler: .none)
        
        //queue1.async {
//            Thread.sleep(forTimeInterval: 2)
         let id = manager.requestImage(for: fetchResult.object(at: 0), targetSize: CGSize(width: 1000, height: 3000), contentMode: .aspectFill, options: self.requestOptions()) { img, err in
                guard let img = img else {
                    return
                }
                
                image = img
                print("DEBUG: \(image!.size)")
                print("DEBUG: \(Thread.isMainThread)")
            }
        
        print("DEBUG: \(id.byteSwapped)")
        //}

        return image
    }
    
    private func fetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = .max
        fetchOptions.predicate = NSPredicate(format: "isFavorite == %@", argumentArray: [true])
        
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "favorite",
                             ascending: false)
        ]
        return fetchOptions
    }
    
    private func requestOptions() -> PHImageRequestOptions {
        let requestOptions = PHImageRequestOptions()
        
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .fastFormat
//        requestOptions.progressHandler 4
//        requestOptions.resizeMode = .exact
        return requestOptions
    }
}

extension ViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            print("DEBUG: 123 \(self.fetchResult.count)")
            if let fetchResultChange = changeInstance.changeDetails(for: fetchResult) {
                let newResult = fetchResultChange.fetchResultAfterChanges
                print("DEBUG: afterChanged \(newResult.count)")
            }
        }

        
    }
}


