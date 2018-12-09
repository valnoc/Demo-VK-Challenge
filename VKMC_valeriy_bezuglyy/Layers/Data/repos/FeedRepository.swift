//
//  FeedRepository.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class FeedRepository: Repository {
    typealias Entity = FeedItem
    
    let networkSession: NetworkSession
    let authService: AuthService
    
    init(networkSession: NetworkSession,
         authService: AuthService) {
        self.networkSession = networkSession
        self.authService = authService
    }
    
    func load(offset: String, limit: Int, completion: @escaping PaginatedCompletion) {
        guard let accessToken = authService.accessToken else {
            completion(.failure(AppError.noAccessToken))
            return
        }
        
        let requestBuilder = URLRequestBuilder(path: "newsfeed.get",
                                               accessToken: accessToken)
        requestBuilder.params = ["filters": "post",
                                 "count": "\(limit)"]
        if !offset.isEmpty {
            requestBuilder.params["start_from"] = offset
        }
        
        networkSession.execute(request: requestBuilder.make(),
                               completion: makeNetworkCompletion(completion))
    }
    
    fileprivate func makeNetworkCompletion(_ completion: @escaping PaginatedCompletion) -> NetworkSessionCompletion {
        //TODO: вынести обработку в отдельную сущность
        return { (_ httpStatus: Int, _ data: Data?, _ networkError: Error?) -> Void in
            DispatchQueue.global(qos: .utility).async {
                if let networkError = networkError {
                    DispatchQueue.main.async {
                        completion(.failure(networkError))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(AppError.noData))
                    }
                    return
                }
                
                do {
                    let apiResponse = try JSONDecoder().decode(APIResponse<APIResponsePagination<FeedItem>>.self,
                                                               from: data).response
                    
                    //-- link author
                    for item in apiResponse.items {
                        guard let sourceId = item.sourceId else { continue }
                        if sourceId >= 0 {
                            if let user = apiResponse.profiles.first(where: { $0.id == sourceId }) {
                                item.author = user
                            }
                        
                        } else {
                            if let group = apiResponse.groups.first(where: { $0.id == -sourceId }) {
                                item.author = group
                            }
                        }
                    }
                    //--
                    
                    DispatchQueue.main.async {
                        completion(.success(apiResponse))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        print("\n===JSONDecoder ERROR\n\(error)")
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
