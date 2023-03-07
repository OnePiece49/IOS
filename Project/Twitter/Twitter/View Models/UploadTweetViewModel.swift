//
//  UploadTweetViewModel.swift
//  Twitter
//
//  Created by Long Bảo on 21/02/2023.
//

import Foundation

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening ?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your Reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.userName)"
        }
    }
}
