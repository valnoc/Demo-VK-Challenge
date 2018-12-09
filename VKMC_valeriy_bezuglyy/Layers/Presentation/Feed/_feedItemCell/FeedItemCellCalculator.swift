//
//  FeedItemCellCalculator.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 10/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit
import CoreGraphics

class FeedItemCellCalculator {
    static let textStyle:[NSAttributedString.Key: Any] = {
        let textParagraphStyle = NSMutableParagraphStyle()
        textParagraphStyle.minimumLineHeight = 22
        return [.paragraphStyle : textParagraphStyle,
                .font: UIFont.systemFont(ofSize: 15, weight: .regular)]
    }()
    
    let textLineHeight = (FeedItemCellCalculator.textStyle[.paragraphStyle] as! NSParagraphStyle).minimumLineHeight
    let vCardEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
    
    func makeLayout(_ viewModel: FeedItemCellVM, width: CGFloat) -> (full: FeedItemCellLayout, short: FeedItemCellLayout?) {
        let fullLayout = makeFullLayout(viewModel, width: width)
        
        var shortLayout: FeedItemCellLayout? = nil
        if fullLayout.lbTextFrame.height > textLineHeight * 8 {
            shortLayout = makeShortLayout(viewModel, width: width, fullLayout: fullLayout)
        }
        
        return (fullLayout, shortLayout)
    }
    
    fileprivate func makeFullLayout(_ viewModel: FeedItemCellVM,
                                    width: CGFloat) -> FeedItemCellLayout {
        var fullLayout = FeedItemCellLayout()
        
        let vCardWidth = width - vCardEdgeInsets.left - vCardEdgeInsets.right
        
        //--
        fullLayout.ivAvatarFrame = CGRect(x: 12, y: 12, width: 36, height: 36)
        
        //--
        let lbAuthorX = fullLayout.ivAvatarFrame.maxX + 10
        fullLayout.lbAuthorFrame = CGRect(x: lbAuthorX,
                                          y: 14,
                                          width: vCardWidth - lbAuthorX - 12,
                                          height: 17)
        
        //--
        fullLayout.lbDateFrame = CGRect(x: lbAuthorX,
                                        y: fullLayout.lbAuthorFrame.maxY + 1,
                                        width: fullLayout.lbAuthorFrame.width,
                                        height: 15)
        
        //--
        var lbTextFrame = CGRect(x: 12,
                                 y: fullLayout.ivAvatarFrame.maxY + 10,
                                 width: vCardWidth - 12 - 12,
                                 height: 0)
        if let text = viewModel.text, !text.isEmpty {
            let height = text.height(width: lbTextFrame.width,
                                     style: FeedItemCellCalculator.textStyle)
            lbTextFrame.size.height = height
        } else {
            lbTextFrame.origin.y -= 10
        }
        fullLayout.lbTextFrame = lbTextFrame
        
        //--
        fullLayout.bnExpandFrame = CGRect(x: lbTextFrame.minX,
                                          y: lbTextFrame.maxY,
                                          width: lbTextFrame.width,
                                          height: 0)
        
        //--
        var ivPhotoFrame = CGRect(x: 0,
                                  y: fullLayout.bnExpandFrame.maxY + 6,
                                  width: maxSinglePhotoWidth(cellWidth: width),
                                  height: 0)
        if let photo = viewModel.photo {
            ivPhotoFrame.size.height = ivPhotoFrame.width * photo.height / photo.width
        } else {
            ivPhotoFrame.origin.y -= 6
        }
        fullLayout.ivPhotoFrame = ivPhotoFrame
        
        //
        var vGalleryFrame = CGRect(x: 0,
                                  y: fullLayout.bnExpandFrame.maxY + 6,
                                  width: vCardWidth,
                                  height: 0)
        if let galleryPhotos = viewModel.galleryPhotos, !galleryPhotos.isEmpty {
            vGalleryFrame.size.height = maxGalleryPhotoSize(cellWidth: width).height + 40
        } else {
            vGalleryFrame.origin.y -= 6
        }
        fullLayout.vGalleryFrame = vGalleryFrame
        fullLayout.vGalleryPhotoSize = maxGalleryPhotoSize(cellWidth: width)
        
        //
        let imagesMaxY = max(ivPhotoFrame.maxY, vGalleryFrame.maxY)
        
        //--
        let actionsBarFrame = CGRect(x: 0,
                                     y: imagesMaxY + 4,
                                     width: vCardWidth,
                                     height: 44)
        let part = CGFloat(Int(vCardWidth / (359.0/84.0)))
        
        fullLayout.bnLikeFrame = CGRect(x: actionsBarFrame.minX,
                                        y: actionsBarFrame.minY,
                                        width: part,
                                        height: actionsBarFrame.height)
        fullLayout.bnCommentFrame = CGRect(x: fullLayout.bnLikeFrame.maxX,
                                           y: actionsBarFrame.minY,
                                           width: part,
                                           height: actionsBarFrame.height)
        fullLayout.bnRepostFrame = CGRect(x: fullLayout.bnCommentFrame.maxX,
                                          y: actionsBarFrame.minY,
                                          width: part,
                                          height: actionsBarFrame.height)
        fullLayout.bnViewsFrame = CGRect(x: actionsBarFrame.maxX - part,
                                         y: actionsBarFrame.minY,
                                         width: part,
                                         height: actionsBarFrame.height)
        
        //--
        fullLayout.vCardFrame = CGRect(x: vCardEdgeInsets.left,
                                       y: vCardEdgeInsets.top,
                                       width: vCardWidth,
                                       height:actionsBarFrame.maxY)
        
        //--
        fullLayout.height = fullLayout.vCardFrame.maxY + vCardEdgeInsets.bottom
        
        return fullLayout
    }
    
