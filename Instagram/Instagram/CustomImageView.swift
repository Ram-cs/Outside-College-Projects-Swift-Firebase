//
//  customImageView.swift
//  Instagram
//
//  Created by Ram Yadav on 9/15/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase
var imageCached = [String: UIImage]()

class CustomeImageView: UIImageView {
    var lastImageUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastImageUrlUsedToLoadImage = urlString
        self.image = nil //no flickering the photo when uploaded
        guard let url = URL(string: urlString) else {return}
        
        if let imageCached = imageCached[urlString] {
            self.image = imageCached
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("Fail to fetch post Image", err)
                return
            }
            
            if url.absoluteString != self.lastImageUrlUsedToLoadImage { //bug fixed for repeating image
                return
            }
            
            guard let imageData = data else {return}
            let image = UIImage(data: imageData)
            
            imageCached[urlString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume() //must put resume to upload image
    }
}
