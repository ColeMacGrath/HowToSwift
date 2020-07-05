# How to download and cache Images

## Class Code

```swift
enum Request: Int {
    case GET
    case POST
    case PATCH
    case DELETE
    case PUT
}

enum APIError: Error {
    case networkError(description: String?)
    case jsonNotCreated(description: String?)
    case genericError(description: String?)
    case invalidResponseCode(responseCode: Int?)
    case invalidURL
    case bodyRequiered
}


class APIService {
    private static let _shared = APIService()
    private var _maxRequestTime: Int = 25
    private let configuration = URLSessionConfiguration.default
    private let urlSession: URLSession
    
    static var shared: APIService {
        return _shared
    }
    
    init() {
        configuration.timeoutIntervalForRequest = TimeInterval(self._maxRequestTime)
        self.urlSession = URLSession(configuration: self.configuration)
    }
    
    func downloadImageWith(url: String, handler: @escaping (_ data: Any?) -> Void) {
        guard let URL = URL(string: url) else {
            handler(APIError.invalidURL)
            return
        }
        
        let imageCache = NSCache<AnyObject, AnyObject>()
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            handler(imageFromCache)
            return
        }
        
        URLSession.shared.dataTask(with: URL) { (data, response, error) in
            guard error == nil else {
                handler(APIError.networkError(description: error!.localizedDescription))
                return
            }
            
            guard let imageToCache = UIImage(data: data!) else {
                handler(APIError.genericError(description: "Imposible to create UIImage"))
                return
            }
            
            imageCache.setObject(imageToCache, forKey: URL.absoluteURL as AnyObject)
            handler(imageToCache)
            
        }.resume()
    }
    
    var maxRequestTime: Int {
        set { self._maxRequestTime = newValue   }
        get { return self._maxRequestTime       }
    }
    
}
```

### Ussage

```swift
APIService.shared.downloadImageWith(url: "https://images4.alphacoders.com/936/936378.jpg") { (response) in
    if let error = response as? APIError {
        print("Error: \(error.localizedDescription)")
    } else if let image = response as? UIImage {
        //Showing downloaded image
        image
        return
    }
}
```

## Downloading directly from UIImageView (CacheImageClass)

## Instructions

* Set CacheImageView for UIImageView 

```swift
import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CacheImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageFrom(urlString: String) {
        self.imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    imageCache.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
                    self.image = imageToCache
                }
            }
        }.resume()
    }
}
```

## Ussage

```swift
@IBOutlet weak var cachaImageView: CacheImageView! //Class is CacheImageView not UIImageView
self.cachaImageView.loadImageFrom(urlString: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1200px-Apple_logo_black.svg.png")
```