    fileprivate func makeShortLayout(_ viewModel: FeedItemCellVM,
                                     width: CGFloat,
                                     fullLayout: FeedItemCellLayout) -> FeedItemCellLayout {
        var shortLayout = FeedItemCellLayout()
        
        //--
        shortLayout.ivAvatarFrame = fullLayout.ivAvatarFrame
        shortLayout.lbAuthorFrame = fullLayout.lbAuthorFrame
        shortLayout.lbDateFrame = fullLayout.lbDateFrame
        
        //--
        var lbTextFrame = fullLayout.lbTextFrame
        lbTextFrame.size.height = textLineHeight * 6
        shortLayout.lbTextFrame = lbTextFrame

        var bnExpandFrame = fullLayout.bnExpandFrame
        bnExpandFrame.origin.y = lbTextFrame.maxY
        bnExpandFrame.size.height = textLineHeight
        shortLayout.bnExpandFrame = bnExpandFrame

        let textHeightDiff = fullLayout.lbTextFrame.height - shortLayout.lbTextFrame.height - bnExpandFrame.size.height
        
        //--
        var ivPhotoFrame = fullLayout.ivPhotoFrame
        ivPhotoFrame.origin.y -= textHeightDiff
        shortLayout.ivPhotoFrame = ivPhotoFrame
        
        var vGalleryFrame = fullLayout.vGalleryFrame
        vGalleryFrame.origin.y -= textHeightDiff
        shortLayout.vGalleryFrame = vGalleryFrame
        shortLayout.vGalleryPhotoSize = fullLayout.vGalleryPhotoSize
        
        //--
        var bnLikeFrame = fullLayout.bnLikeFrame
        bnLikeFrame.origin.y -= textHeightDiff
        shortLayout.bnLikeFrame = bnLikeFrame
        
        var bnCommentFrame = fullLayout.bnCommentFrame
        bnCommentFrame.origin.y -= textHeightDiff
        shortLayout.bnCommentFrame = bnCommentFrame
        
        var bnRepostFrame = fullLayout.bnRepostFrame
        bnRepostFrame.origin.y -= textHeightDiff
        shortLayout.bnRepostFrame = bnRepostFrame
        
        var bnViewsFrame = fullLayout.bnViewsFrame
        bnViewsFrame.origin.y -= textHeightDiff
        shortLayout.bnViewsFrame = bnViewsFrame
        
        var vCardFrame = fullLayout.vCardFrame
        vCardFrame.size.height -= textHeightDiff
        shortLayout.vCardFrame = vCardFrame
        
        shortLayout.height = fullLayout.height - textHeightDiff
        
        return shortLayout
    }
    
    func maxSinglePhotoWidth(cellWidth: CGFloat) -> CGFloat {
        return cellWidth - vCardEdgeInsets.left - vCardEdgeInsets.right
    }
    
    func maxGalleryPhotoSize(cellWidth: CGFloat) -> CGSize {
        let width = (cellWidth - vCardEdgeInsets.left - vCardEdgeInsets.right) * 335 / 359
        let height = width * 251.0 / 335.0
        return CGSize(width: width, height: floor(height))
    }
}

