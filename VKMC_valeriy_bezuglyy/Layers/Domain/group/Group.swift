//
//  Group.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 10/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class Group: Codable {
    var id: Int?
    var name: String?
    var photo100: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo100 = "photo_100"
    }
}
