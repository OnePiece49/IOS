//
//  HeaderUploadFeedController.swift
//  Instagram
//
//  Created by Long Bảo on 16/05/2023.
//

import UIKit

protocol UploadFeedHeaderDelegate: AnyObject {
    func didSelectBackImage()
    func didSelectNexButton()
    func didSelectUploadImageView()
}

class UploadFeedHeaderView: UIView {
    //MARK: - Properties
    weak var delegate: UploadFeedHeaderDelegate?
    var ratio: CGFloat = 0.75
    
    private lazy var backImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.backward"))
        iv.setDimensions(width: 28, height: 28)
        iv.tintColor = .black
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleBackImageTapped)))
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Post"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                           action: #selector(handleNextButtonTapped)))
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
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    lazy var imageUploadImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handelImageUploadTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Viết chú thích..."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.layer.zPosition = .greatestFiniteMagnitude
        return label
    }()
    
    lazy var statusTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.textColor = .black
        tv.isEditable = true
        tv.isSelectable = true
        return tv
    }()
    
     let shadowView: UIView = {
        let view = UIView(frame: .zero)
        view.alpha = 0.0
        view.layer.backgroundColor = UIColor.white.cgColor
        return view
    }()
    
    //MARK: - View Lifecycle
    init(image: UIImage?) {
        super.init(frame: .zero)
        self.imageUploadImageView.image = image
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Helpers
    func configureUI() {
        self.activeConstraint()
        statusTextView.delegate = self

    }
    
    func activeConstraint() {
        backgroundColor = .white
        addSubview(headerTitleStackView)
        addSubview(divider)
        addSubview(placeHolderLabel)
        addSubview(statusTextView)
        addSubview(shadowView)
        addSubview(imageUploadImageView)
        
        NSLayoutConstraint.activate([
            headerTitleStackView.topAnchor.constraint(equalTo: topAnchor),
            headerTitleStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 9),
            headerTitleStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -9),
            headerTitleStackView.heightAnchor.constraint(equalToConstant: 42),
            
            divider.topAnchor.constraint(equalTo: headerTitleStackView.bottomAnchor, constant: 2),
            divider.leftAnchor.constraint(equalTo: leftAnchor),
            divider.rightAnchor.constraint(equalTo: rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            
            imageUploadImageView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 11),
            imageUploadImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            statusTextView.leftAnchor.constraint(equalTo: imageUploadImageView.rightAnchor, constant: 8),
            statusTextView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 1),
            statusTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            statusTextView.heightAnchor.constraint(equalToConstant: 87),
            
            placeHolderLabel.leftAnchor.constraint(equalTo: statusTextView.leftAnchor, constant: 3),
            placeHolderLabel.topAnchor.constraint(equalTo: statusTextView.topAnchor, constant: 30)
        ])

        imageUploadImageView.setDimensions(width: 70, height: 70 / ratio)
        shadowView.layer.zPosition = .greatestFiniteMagnitude
        imageUploadImageView.layer.zPosition = .infinity
    }
    
    //MARK: - Selectors
    @objc func handleNextButtonTapped() {
        delegate?.didSelectNexButton()
    }
    
    @objc func handleBackImageTapped() {
        delegate?.didSelectBackImage()
    }
    
    @objc func handelImageUploadTapped() {
        delegate?.didSelectUploadImageView()
    }
    
}
//MARK: - delegate
extension UploadFeedHeaderView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if statusTextView.text?.count == 0 {
            placeHolderLabel.isHidden = false
        }
    }
}
