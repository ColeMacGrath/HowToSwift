# How to call an API

## Class Code

```swift
enum Request: String {
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
    
    func request(url: String, requestType: Request, body: [String : Any]? = nil, handler: @escaping (_ json: Any?) -> Void) {
        if let URL = URL(string: url) {
            var request = URLRequest(url: URL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            switch requestType {
            case .POST:
                if let body = body {
                    request.httpMethod = requestType.rawValue
                    request.httpBody = body.percentEscaped().data(using: .utf8)
                } else {
                    handler(APIError.bodyRequiered)
                    return
                }
            default: break
            }
            
            let task = self.urlSession.dataTask(with: request) { (data, response, error) in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {
                        handler(APIError.networkError(description: error?.localizedDescription))
                        return
                }
                
                guard (200 ... 299) ~= response.statusCode else {
                    handler(APIError.invalidResponseCode(responseCode: response.statusCode))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [ String : Any ] {
                        handler(json)
                    } else {
                        handler(APIError.jsonNotCreated(description: "Imposible to create Dictionary"))
                    }
                } catch {
                    handler(APIError.jsonNotCreated(description: error.localizedDescription))
                }
            }
            task.resume()
        } else {
            handler(APIError.invalidURL)
        }
        
    }
    
    var maxRequestTime: Int {
        set { self._maxRequestTime = newValue   }
        get { return self._maxRequestTime       }
    }
    
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
```

### Ussage

```swift
//USAGE for post request with body parameters
APIService.shared.request(url: "https://jsonplaceholder.typicode.com/posts/", requestType: .POST, body: [
    "title" : "My Title" as Any,
    "body" : "My Body" as Any,
    "userId" : 2 as Any
]) { (response) in
    if let error = response as? APIError {
        switch error {
        case .networkError(description: let description):
            print("Network Error: \(String(describing: description))")
        case .jsonNotCreated(description: let description):
            print("JSON not created: \(String(describing: description))")
        case .genericError(description: let description):
            print("Other error: \(String(describing: description))")
        case .invalidResponseCode(responseCode: let responseCode):
            print("Response code invalid: \(String(describing: responseCode))")
        case .invalidURL:
            print("URL not valid")
        case .bodyRequiered:
            print("Body parametrs required for request")
        }
    } else if let json = response as? [String : Any] {
        //printing json response
        print("""
        JSON response from POST request:
        \(json)
        --------------------------------
        """)
    }
}

//USAGE for GET request with body parameters
APIService.shared.request(url: "https://jsonplaceholder.typicode.com/posts/1", requestType: .GET) { (response) in
    if let error = response as? APIError {
        switch error {
        case .networkError(description: let description):
            print("Error de red: \(String(describing: description))")
        case .jsonNotCreated(description: let description):
            print("el json no fue creado: \(String(describing: description))")
        case .genericError(description: let description):
            print("Error desconicdo: \(String(describing: description))")
        case .invalidResponseCode(responseCode: let responseCode):
            print("Código invalido: \(String(describing: responseCode))")
        case .invalidURL:
            print("LA URL no es váilida")
        case .bodyRequiered:
            print("Body requerido para la petición")
        }
    } else if let json = response as? [String : Any] {
        print("""
        JSON response from GET request:
        \(json)
        --------------------------------
        """)
    }
}
```
