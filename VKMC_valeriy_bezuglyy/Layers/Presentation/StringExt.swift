//
//  StringExt.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 10/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
import CoreGraphics

extension String {
    func height(width: CGFloat, style: [NSAttributedString.Key: Any]) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let result = self.boundingRect(with: size,
                                       options: .usesLineFragmentOrigin,
                                       attributes: style,
                                       context: nil)
        return ceil(result.height)
    }
}
