//
//  ViewController.swift
//  InstrictContentSize-AutoLayout
//
//  Created by Long Bảo on 11/01/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setupUI()
    }

    func setupUI() {
        let label = makeLabel(text: "Hello Label")
        let bottomLabel = makeLabel(text: "Hello Bottom Label")
        let textFIeld = makeTextField(withPlaceHolder: "Hello Text Field")
        let image = UIImageView(image: UIImage(named: "luffy"))
        
        view.addSubview(label)
        view.addSubview(textFIeld)
        view.addSubview(image)
        view.addSubview(bottomLabel)
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)   //Ôm khít Content
        //label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)   //Ôm khít Content
        
        textFIeld.firstBaselineAnchor.constraint(equalTo: label.firstBaselineAnchor).isActive = true
        textFIeld.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
        textFIeld.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: label.topAnchor, constant: 30).isActive = true
        image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        image.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        //image.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
        
        bottomLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 320).isActive = true
        bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        image.setContentHuggingPriority(UILayoutPriority(248), for: .vertical)
        
        
    }
    
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }
    
    func makeTextField(withPlaceHolder: String) -> UITextField {
        let textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.placeholder = withPlaceHolder
        textFiled.backgroundColor = .yellow
        textFiled.font = UIFont.systemFont(ofSize: 20)
        return textFiled
    }
}

