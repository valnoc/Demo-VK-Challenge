//
//  FeedItemCell.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 10/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

class FeedItemCell: UITableViewCell {
    
    fileprivate var viewModel: FeedItemCellVM?
    
//    var vCard: RoundedView
    var vCard: UIView
    
    var ivAvatar: UIImageView
    var lbAuthor: UILabel
    var lbDate: UILabel
    
    var lbText: UILabel
    var bnExpand: UIButton
    
    var ivPhoto: UIImageView
    var vGallery: GalleryView
    
    var bnLike: UIButton
    var bnComment: UIButton
    var bnRepost: UIButton
    var bnView: UIButton
    
    var imageLoader: ImageLoader! {
        didSet {
            vGallery.imageLoader = imageLoader
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        vCard = UIView(frame: .zero)
        vCard.backgroundColor = .white
        vCard.layer.cornerRadius = 10
        vCard.layer.shadowOpacity = 0.07
        vCard.layer.shadowColor = UIColor(red: 0.39, green: 0.4, blue: 0.44, alpha: 1).cgColor
        vCard.layer.shadowOffset = CGSize(width: 0, height: 24)
        vCard.layer.shadowRadius = 18
        
        ivAvatar = UIImageView(frame: .zero)
        ivAvatar.isOpaque = true
        
        ivAvatar.layer.borderWidth = 0.5
        ivAvatar.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        ivAvatar.layer.masksToBounds = true
        
        lbAuthor = UILabel(frame: .zero)
        lbAuthor.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbAuthor.textColor = UIColor(red: 0.17, green: 0.18, blue: 0.18, alpha: 1)
        lbAuthor.backgroundColor = .white
        
        lbDate = UILabel(frame: .zero)
        lbDate.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lbDate.textColor = UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1)
        lbDate.backgroundColor = .white
        
        lbText = UILabel(frame: .zero)
        lbText.numberOfLines = 0
        lbText.textColor = UIColor(red: 0.17, green: 0.18, blue: 0.19, alpha: 1)
        lbText.backgroundColor = .white
        
        ivPhoto = UIImageView(frame: .zero)
        vGallery = GalleryView(frame: .zero)
        
        bnExpand = UIButton(type: .custom)
        bnExpand.setTitleColor(UIColor(red: 0.3, green: 0.45, blue: 0.77, alpha: 1), for: .normal)
        bnExpand.setTitle("Показать полностью...", for: .normal)
        bnExpand.titleLabel?.font = FeedItemCellCalculator.textStyle[.font] as? UIFont
        bnExpand.contentHorizontalAlignment = .left
        bnExpand.backgroundColor = .white
        bnExpand.titleLabel?.backgroundColor = .white
        
        let actionBnsTitleColor = UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1)
        let actionBnsFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        let actionBnsTint = UIColor(red: 0.6, green: 0.64, blue: 0.68, alpha: 1)
        
        bnLike = UIButton(type: .custom)
        bnLike.setImage(UIImage(named: "Like_outline_24")!.withRenderingMode(.alwaysTemplate), for: .normal)
        bnLike.tintColor = actionBnsTint
        bnLike.setTitleColor(actionBnsTitleColor, for: .normal)
        bnLike.titleLabel?.font = actionBnsFont
        bnLike.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        bnLike.isUserInteractionEnabled = false
//        bnLike.backgroundColor = .white
        bnLike.imageView?.backgroundColor = .white
        bnLike.titleLabel?.backgroundColor = .white
        
        bnComment = UIButton(type: .custom)
        bnComment.setImage(UIImage(named: "Comment_outline_24")!.withRenderingMode(.alwaysTemplate), for: .normal)
        bnComment.tintColor = actionBnsTint
        bnComment.setTitleColor(actionBnsTitleColor, for: .normal)
        bnComment.titleLabel?.font = actionBnsFont
        bnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        bnComment.isUserInteractionEnabled = false
        bnComment.backgroundColor = .white
        bnComment.imageView?.backgroundColor = .white
        bnComment.titleLabel?.backgroundColor = .white
        
        bnRepost = UIButton(type: .custom)
        bnRepost.setImage(UIImage(named: "Share_outline_24")!.withRenderingMode(.alwaysTemplate), for: .normal)
        bnRepost.tintColor = actionBnsTint
        bnRepost.setTitleColor(actionBnsTitleColor, for: .normal)
        bnRepost.titleLabel?.font = actionBnsFont
        bnRepost.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        bnRepost.isUserInteractionEnabled = false
        bnRepost.backgroundColor = .white
        bnRepost.imageView?.backgroundColor = .white
        bnRepost.titleLabel?.backgroundColor = .white
        
