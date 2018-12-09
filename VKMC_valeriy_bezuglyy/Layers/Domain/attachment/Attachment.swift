//
//  Attachment.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

enum AttachmentType {
    case unknown, photo
}

struct Attachment: Codable {
    var typeSTRING: String?
    var photo: Photo?
    
    enum CodingKeys: String, CodingKey {
        case typeSTRING = "type"
        case photo
    }
    
    var type: AttachmentType {
        switch typeSTRING {
        case "photo":
            return .photo
            
        default:
            return .unknown
        }
    }
 }
