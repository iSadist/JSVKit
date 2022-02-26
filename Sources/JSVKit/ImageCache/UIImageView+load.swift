import UIKit

extension UIImageView {
    /// Loads an image from a URL to the image view. Automatically caches the loaded image to the image cache.
    /// - Parameters:
    ///   - url: The URL to fetch from
    ///   - useCache: Option whether to use cache or not
    ///   - completion: A completion function that is called when the image has been loaded
    public func load(url: URL, useCache: Bool = true, _ completion: (() -> Void)? = nil) {
        let cache = ImageCache.defaults.cache

        if useCache {
            if let image = cache[url] {
                self.image = image
                return
            }
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

