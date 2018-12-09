//
//  APIResponse.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

struct APIResponsePagination<T>: Codable where T: Codable {
    var nextOffset: String
    var items: [T]
    var profiles: [User]
    var groups: [Group]
    
    enum CodingKeys: String, CodingKey {
        case nextOffset = "next_from"
        case items
        case profiles
        case groups
    }
}

struct APIResponse<T>: Codable where T: Codable {
    var response: T
}
