//
//  TotalFooterView.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 10/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

class TotalFooterView: UIView {

    var lbTotal: UILabel
    
    override init(frame: CGRect) {
        lbTotal = UILabel()
        lbTotal.textColor = UIColor(red: 0.56, green: 0.58, blue: 0.6, alpha: 1)
        lbTotal.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        lbTotal.textAlignment = .center
        
        super.init(frame: frame)
        
        addSubview(lbTotal)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - content
    func update(total: Int) {
        lbTotal.text = makePluralRuString(total)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func makePluralRuString(_ total: Int) -> String {
        let mod10 = total % 10
        let mod100 = total % 100
        
        switch (mod100) {
        case 11...14:
            break
            
        default:
            switch (mod10) {
            case 1:
                return "\(total) запись"
            case 2...4:
                return "\(total) записи"
            default:
                break;
            }
        }
        
        return "\(total) записей"
    }
    
    // MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lbTotal.frame = CGRect(x: 12,
                               y: bounds.midY - 16/2,
                               width: bounds.width - 12 - 12,
                               height: 16)
    }
}
