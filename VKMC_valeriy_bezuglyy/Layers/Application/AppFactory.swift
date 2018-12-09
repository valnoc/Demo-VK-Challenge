//
//  AppFactory.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class AppFactory {
    
//    fileprivate lazy var __authService: AuthService = MockAuthService()
    fileprivate lazy var __authService: AuthService = VKAuthService()
    func makeAuthService() -> AuthService {
        return __authService
    }
    
    fileprivate lazy var __networkSession: NetworkSession = NetworkSession()
    func makeNetworkSession() -> NetworkSession {
        return __networkSession
    }
    
    fileprivate lazy var __imageLoader: ImageLoader = ImageLoader()
    func makeImageLoader() -> ImageLoader {
        return __imageLoader
    }
    
    func makeFeedRepository() -> FeedRepository {
        return FeedRepository(networkSession: makeNetworkSession(),
                              authService: makeAuthService())
    }
    
    func makeUserRepository() -> UserRepository {
        return UserRepository(networkSession: makeNetworkSession(),
                              authService: makeAuthService())
    }
    
    func makeVCFactory() -> VCFactory {
        return VCFactory(appFactory: self)
    }
    
}
