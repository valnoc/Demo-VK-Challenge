//
//  HeaderView.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    var tfSearch: UITextField
    var ivAvatar: UIImageView
    
    var avatarPhoto: String?
    var imageLoader: ImageLoader!
    
    override init(frame: CGRect) {
        tfSearch = UITextField(frame: .zero)
        tfSearch.backgroundColor = UIColor(red: 0, green: 0.11, blue: 0.24, alpha: 0.06)
        tfSearch.layer.cornerRadius = 10.0
        
        tfSearch.placeholder = "Поиск"
        tfSearch.leftViewMode = .always
        
        let ivLeft = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        ivLeft.image = UIImage(named: "Search_16")!.withRenderingMode(.alwaysTemplate)
        ivLeft.contentMode = .center
        ivLeft.tintColor = UIColor(red: 0.67, green: 0.68, blue: 0.7, alpha: 1)
        tfSearch.leftView = ivLeft
        
        ivAvatar = UIImageView(frame: .zero)
        ivAvatar.backgroundColor = .white
        
        ivAvatar.layer.borderWidth = 0.5
        ivAvatar.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        ivAvatar.layer.masksToBounds = true
        
        super.init(frame: frame)
        
        addSubview(tfSearch)
        addSubview(ivAvatar)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - content
    func update(photo: String) {
        avatarPhoto = photo
        imageLoader.loadImage(atPath: photo) { [weak self] (path, image) in
            guard let __self = self else { return }
            guard path == __self.avatarPhoto else { return }
            __self.ivAvatar.image = image
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivAvatar.frame = CGRect(x: bounds.width - 36 - 12, y: 80, width: 36, height: 36)
        ivAvatar.layer.cornerRadius = ivAvatar.frame.width / 2
        
        tfSearch.frame = CGRect(x: 12, y: 80,
                                width: ivAvatar.frame.minX - 12 - 12,
                                height: 36)
    }
}
