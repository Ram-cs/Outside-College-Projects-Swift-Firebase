//
//  Extension.swift
//  Chat App
//
//  Created by Ram Yadav on 8/12/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

let imageCashed = NSCache<AnyObject, AnyObject>() //delcaring the caching

extension UIImageView {
    func loadImageWithCachUrlString(urlString: String) {
        self.image = nil //not to flash the images
        //first check the image is cached
        if let downloadImage = imageCashed.object(forKey: (urlString as AnyObject)) {
            self.image = downloadImage as? UIImage
            return
        }
        
        //otherwise download first and cached the image
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in //fetch the photo from
            if error != nil {
                fatalError("Image can't download: \(error!)")
            }
            DispatchQueue.main.async { //upload images faster
                if let downloadedImage = UIImage(data: data!) {
                    imageCashed.setObject(downloadedImage, forKey: urlString as AnyObject) //caching the image
                    self.image = downloadedImage
                }
                
            }
            
        }) .resume()
    }
}
