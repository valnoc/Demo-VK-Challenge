//
//  VCFactory.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class VCFactory {
    unowned var appFactory: AppFactory
    
    init(appFactory: AppFactory) {
        self.appFactory = appFactory
    }
    
    func makeFeedViewController() -> FeedViewController {
        let interactor = FeedInteractor(authService: appFactory.makeAuthService(),
                                        feedRepository: appFactory.makeFeedRepository(),
                                        userRepository: appFactory.makeUserRepository())
        let vc = FeedViewController(interactor: interactor,
                                    imageLoader: appFactory.makeImageLoader())
        interactor.output = vc
        return vc
    }
}
