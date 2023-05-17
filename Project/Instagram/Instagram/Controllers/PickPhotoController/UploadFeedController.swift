//
//  UploadFeedController.swift
//  Instagram
//
//  Created by Long Bảo on 16/05/2023.
//

import UIKit


class UploadFeedController: UIViewController {
    //MARK: - Properties
    var imageUpload: UIImage? {
        didSet {
            self.headerView.imageUploadImageView.image = imageUpload
            self.headerView.scaleImageView.image = imageUpload
        }
    }
    
    let headerView: UploadFeedHeaderView
    
    //MARK: - View Lifecycle
    init(imageUpload: UIImage?) {
        headerView = UploadFeedHeaderView(image: imageUpload)
        self.imageUpload = imageUpload
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(handleDidTouchScreen)))
        view.isUserInteractionEnabled = true
        self.activeConstraint()
        headerView.delegate = self
    }
    
    func activeConstraint() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    //MARK: - Selectors
    @objc func handleDidTouchScreen() {
        self.headerView.statusTextView.endEditing(true)
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: []) {
            self.headerView.scaleImageView.transform = .identity
            self.headerView.shadowView.alpha = 0
            
        }
    }
    
}
//MARK: - delegate
extension UploadFeedController: UploadFeedHeaderDelegate {
    func didSelectNexButton() {
        self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?.first
        navigationController?.popViewController(animated: false)
    }
    
    func didSelectBackImage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didSelectUploadImageView() {
        view.layoutIfNeeded()
        let translateTransform = CGAffineTransform(translationX: view.frame.midX - headerView.scaleImageView.frame.midX, y: view.frame.midY - headerView.scaleImageView.frame.midY)
        let scaleX = view.frame.width / headerView.scaleImageView.frame.width
        let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        
        self.headerView.shadowView.frame = view.frame
        UIView.animate(withDuration: 0.65,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: []) {
            
            print("DEBUG: \(self.headerView.scaleImageView.bounds.size)")
            
            self.headerView.scaleImageView.transform = combineTransform
            self.headerView.shadowView.alpha = 0.9
        }

    }
}
