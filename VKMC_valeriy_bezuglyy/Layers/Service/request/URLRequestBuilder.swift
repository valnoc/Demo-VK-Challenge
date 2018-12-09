//
//  URLRequestBuilder.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class URLRequestBuilder {
    
    let url: URL
    let accessToken: String
    
    var params: [String: String]
    
    init(path: String,
         accessToken: String) {
        self.url = URL(string: "https://api.vk.com/method/\(path)")!
        self.accessToken = accessToken
        
        params = [:]
    }
    
    func make() -> URLRequest {
        params["v"] = "5.87"
        params["access_token"] = accessToken
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = params.reduce([], { (result, entry) -> [URLQueryItem] in
            let (key, value) = entry
            return result + [URLQueryItem(name: key, value: value)]
        })
        
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func queryItems(dictionary: [AnyHashable: Any]) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        for (key, value) in dictionary {
            items.append(URLQueryItem(name: "\(key)", value: "\(value)"))
        }
        return items
    }
}
