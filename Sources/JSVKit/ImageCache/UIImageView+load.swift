//  UIImageView+load.swift
//
//  Created by Jan Svensson on 2021-08-19.
//

import UIKit

extension UIImageView {
    /// Loads an image from a URL to the image view. Automatically caches the loaded image to the image cache.
    /// - Parameters:
    ///   - url: The URL to fetch from
    ///   - completion: A completion function that is called when the image has been loaded
    public func load(url: URL, _ completion: (() -> Void)? ) {
        let cache = ImageCache.defaults.cache

        if let image = cache[url] {
            self.image = image
            return
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageCache.defaults.cache[url] = image
                    }

                    DispatchQueue.main.async {
                        self?.image = image
                        completion?()
                    }
                }
            }
        }
    }
}

