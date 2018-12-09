//
//  MockAuthService.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

/// На симуляторе не срабатывал canOpenUrl из VKsdk, на телефоне - ок. Харкод токена, чтобы работать на симуляторе.
class MockAuthService: AuthService {
    var accessToken: String?
    
    func signIn(_ completion: @escaping AuthServiceSignInCompletion) {
        accessToken = ""
        
        completion(true)
    }
}
