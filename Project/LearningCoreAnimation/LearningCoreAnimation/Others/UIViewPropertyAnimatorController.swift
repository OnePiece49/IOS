//
//  UIViewPropertyAnimatorController.swift
//  LearningCoreAnimation
//
//  Created by Long Bảo on 26/04/2023.
//

import UIKit

class UIViewPropertyAnimatorController: UIViewController {
    //MARK: - Properties
    private let redView = UIView()
    private var witdhBoxAnchor: NSLayoutConstraint!
    let slider = UISlider()
    let animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: .none)
    private lazy var bellImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "bell.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBellImageViewTapped)))
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
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            slider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100)
        ])
        slider.addTarget(self, action: #selector(handleSliderMoved), for: .allEvents)
        self.configureRedView()
        configreuBell()
        self.configurePanGesture()
    }
    
    func configureRedView() {
        title = "HAHAH"
        
        view.addSubview(redView)
        redView.backgroundColor = .red
        redView.translatesAutoresizingMaskIntoConstraints = false
        self.witdhBoxAnchor =  redView.widthAnchor.constraint(equalToConstant: 140)
        redView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        redView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        redView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.witdhBoxAnchor.isActive = true
        view.layoutIfNeeded()
    }
    
    func configureGradientColor() {
        let  gradient = CAGradientLayer()
        gradient.locations = [0.1, 0.5, 0.6]
        gradient.colors = [UIColor.blue.cgColor, UIColor.green.cgColor, UIColor.red.cgColor]
        //view.layer.insertSublayer(gradient, below: self.slider.layer)
        view.layer.insertSublayer(gradient, at: 0)
        
        gradient.frame = view.frame
    }
    
    func configreuBell() {
        view.addSubview(bellImageView)
        NSLayoutConstraint.activate([
            bellImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            bellImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bellImageView.widthAnchor.constraint(equalToConstant: 60),
            bellImageView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func configurePanGesture() {
        let panGeture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGetureTapped))
        redView.addGestureRecognizer(panGeture)
    }
    
    //MARK: - Selectors
    @objc func handleSliderMoved(slide: UISlider) {
        print("DEBUG: \(slide.value)")
        self.witdhBoxAnchor.constant = 100 + CGFloat(slide.value) * 100
//        animator.fractionComplete = CGFloat(slide.value)
        let animator = UIViewPropertyAnimator(duration: 2, dampingRatio: 0.5) {
            self.redView.backgroundColor = .blue
            
        }
        animator.startAnimation()
  
    }
    
    @objc func handlePanGetureTapped(panGeture: UIPanGestureRecognizer) {
        print("DEBUG: \(panGeture.location(in: view))")
//        UIView.animate(withDuration: 0.1) {
//            self.view.center = panGeture.location(in: self.view)
//        }
    }
    
    
    
    @objc func handleBellImageViewTapped() {
        let dur: Double = 1 / 6
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: dur) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: -.pi / 8)
            }
            
            UIView.addKeyframe(withRelativeStartTime: dur, relativeDuration: dur) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: .pi / 8)
            }

            UIView.addKeyframe(withRelativeStartTime: dur * 2, relativeDuration: dur) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: -.pi / 8)
            }

            UIView.addKeyframe(withRelativeStartTime: dur  * 3, relativeDuration: dur) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: .pi / 8)
            }

            UIView.addKeyframe(withRelativeStartTime: dur  * 4, relativeDuration: dur) {
                self.bellImageView.transform = CGAffineTransform(rotationAngle: -.pi / 8)
            }

            UIView.addKeyframe(withRelativeStartTime: dur  * 5, relativeDuration: dur) {
                self.bellImageView.transform = CGAffineTransform.identity
            }
        }

    }
    
}
//MARK: - delegate
