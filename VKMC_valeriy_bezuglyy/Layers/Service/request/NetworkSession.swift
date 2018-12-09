//
//  NetworkSession.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
import UIKit

typealias NetworkSessionCompletion = (_ httpStatus: Int, _ data: Data?, _ error: Error?) -> Void

class NetworkSession {
    
    var urlSession: URLSession
    var queue: DispatchQueue
    var isLogOn: Bool
    
    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.httpCookieStorage = nil
        configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json",
        ]
        
        urlSession = URLSession(configuration: configuration)
        queue = DispatchQueue(label: "NetworkSessionQueue")
        isLogOn = false
    }
    
    func execute(request: URLRequest, completion: @escaping NetworkSessionCompletion) {
        if isLogOn {
            print("\(Date()): \(request.url!.absoluteString)")
        }
        
        let task = urlSession.dataTask(with: request, completionHandler: { [weak self] (data, urlResponse, error) in
            self?.queue.async { [weak self]  in
                guard let __self = self else { return }
                
                var httpStatus = 500
                if let response = urlResponse as? HTTPURLResponse {
                    httpStatus = response.statusCode
                }
                
                __self.logJson(request: request, httpStatus: httpStatus, data: data, error: error)
                DispatchQueue.main.async {
                    completion(httpStatus, data, error)
                }
                
                __self.urlSession.getAllTasks(completionHandler: { (tasks) in
                    let isRunningTasks = tasks.first(where: { $0.state == URLSessionTask.State.running }) != nil
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = isRunningTasks
                    }
                })
            }
        })
        task.resume()
    }
    
    func logJson(request: URLRequest, httpStatus: Int, data: Data?, error: Error?) {
        if isLogOn {
            if error == nil, let data = data {
                let json = try? JSONSerialization.jsonObject(with: data,
                                                             options: [
                                                                JSONSerialization.ReadingOptions.allowFragments,
                                                                JSONSerialization.ReadingOptions.mutableContainers,
                                                                JSONSerialization.ReadingOptions.mutableLeaves,
                                                                ])
                print("""
                    \n<<<RESPONSE:
                    \(request.url!.absoluteString)
                    \(httpStatus)
                    \(String(describing: json))\n
                    """)
                
            } else {
                print("""
                    \n<<<RESPONSE:
                    \(request.url!.absoluteString)
                    \(httpStatus)
                    NO DATA\n
                    """)
            }
        }
    }
}
