//
//  FeedItem.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class FeedItem: Codable {
    var postId: Int?
    var sourceId: Int?
    var author: FeedItemAuthor?
    var date: TimeInterval?
    
    var text: String?
    
    var attachments: [Attachment]?
   
    var likes: Likes?
    var comments: Comments?
    var reposts: Reposts?
    var views: Views?
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case sourceId = "source_id"
        case date
        
        case text
        
        case attachments
        
        case likes
        case comments
        case reposts
        case views
    }
    
    var photos: [Photo] {
        guard let attachments = attachments else { return [] }
        return attachments
            .filter({ $0.type == .photo })
            .compactMap({ $0.photo })
            .filter({ !$0.sizes.isEmpty })
    }
}
