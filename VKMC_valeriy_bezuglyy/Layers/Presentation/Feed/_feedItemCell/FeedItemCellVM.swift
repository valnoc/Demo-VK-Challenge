//
//  FeedItemCellVM.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 10/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class FeedItemCellVM {
    var avatarPath: String?
    var author: String?
    var dateString: String?
    
    var text: String?
    
    var photo: PhotoSize?
    var galleryPhotos: [PhotoSize]?
    
    var likesCount: Int = 0
    var commentsCount: Int = 0
    var repostsCount: Int = 0
    var viewsCount: Int = 0
    
    var isExpandable: Bool {
        return shortLayout != nil
    }
    var isExpanded: Bool = false
    
    var fullLayout: FeedItemCellLayout = FeedItemCellLayout()
    var shortLayout: FeedItemCellLayout?
    
    var layout: FeedItemCellLayout {
        return isExpanded ? fullLayout: shortLayout!
    }
    
    var expandAction: ((_ viewModel: FeedItemCellVM) -> Void)?
}
