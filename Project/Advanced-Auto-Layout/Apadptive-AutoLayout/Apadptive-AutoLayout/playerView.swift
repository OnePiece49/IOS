//
//  playerView.swift
//  Apadptive-AutoLayout
//
//  Created by Long Bảo on 16/01/2023.
//

import Foundation
import UIKit

class PlayerView {
    var topAnchorConstant = NSLayoutConstraint()
    var centerAnchor = NSLayoutConstraint()
    
    
    func makePlayerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .red
        let stack = makeStackView()
        view.addSubview(stack)
        let labelSong = makeLabel(text: "Tom Sawyer")
        let labelAlbum = makeLabel(text: "Rush • Moving Pictures (2011 Remaster)")
        let progressView = makeProgressView(nameImage: "play")
        let spotifyButton = makePlayButton(text: "PLAY ON SPYOIFY")
        stack.spacing = 5
        stack.addArrangedSubview(labelSong)
        stack.addArrangedSubview(labelAlbum)
        stack.addArrangedSubview(progressView)
        stack.addArrangedSubview(spotifyButton)
        topAnchorConstant = stack.topAnchor.constraint(equalTo: view.topAnchor)
        centerAnchor = stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        topAnchorConstant.isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}
