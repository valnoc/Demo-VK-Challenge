//
//  Photo.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

struct Photo: Codable {
    var sizes: [PhotoSize]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        sizes = (try? container.decode([PhotoSize].self, forKey: .sizes)) ?? []
        sizes = sizes.filter({ $0.isValid() })
    }
    
    func size(forWidth width: CGFloat) -> PhotoSize? {
        let sorted = sizes.sorted(by: { $0.width < $1.width })
        return sorted.first(where: { $0.width > width }) ?? sorted.last
    }
}

struct PhotoSize: Codable {
    var type: String
    var width: CGFloat
    var height: CGFloat
    var url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = (try? container.decode(String.self, forKey: .type)) ?? ""
        width = (try? container.decode(CGFloat.self, forKey: .width)) ?? -1
        height = (try? container.decode(CGFloat.self, forKey: .height)) ?? -1
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
        
        let scale = UIScreen.main.scale
        width = width / scale
        height = height / scale
    }
    
    func isValid() -> Bool {
        return type != "" && width > 0 && height > 0 && url != ""
    }
}
