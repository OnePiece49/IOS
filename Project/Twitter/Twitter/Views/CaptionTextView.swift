//
//  CaptionTextView.swift
//  Twitter
//
//  Created by Long Bảo on 09/01/2023.
//

import UIKit

class CaptionTextView: UITextView {

    //MARK: -- Properties
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "What's happening?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    //MARK: -- Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isScrollEnabled = true
        backgroundColor = .white
        addSubview(placeholderLabel)
        font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

}
