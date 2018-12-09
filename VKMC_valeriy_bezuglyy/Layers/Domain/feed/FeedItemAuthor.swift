//
//  FeedItemAuthor.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

protocol FeedItemAuthor {
    func identifier() -> Int?
    func fullname() -> String?
    func avatarPath() -> String?
}

extension Group: FeedItemAuthor {
    func identifier() -> Int? {
        return id
    }
    
    func fullname() -> String? {
        return name
    }
    
    func avatarPath() -> String? {
        return photo100
    }
}

extension User: FeedItemAuthor {
    func identifier() -> Int? {
        return id
    }
    
    func fullname() -> String? {
        var result = ""
        if let firstName = firstName {
            result = firstName
        }
        if let lastName = lastName {
            result = [result, lastName].joined(separator: " ")
        }
        
        return result
    }
    
    func avatarPath() -> String? {
        return photo100
    }
}
