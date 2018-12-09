//
//  VKAuthService.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
import VKSdkFramework

class VKAuthService: NSObject, AuthService {

    let sdk: VKSdk
    var accessToken: String?
    
    var authCompletion: AuthServiceSignInCompletion?
    
    override init() {
        sdk = VKSdk.initialize(withAppId: "6746458")
        super.init()
        sdk.register(self)
    }
    
    func signIn(_ completion: @escaping AuthServiceSignInCompletion) {
//        VKSdk.forceLogout()
//        return
        
        let scope = ["friends", "wall"]
        VKSdk.wakeUpSession(scope) { [weak self] (state, error) in
            guard let __self = self else { return }
            if state == .authorized {
                print("authorized")
                __self.accessToken = VKSdk.accessToken()?.accessToken
                DispatchQueue.main.async {
                    completion(true)
                }
            
            } else if (error == nil){
                print("not authorized: \(state.rawValue)")
                __self.authCompletion = completion
                VKSdk.authorize(scope)
                
            } else {
                print("vk wake up error \(String(describing: error))")
            }
        }
    }
    
    func processOpenUrl(_ url: URL, by app: String) -> Bool {
        return VKSdk.processOpen(url, fromApplication: app)
    }
}

extension VKAuthService: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("vkSdkAccessAuthorizationFinished")
        accessToken = VKSdk.accessToken()?.accessToken
        
        authCompletion?(true)
        authCompletion = nil
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed")
        accessToken = nil
        
        authCompletion?(false)
        authCompletion = nil
    }
}
