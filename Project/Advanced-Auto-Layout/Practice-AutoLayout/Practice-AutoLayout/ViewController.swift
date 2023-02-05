//
//  ViewController.swift
//  Practice-AutoLayout
//
//  Created by Long Bảo on 16/01/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        
    }

    func configureUI() {
        let mainStack = makeStackView()
        let topStack = makeStackView()
        let bottomStack = makeStackView()
        let mainTextView = makeTextView(withPlaceholder: "Your description...")
        
        let imageLuffy = makeImage(name: "luffy")
        let rightTopStack = makeStackView()
        let firstNameView = makeNameView(withPlaceholder: "First")
        let middleNameView = makeNameView(withPlaceholder: "Middle")
        let lastNameView = makeNameView(withPlaceholder: "Last")
        
        let cancelButton = makeButton(text: "Cancel")
        let saveButton = makeButton(text: "Save")
        let clearButton = makeButton(text: "Clear")
        
        view.addSubview(mainStack)
        mainTextView.backgroundColor = .systemCyan
        
        mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        mainStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        mainStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        mainStack.spacing = 8
        
        mainStack.addArrangedSubview(topStack)
        mainStack.addArrangedSubview(mainTextView)
        mainStack.addArrangedSubview(bottomStack)
        topStack.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bottomStack.heightAnchor.constraint(equalToConstant: 43).isActive = true
        
        rightTopStack.addArrangedSubview(firstNameView)
        rightTopStack.addArrangedSubview(middleNameView)
        rightTopStack.addArrangedSubview(lastNameView)
        rightTopStack.distribution = .fillEqually
        rightTopStack.spacing = 8
        
        topStack.addArrangedSubview(imageLuffy)
        topStack.addArrangedSubview(rightTopStack)
        topStack.axis = .horizontal
        imageLuffy.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        bottomStack.addArrangedSubview(cancelButton)
        bottomStack.addArrangedSubview(saveButton)
        bottomStack.addArrangedSubview(clearButton)
        bottomStack.axis = .horizontal
        bottomStack.spacing = 5
        bottomStack.distribution = .fillEqually
        
    }
    
    //MARK: - Helpers
    func makeTextView(withPlaceholder: String) -> UITextView {
        let text = UITextView()
        let label = makeLabel(text: withPlaceholder)
        text.addSubview(label)
        label.topAnchor.constraint(equalTo: text.topAnchor, constant: 5).isActive = true
        label.leftAnchor.constraint(equalTo: text.leftAnchor, constant: 8).isActive = true
        text.font = UIFont.systemFont(ofSize: 16)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }
    
    func makeImage(name: String) -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: name)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
    
    func makeStackView() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }
    
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
       // label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        
        return label
    }
    
    func makeNameView(withPlaceholder: String) -> UIView {
        let view = UIView()
        let textField = UITextField()
        let label = makeLabel(text: withPlaceholder)
        view.addSubview(label)
        view.addSubview(textField)
        
        textField.placeholder = withPlaceholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 2
        textField.layer.borderColor = .init(red: CGFloat(130/255), green: CGFloat(153/255), blue: CGFloat(255/255), alpha: 0.8)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layoutMargins.left = 8
        
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 66).isActive = true
        textField.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -8).isActive = true
        return view
    }
    
    func makeButton(text: String) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .brown
        button.tintColor = .white
        return button
    }
}

