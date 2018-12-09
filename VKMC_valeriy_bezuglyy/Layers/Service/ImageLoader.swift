//
//  ImageLoader.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 10/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

class ImageLoader {
    
    var cache = NSCache<NSString, UIImage>()
    
    func loadImage(atPath path: String, completion: @escaping (_ path: String, _ image: UIImage) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let __self = self else { return }
            if let image = __self.cache.object(forKey: path as NSString) {
                DispatchQueue.main.async {
                    completion(path, image)
                }
                
            } else if let url = URL(string: path) {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        __self.cache.setObject(image, forKey: path as NSString)
                        DispatchQueue.main.async {
                            completion(path, image)
                        }
                    }
                } catch {
                    print("ImageLoader: FAILED to load \(path)")
                }
            }
        }
    }
}
