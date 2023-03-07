//
//  ViewController.swift
//  MedicalNews
//
//  Created by Long Bảo on 06/03/2023.
//

import UIKit

class IntroViewController: UICollectionViewController {
    //MARK: - Properties
    private let imageInfor = ["Healthtracker-1", "Healthtracker-2", "Healthtracker-2"]
    private let pageControl = UIPageControl()
    private let backgroudImageview: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Rectangle 414")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 24)
        label.textColor = UIColor(red: 0.141, green: 0.165, blue: 0.38, alpha: 1)
        label.textAlignment = .center
        label.text = "Bác sĩ sẵn lòng chăm sóc khi bạn cần"
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Regular", size: 14)
        label.textColor = UIColor(rgb: 0x363D4E)
        label.textAlignment = .center
        label.text = "Chọn chuyên khoa, bác sĩ phù hợp và được thăm khám trong không gian thoải mái tại nhà"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 48)
        button.layer.cornerRadius = 48 / 2
        button.backgroundColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)
        let attributedButton = NSMutableAttributedString(string: "Đăng nhập", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15)])
        button.setAttributedTitle(attributedButton, for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 177, height: 48)
        button.layer.cornerRadius = 48 / 2
        button.backgroundColor = UIColor.white
        let attributedButton = NSMutableAttributedString(string: "Tạo tài khoản", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15)])
        button.setAttributedTitle(attributedButton, for: .normal)
        button.setTitleColor(UIColor(red: 0.141, green: 0.165, blue: 0.38, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.141, green: 0.165, blue: 0.38, alpha: 1).cgColor
        button.addTarget(self, action: #selector(handleRegisterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        registerButton.leftAnchor.constraint(equalTo: loginButton.rightAnchor, constant: 16).isActive = true
        registerButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        registerButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor, multiplier: 177 / 150).isActive = true
        registerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        registerButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor).isActive = true
        return view
    }()
    
    //MARK: - View LifeCycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor(red: 0.953, green: 0.961, blue: 0.984, alpha: 1)
        
        configureCollectionView()
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 22).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -37).isActive = true
        
        view.addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38).isActive = true
        subTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -37).isActive = true
        
        configurePageControll()
        
        view.addSubview(containerView)
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 114).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.backgroundView = backgroudImageview
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(IntroCollectionViewCell.self, forCellWithReuseIdentifier: IntroCollectionViewCell.identifier)
    }
    
    func configurePageControll() {
        view.addSubview(pageControl)
        pageControl.numberOfPages = imageInfor.count
        pageControl.currentPage = 0
        
        pageControl.tintColor = .blue
        pageControl.pageIndicatorTintColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 0.3)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 36).isActive = true
    }

    //MARK: - Selectors
    @objc func handleRegisterButtonTapped() {
        navigationController?.pushViewController(RegisterController(), animated: true)
    }
    
    @objc func handleLoginButtonTapped() {
        //navigationController?.pushViewController(RegisterController(), animated: true)
        navigationController?.pushViewController(HomeController(), animated: true)
    }
}

//MARK: - Delegate DataSourceCollectionView
extension IntroViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfor.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroCollectionViewCell.identifier, for: indexPath) as! IntroCollectionViewCell
        cell.infoImageView.image = UIImage(named: imageInfor[indexPath.row])?.withRenderingMode(.alwaysOriginal)
        return cell
    }


}

//MARK: - Delegate FlowlayoutCollectionView
extension IntroViewController: UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
}
