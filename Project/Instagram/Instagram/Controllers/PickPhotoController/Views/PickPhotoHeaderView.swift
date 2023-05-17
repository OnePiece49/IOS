//
//  UploadHeaderPhotoView.swift
//  Instagram
//
//  Created by Long Bảo on 15/05/2023.
//


import UIKit

protocol PickHeaderPhotoDelegate: AnyObject {
    func didSelectBackImage()
    func didSelectNexButton()
    func didSelectCamera()
}

class PickPhotoHeaderView: UIView {
    //MARK: - Properties
    weak var delegate: PickHeaderPhotoDelegate?
    let heightHeaderTitle: CGFloat = 35
    let heightBottomCamera: CGFloat = 42
    
    private lazy var backImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "xmark"))
        iv.setDimensions(width: 25, height: 25)
        iv.tintColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackImageTapped)))
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bài viết mới"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNextButtonTapped)))
        return button
    }()
    
    private lazy var headerTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backImage, titleLabel, nextButton])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var cameraImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "camera"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.tintColor = UIColor.white
        iv.layer.cornerRadius = 32 / 2
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.systemGray.cgColor
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCameraImageViewTapped)))
        return iv
    }()
    
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .black
        addSubview(photoImageView)
        addSubview(headerTitleStackView)
        addSubview(cameraImageView)
        
        NSLayoutConstraint.activate([
            headerTitleStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            headerTitleStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            headerTitleStackView.topAnchor.constraint(equalTo: topAnchor),
            headerTitleStackView.heightAnchor.constraint(equalToConstant: self.heightHeaderTitle),
        ])
        
        NSLayoutConstraint.activate([
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            photoImageView.topAnchor.constraint(equalTo: headerTitleStackView.bottomAnchor),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            cameraImageView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 5),
            cameraImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            cameraImageView.heightAnchor.constraint(equalToConstant: 32),
            cameraImageView.widthAnchor.constraint(equalTo: cameraImageView.heightAnchor),
            cameraImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -5)
        ])
    }
    
    //MARK: - Selectors
    @objc func handleNextButtonTapped() {
        delegate?.didSelectNexButton()
    }
    
    @objc func handleBackImageTapped() {
        delegate?.didSelectBackImage()
    }
    
    @objc func handleCameraImageViewTapped() {
        delegate?.didSelectCamera()
    }
    
}
//MARK: - delegate
