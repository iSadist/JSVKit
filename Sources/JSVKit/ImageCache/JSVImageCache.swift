//
//  ImageCache.swift
//
//  Created by Jan Svensson on 2021-08-19.
//

import Foundation
import class UIKit.UIImage

/// A class that is able to store images according to their URL
public class ImageCache {
    /// Singleton object for the image cache
    static var defaults: ImageCache = ImageCache()

    /// The cache map that holds the images
    var cache: [URL: UIImage]
    
    /// Creates a new empty image cache object
    init() {
        cache = [:]
    }
}
