//
//  GalleryCell.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    var imageLoader: ImageLoader!
    
    var ivPhoto: UIImageView
    
    var photo: PhotoSize?
    
    override init(frame: CGRect) {
        ivPhoto = UIImageView(frame: .zero)
        
        super.init(frame: frame)
        
        contentView.addSubview(ivPhoto)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivPhoto.image = nil
    }
    
    func update(_ photo: PhotoSize) {
        self.photo = photo
        imageLoader.loadImage(atPath: photo.url) { [weak self] (path, image) in
            guard let __self = self else { return }
            guard let currentPhoto = __self.photo,
                path == currentPhoto.url else { return }
            __self.ivPhoto.image = image
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivPhoto.frame = bounds
    }
}
