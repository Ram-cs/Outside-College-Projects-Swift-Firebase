//
//  Extension.swift
//  ChatAppAgain
//
//  Created by Ram Yadav on 8/30/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
let cache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCacsheWithUrlString(url: String) {
        
        if let getCache = cache.object(forKey: url as AnyObject) as? UIImage {
            // DispatchQueue.main.async { //don't use it otherwise cache won't work, means, will download image each time

            self.image = getCache
            return //after cache, doesn't run below code
        }
        
        let downloadedImageURL = URL(string: url)
        URLSession.shared.dataTask(with: downloadedImageURL! , completionHandler: { (data, response, error) in
            if error != nil {
                fatalError("Can't download the image\(error!)")
            }
           
            if let downloadedImage = UIImage(data: data!) {
                cache.setObject(downloadedImage, forKey: url as AnyObject)
                DispatchQueue.main.async {
                    self.image = downloadedImage
                }
            }
            
        }).resume() //resume must put to run URLsession loop
    }
}
