//
//  Repository.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype Entity where Entity: Codable
    
    typealias PaginatedCompletion = (_ response: RepositoryResponse<APIResponsePagination<Entity>>) -> Void
    typealias ArrayCompletion = (_ response: RepositoryResponse<APIResponse<[Entity]>>) -> Void
}

enum RepositoryResponse<T> where T: Codable {
    case success(_ response: T)
    case failure(_ error: Error)
}