        bnView = UIButton(type: .custom)
        bnView.setImage(UIImage(named: "View_20")!.withRenderingMode(.alwaysTemplate), for: .normal)
        bnView.tintColor = UIColor(red: 0.77, green: 0.78, blue: 0.8, alpha: 1)
        bnView.setTitleColor(UIColor(red: 0.66, green: 0.68, blue: 0.7, alpha: 1), for: .normal)
        bnView.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bnView.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        bnView.isUserInteractionEnabled = false
//        bnView.backgroundColor = .white
        bnView.imageView?.backgroundColor = .white
        bnView.titleLabel?.backgroundColor = .white
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(vCard)
        
        vCard.addSubview(ivAvatar)
        vCard.addSubview(lbAuthor)
        vCard.addSubview(lbDate)
        
        vCard.addSubview(lbText)
        vCard.addSubview(bnExpand)
        
        vCard.addSubview(ivPhoto)
        vCard.addSubview(vGallery)
        
        vCard.addSubview(bnLike)
        vCard.addSubview(bnComment)
        vCard.addSubview(bnRepost)
        vCard.addSubview(bnView)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        bnExpand.addTarget(self, action: #selector(bnExpandPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - content
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivAvatar.image = nil
        lbAuthor.text = nil
        lbDate.text = nil
        
        lbText.attributedText = nil
        
        ivPhoto.image = nil
        vGallery.photos = []
    }
    
    func update(_ viewModel: FeedItemCellVM) {
        self.viewModel = viewModel
        
        if let avatarPath = viewModel.avatarPath {
            imageLoader.loadImage(atPath: avatarPath) { [weak self] (path, image) in
                guard let __self = self else { return }
                guard path == __self.viewModel?.avatarPath else { return }
                __self.ivAvatar.image = image
            }
        }
        
        lbAuthor.text = viewModel.author
        lbDate.text = viewModel.dateString
        
        if let text = viewModel.text {
            lbText.attributedText = NSAttributedString(string: text,
                                                       attributes: FeedItemCellCalculator.textStyle)
        }
        
        if let photo = viewModel.photo {
            imageLoader.loadImage(atPath: photo.url) { [weak self] (path, image) in
                guard let __self = self else { return }
                guard let currentPhoto = __self.viewModel?.photo,
                    path == currentPhoto.url else { return }
                __self.ivPhoto.image = image
            }
        }
        
        if let galleryPhotos = viewModel.galleryPhotos {
            vGallery.photoSize = viewModel.layout.vGalleryPhotoSize
            vGallery.photos = galleryPhotos
        }
        
        bnLike.setTitle("\(viewModel.likesCount)", for: .normal)
        bnComment.setTitle("\(viewModel.commentsCount)", for: .normal)
        bnRepost.setTitle("\(viewModel.repostsCount)", for: .normal)
        bnView.setTitle("\(viewModel.viewsCount)", for: .normal)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc
    func bnExpandPressed() {
        if let viewModel = viewModel,
            let expandAction = viewModel.expandAction {
            expandAction(viewModel)
        }
    }
    
    // MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let viewModel = viewModel else { return }
        let layout = viewModel.layout
        
        vCard.frame = layout.vCardFrame
        
        ivAvatar.frame = layout.ivAvatarFrame
        ivAvatar.layer.cornerRadius = layout.ivAvatarFrame.width / 2
        
        lbAuthor.frame = layout.lbAuthorFrame
        lbDate.frame = layout.lbDateFrame
        
        lbText.frame = layout.lbTextFrame
        
        bnExpand.frame = layout.bnExpandFrame
        bnExpand.isHidden = !(layout.bnExpandFrame.height > 0)
        
        ivPhoto.frame = layout.ivPhotoFrame
        ivPhoto.isHidden = !(layout.ivPhotoFrame.height > 0)
        
        if layout.vGalleryFrame.height > 0 {
            vGallery.frame = layout.vGalleryFrame
        }
        vGallery.isHidden = !(layout.vGalleryFrame.height > 0)
        
        bnLike.frame = layout.bnLikeFrame
        bnComment.frame = layout.bnCommentFrame
        bnRepost.frame = layout.bnRepostFrame
        bnView.frame = layout.bnViewsFrame
    }
}
