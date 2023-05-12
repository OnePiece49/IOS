//
//  ViewController.swift
//  LoadImageFromLibraryPhoto
//
//  Created by Long Bảo on 02/05/2023.
//

import UIKit
import Photos

class ViewController: UIViewController {
    //MARK: - Properties
    var fetchResult = PHFetchResult<PHAsset>()
    var photoImages: [UIImage?] = [UIImage(systemName: "camera")]
    var collectionView: UICollectionView!
    var headerPhotoView = HeaderPhotoView(frame: .zero)
    var numberItem = 1
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        requestAuthorization()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(headerPhotoView)
        headerPhotoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerPhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            headerPhotoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            headerPhotoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            headerPhotoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2 / 5),
        ])
        headerPhotoView.backgroundColor = .white
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutCollectionView())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerPhotoView.bottomAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.collectionViewLayout = createLayoutCollectionView()
        
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let item = ComposionalLayout.createItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
    
        let group = ComposionalLayout.createGroup(axis: .horizontal, layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2)), item: item, count: 5)
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(2)
        
        let section = ComposionalLayout.createSection(group: group)
        section.interGroupSpacing = 2
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func requestAuthorization() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            self.loadImage()
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized:
                self.loadImage()
            case .denied:
                return
            case .restricted:
                return
            case .limited:
                return
            default:
                return
            }
        }
        
    }
    
    func loadImage() {
        let manager = PHImageManager.default()
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOption())
        
        DispatchQueue.global().async {
            for i in 0..<self.fetchResult.count {
                let asset = self.fetchResult.object(at: i)
                let ratio: Float = Float(asset.pixelWidth) / Float(asset.pixelHeight)
                
                    manager.requestImage(for: asset, targetSize: CGSize(width: Int(200 * ratio), height: 200), contentMode: .aspectFill, options: self.requestOption()) { imagePhoto, error in
                        self.photoImages.append(imagePhoto)
                        DispatchQueue.main.async {
                            self.insertCell()
                        }
                    }
                
            }
        }
    }
    
    func fetchOption() -> PHFetchOptions {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return option
    }
    
    func requestOption() -> PHImageRequestOptions {
        let request = PHImageRequestOptions()
        request.isSynchronous = true
        request.deliveryMode = .highQualityFormat
        return request
    }
    
    func insertCell() {
        self.numberItem = collectionView.numberOfItems(inSection: 0)
        let indexPath = IndexPath(item: self.numberItem, section: 0)
        numberItem += 1
        collectionView.insertItems(at: [indexPath])
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.image = self.photoImages[indexPath.row]
        if indexPath.row == 0 {
            cell.photoImageView.contentMode = .scaleAspectFit
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let camVC = CameraController()
            camVC.modalPresentationStyle = .fullScreen
            present(camVC, animated: true, completion: .none)
            return
        }
        
        let manager = PHImageManager.default()
        
        let asset = self.fetchResult.object(at: indexPath.row - 1)
        let ratio: Float = Float(asset.pixelWidth) / Float(asset.pixelHeight)

        manager.requestImage(for: asset, targetSize: CGSize(width: Int(1000 * ratio), height: 1000), contentMode: .aspectFit, options: requestOption()) { image, _ in
            self.headerPhotoView.photoImageView.image = image

        }
    }
}
