//
//  InstagramImageView.swift
//  LearningCoreAnimation
//
//  Created by Long Bảo on 26/04/2023.
//

import UIKit

class InstagramImageViewController: UIViewController {
    //MARK: - Properties
    private var xAnchor: NSLayoutConstraint!
    private var yAnchor: NSLayoutConstraint!
    private var wAnchor: NSLayoutConstraint!
    private var hAnchor: NSLayoutConstraint!
    
    private lazy var pushAnimatorControllerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next Controller", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextController), for: .touchUpInside)
        return button
    }()
    
    private lazy var hahaLabel: UILabel = {
        let label = UILabel()
        label.text = "HAHAHAHA"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private var isZoom = false
    private lazy var instagramImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "insta"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleInstagramImageTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(pushAnimatorControllerButton)
        NSLayoutConstraint.activate([
            pushAnimatorControllerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pushAnimatorControllerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        
        view.addSubview(hahaLabel)
        NSLayoutConstraint.activate([
            hahaLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            hahaLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        view.addSubview(instagramImageView)
        self.xAnchor =  instagramImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15)
        self.yAnchor = instagramImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        self.wAnchor = instagramImageView.widthAnchor.constraint(equalToConstant: 50)
        self.hAnchor = instagramImageView.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([
            xAnchor,
            yAnchor,
            wAnchor,
            hAnchor
        ])
        view.layoutIfNeeded()
    }
    
    //MARK: - Selectors
    
    @objc func nextController() {
        //navigationController?.pushViewController(UIViewPropertyAnimatorController(), animated: true)
        let cv = UIViewPropertyAnimatorController()
        cv.modalPresentationStyle = .overFullScreen
        present(cv, animated: true, completion: .none)
    }
    
    @objc func handleInstagramImageTapped() {
        if !isZoom {
            NSLayoutConstraint.deactivate([
                xAnchor,
                yAnchor,
                wAnchor,
                hAnchor,
            ])
            self.xAnchor = instagramImageView.leftAnchor.constraint(equalTo: view.leftAnchor)
            self.yAnchor = instagramImageView.topAnchor.constraint(equalTo: view.topAnchor)
            self.wAnchor = instagramImageView.widthAnchor.constraint(equalTo: view.widthAnchor)
            self.hAnchor = instagramImageView.heightAnchor.constraint(equalTo: view.heightAnchor)
            
            NSLayoutConstraint.activate([
                xAnchor,
                yAnchor,
                wAnchor,
                hAnchor,
            ])
            self.isZoom = true
            UIView.animate(withDuration: 0.35) {
                self.view.layoutIfNeeded()
                self.instagramImageView.backgroundColor?.withAlphaComponent(0.2)
                self.instagramImageView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
            } completion: { _ in
                UIView.animate(withDuration: 0.05) {
                    
                }
            }
            
        } else {
            NSLayoutConstraint.deactivate([
                xAnchor,
                yAnchor,
                wAnchor,
                hAnchor,
            ])
            self.xAnchor =  instagramImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15)
            self.yAnchor = instagramImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
            self.wAnchor = instagramImageView.widthAnchor.constraint(equalToConstant: 50)
            self.hAnchor = instagramImageView.heightAnchor.constraint(equalToConstant: 40)
            
            NSLayoutConstraint.activate([
                xAnchor,
                yAnchor,
                wAnchor,
                hAnchor,
            ])
            self.isZoom = false

            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
//                self.instagramImageView.backgroundColor?.withAlphaComponent(0.2)
            }
            self.instagramImageView.backgroundColor = .clear
        }
    }
}
//MARK: - delegate


