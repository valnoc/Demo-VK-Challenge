//
//  AuthService.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

typealias AuthServiceSignInCompletion = (_ success: Bool) -> Void

protocol AuthService {
    var accessToken: String? { get }
    func signIn(_ completion: @escaping AuthServiceSignInCompletion)
}
