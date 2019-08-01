//
//  UIImageView+Extensions.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func sfSetImage(with url: URL?, placeholder: UIImage?, completed: SDExternalCompletionBlock? = nil) {
        self.sd_setImage(with: url, placeholderImage: placeholder) { (image, error, cacheType, url) in
            if let downloadedImage = image {
                guard cacheType != .none else { return }
                self.alpha = 0.0
                UIView.transition(with: self, duration: 0.15, options: [.transitionCrossDissolve], animations: {
                    self.image = downloadedImage
                    self.alpha = 1.0
                }, completion: nil)
            } else {
                self.image = placeholder
            }
            completed?(image, error, cacheType, url)
        }
    }
}
