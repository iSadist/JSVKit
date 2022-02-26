import Foundation
import class UIKit.UIImage

/// A class that is able to store images according to their URL
public class ImageCache {
    /// Singleton object for the image cache
    public static var defaults: ImageCache = ImageCache()

    /// The cache map that holds the images
    var cache: [URL: UIImage]
    
    /// Creates a new empty image cache object
    init() {
        cache = [:]
    }
}
