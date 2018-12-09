//
//  GalleryCollectionFlowLayout.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

class GalleryCollectionFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                             withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                             withScrollingVelocity: velocity)
        }
        
        let pageWidth = itemSize.width + minimumLineSpacing
        let page = collectionView.contentOffset.x / pageWidth
        
        let nextPage = velocity.x > 0 ? page.rounded(.up): page.rounded(.down)
        let newXOffset: CGFloat = nextPage * pageWidth
        return CGPoint(x: newXOffset, y: proposedContentOffset.y)
    }
    
}
