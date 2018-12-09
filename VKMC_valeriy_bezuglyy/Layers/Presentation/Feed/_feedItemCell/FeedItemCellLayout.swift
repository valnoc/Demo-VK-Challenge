//
//  FeedItemCellLayout.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 10/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
import CoreGraphics

struct FeedItemCellLayout {
    var vCardFrame: CGRect = .zero
    
    var ivAvatarFrame: CGRect = .zero
    var lbAuthorFrame: CGRect = .zero
    var lbDateFrame: CGRect = .zero
    
    var lbTextFrame: CGRect = .zero
    var bnExpandFrame: CGRect = .zero
    
    var ivPhotoFrame: CGRect = .zero
    var vGalleryFrame: CGRect = .zero
    var vGalleryPhotoSize: CGSize = .zero
    
    var bnLikeFrame: CGRect = .zero
    var bnCommentFrame: CGRect = .zero
    var bnRepostFrame: CGRect = .zero
    var bnViewsFrame: CGRect = .zero
    
    var height: CGFloat = 0
}
