//
//  Factory.swift
//  Apadptive-AutoLayout
//
//  Created by Long Bảo on 15/01/2023.
//

import Foundation
import UIKit

let widthAnchorProgress = CGFloat(320)
let heightAnchorSpotify = CGFloat(40)

func makeImageView() -> UIView {
    let view = UIView()
    let image = UIImageView(image: UIImage(named: "rush"))
    view.addSubview(image)
    image.translatesAutoresizingMaskIntoConstraints = false
    image.leftAnchor.constraint(equalTo: image.leftAnchor).isActive = true
    image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    image.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true

    image.contentMode = .scaleToFill

    return view
}

func makeLabel(text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textAlignment = .center
    return label
}

func makeProgressView(nameImage: String) -> UIView {
    let view = UIView()
    let button = UIButton()
    let labelLeft = UILabel()
    let labelRight = UILabel()
    let progressView = UIProgressView()
    
    view.addSubview(button)
    view.addSubview(labelLeft)
    view.addSubview(progressView)
    view.addSubview(labelRight)
    labelLeft.text = "0:00"
    labelRight.text = "0:30"
    button.setImage(UIImage(named: nameImage), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    labelLeft.translatesAutoresizingMaskIntoConstraints = false
    labelRight.translatesAutoresizingMaskIntoConstraints = false
    progressView.translatesAutoresizingMaskIntoConstraints = false
    
    button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    button.widthAnchor.constraint(equalToConstant:  40).isActive = true
    button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
    labelLeft.leftAnchor.constraint(equalTo: button.rightAnchor, constant: 8).isActive = true
    labelLeft.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    progressView.leftAnchor.constraint(equalTo: labelLeft.rightAnchor, constant: 8).isActive = true
    progressView.centerYAnchor.constraint(equalTo: labelLeft.centerYAnchor).isActive = true
    labelRight.leftAnchor.constraint(equalTo: progressView.rightAnchor, constant: 8).isActive = true
    labelRight.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
    labelRight.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
    
    return view
}

func makePlayButton(text: String) -> UIView {
    let view = UIView()
    let button = UIButton(type: .system)
    view.addSubview(button)
    
    button.backgroundColor = .spotifyGreen
    button.setTitle(text, for: .normal)
    button.titleLabel?.textColor = UIColor.white
    button.layer.cornerRadius = heightAnchorSpotify / 2
    button.translatesAutoresizingMaskIntoConstraints = false
    button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    let textAttribute = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSMutableAttributedString.Key.kern: 0.5])
    button.setAttributedTitle(textAttribute, for: .normal)
    return view
}

func makeStackView() -> UIStackView {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
}

extension UIColor {
    static let darkBlue = UIColor(red: 10/255, green: 132/255, blue: 255/255, alpha: 1)
    static let darkGreen = UIColor(red: 48/255, green: 209/255, blue: 88/255, alpha: 1)
    static let darkOrange = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
    static let darkRed = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
    static let darkTeal = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
    static let darkYellow = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
    static let offBlack = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    static let spotifyGreen = UIColor(red: 28/255, green: 184/255, blue: 89/255, alpha: 1)
}
