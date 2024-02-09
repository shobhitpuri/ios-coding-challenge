//
//  UIColor+Ext.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-08.
//

import UIKit

extension UIColor {
    
    /// Create a UIImage given a color. This is useful placeholder while an Image is loading, since it adheres to the expected size it will fill
    /// The idea was to use blur_has that comes with UnsplashAPI, but the Blur Decoder is very slow
    /// Can read more about slowness here: https://github.com/woltapp/blurhash/issues/70
    /// Blur_has placeholders here: https://unsplash.com/documentation#blurhash-placeholders
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
}
