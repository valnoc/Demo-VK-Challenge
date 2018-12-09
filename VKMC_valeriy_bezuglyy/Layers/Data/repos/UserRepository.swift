//
//  UserRepositoryImpl.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class UserRepository: Repository {
    typealias Entity = User
    
    let networkSession: NetworkSession
    let authService: AuthService
    
    init(networkSession: NetworkSession,
         authService: AuthService) {
        self.networkSession = networkSession
        self.authService = authService
    }
    
    func loadMe(completion: @escaping ArrayCompletion) {
        guard let accessToken = authService.accessToken else {
            completion(.failure(AppError.noAccessToken))
            return
        }
        
        let requestBuilder = URLRequestBuilder(path: "users.get",
                                               accessToken: accessToken)
        requestBuilder.params = ["fields": "photo_100"]
        
        networkSession.execute(request: requestBuilder.make(),
                               completion: makeNetworkCompletion(completion))
    }
    
    fileprivate func makeNetworkCompletion(_ completion: @escaping ArrayCompletion) -> NetworkSessionCompletion {
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
                    let apiResponse = try JSONDecoder().decode(APIResponse<[User]>.self,
                                                               from: data)
                    
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
