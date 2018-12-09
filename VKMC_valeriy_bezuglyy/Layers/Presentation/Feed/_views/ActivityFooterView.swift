//
//  ActivityFooterView.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 10/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

class ActivityFooterView: UIView {

    var aiView: UIActivityIndicatorView
    
    override init(frame: CGRect) {
        aiView = UIActivityIndicatorView(style: .gray)
        super.init(frame: frame)
        
        aiView.backgroundColor = .clear
        aiView.hidesWhenStopped = true
        addSubview(aiView)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - content
    func update() {
        aiView.startAnimating()

        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        aiView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
