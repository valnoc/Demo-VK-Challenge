//
//  RoundedView.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

// пытался уменьшить перекрывание в color blended layers, но нужен однотонный фон, чтобы корректно отрисовывать
// при roundedVuew становилось все зеленым, но появлялся временами артекфакт в виде тонкой полоски
// не успел разобраться
class RoundedView: UIView {
    var cornerRadius: CGFloat = 0
    var roundedBackgroundColor: UIColor = .white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let borderPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        roundedBackgroundColor.setFill()
        borderPath.fill()
    }
}
