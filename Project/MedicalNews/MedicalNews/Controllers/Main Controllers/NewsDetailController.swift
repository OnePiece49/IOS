//
//  NewsDetailController.swift
//  MedicalNews
//
//  Created by Long Bảo on 08/03/2023.
//

import Foundation
import UIKit
import WebKit

class NewsDetailController: UIViewController {
    //MARK: - Properties
    let loadingIndicator = UIActivityIndicatorView()
    let header = NewsDetailHeaderView()
    var didLoading: Bool = false
    var newsURL: URL? {
        didSet {
            updateView()
        }
    }
    
    private var webView: WKWebView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        loadingIndicator.startAnimating()
        
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        configureHeaderView()
        
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
        
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIndicator.hidesWhenStopped = true
        
        guard let newsURL = newsURL else {
            return
        }
        webView.load(URLRequest(url: newsURL))
        let queue = DispatchQueue(label: "stopIndicator")
 
        queue.async {
            while self.webView.isLoading {}
            
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    func configureHeaderView() {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 44).isActive = true
        header.delegate = self
    }
    
    func updateView() {
        didLoading = true
    }
    
    //MARK: - Selectors
}

extension NewsDetailController: NewsHeaderControllerDelegate {
    func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}



