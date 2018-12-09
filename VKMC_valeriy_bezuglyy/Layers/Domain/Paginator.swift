//
//  Paginator.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class Paginator<T> where T: Codable {
    
    var offset: String
    var limit: Int

    typealias PaginatorCompletion = (_ response: RepositoryResponse<APIResponsePagination<T>>) -> Void
    typealias PaginatorLoader = (_ offset: String, _ limit: Int, _ completion: @escaping PaginatorCompletion) -> Void
    var loader: PaginatorLoader?
    
    var isLoading: Bool
    
    var onAllLoaded: (() -> Void)?
    
    init() {
        offset = ""
        limit = 10
        isLoading = false
    }
    
    func refresh(loader: @escaping PaginatorLoader,
                 _ completion: @escaping PaginatorCompletion) {
        self.loader = loader
        
        offset = ""
        isLoading = false
        
        loadNextPage(completion)
    }
    
    func loadNextPage(_ completion: @escaping PaginatorCompletion) {
        guard !isLoading else { return }
        isLoading = true
        
        if let loader = loader {
            let offset = self.offset
            loader(offset, limit, { [weak self] (response) in
                guard let __self = self else { return }
                guard offset == __self.offset else { return }
                
                switch response {
                case .success(let apiResponse):
                    __self.offset = apiResponse.nextOffset
                    if apiResponse.items.count < __self.limit,
                        let onAllLoaded = __self.onAllLoaded {
                        onAllLoaded()
                    }
                case .failure(_):
                    break;
                }
                
                completion(response)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let __self = self else { return }
                    __self.isLoading = false
                }
            })
        }
    }
}
