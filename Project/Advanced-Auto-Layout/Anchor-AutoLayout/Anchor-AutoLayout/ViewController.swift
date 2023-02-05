//
//  ViewController.swift
//  Anchor-AutoLayout
//
//  Created by Long Bảo on 11/01/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {

        
        /*Example 1 */ 
//        let topLabel = makeLabel(text: "Top Label")
//        let bottomLabel = makeLabel(text: "Bot Label")
//        let leftLabel = makeLabel(text: "Left Label")
//        let rightLabel = makeLabel(text: "Right Label")
//        view.addSubview(topLabel)
//        topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
//        topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        view.addSubview(bottomLabel)
//        bottomLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
//        bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        view.addSubview(leftLabel)
//        leftLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
//        leftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 13).isActive = true
//
//        view.addSubview(rightLabel)
//        rightLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
//        rightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -8).isActive = true

        /*Example 2*/
        let smallLabel = makeLabel(text: "Small Label")
        let bigLabel = makeBiglabel(text: "Big Label")
        
        view.addSubview(smallLabel)
        view.addSubview(bigLabel)
        
        smallLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        smallLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        bigLabel.leftAnchor.constraint(equalTo: smallLabel.rightAnchor, constant: 10).isActive = true
        bigLabel.firstBaselineAnchor.constraint(equalTo: smallLabel.firstBaselineAnchor).isActive = true            //Làm cho 2 label cùng hàng
        
        
        
    }
    
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        return label
    }
    
    func makeBiglabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 32)
        label.text = text
        return label
    }



}

