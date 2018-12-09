//
//  FeedInteractor.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

protocol FeedInteractorInput {
    func loadInitialData()
    
    func refresh()
    func loadNextPage()
}

protocol FeedInteractorOutput: class {
    func didUpdate(feedItems: [FeedItem])
    func didLoadAllItems(_ count: Int)
    
    func didLoad(user: User)
}

class FeedInteractor {
    
    weak var output: FeedInteractorOutput?
    
    let authService: AuthService
    let feedRepository: FeedRepository
    let userRepository: UserRepository
    
    var feedItemsCache: [FeedItem]
    let feedPaginator: Paginator<FeedItem>
    
    init(authService: AuthService,
         feedRepository: FeedRepository,
         userRepository: UserRepository) {
        self.feedRepository = feedRepository
        self.authService = authService
        self.userRepository = userRepository
        
        self.feedItemsCache = []
        feedPaginator = Paginator<FeedItem>()
    }
}

extension FeedInteractor: FeedInteractorInput {
    func loadInitialData() {
        feedPaginator.onAllLoaded = { [weak self] in
            guard let __self = self else { return }
            __self.output?.didLoadAllItems(__self.feedItemsCache.count)
        }
        
        authService.signIn { [weak self] (success) in
            guard let __self = self else { return }
            guard success else { return }
            
            __self.refresh()
            
            __self.userRepository.loadMe(completion: { [weak self] (response) in
                guard let __self = self else { return }
                
                switch response {
                case .success(let apiResponse):
                    if let user = apiResponse.response.first {
                        __self.output?.didLoad(user: user)
                    }
                    
                case .failure(_):
                    break
                }
            })
        }
    }
    
    func refresh() {
        feedPaginator.refresh(loader: { [weak self] (offset, limit, completion) in
            guard let __self = self else { return }
            __self.feedRepository.load(offset: offset, limit: limit, completion: completion)
            
        }) { [weak self] (response) in
            guard let __self = self else { return }
            __self.feedItemsCache = []
            __self.handleResponse(response)
        }
    }
    
    func loadNextPage() {
        feedPaginator.loadNextPage() { [weak self] (response) in
            guard let __self = self else { return }
            __self.handleResponse(response)
        }
    }
    
    func handleResponse(_ response: RepositoryResponse<APIResponsePagination<FeedItem>>) {
        switch response {
        case .success(let apiResponse):
            feedItemsCache.append(contentsOf: apiResponse.items)
            
        case .failure(_):
            break
        }
        
        output?.didUpdate(feedItems: feedItemsCache)
    }
}
