import Foundation

class APIClient {
    
    class EncodablePlaceHolder: Encodable {
    }
    
    enum ApiErrors: Error {
        case failure
    }
    
    private let session: URLSession
    private let uuid = UUID().uuidString
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: sessionConfiguration)
    }
    private func makeRequest<T:Decodable, E: Encodable>(url: URL?,
                                                        httpMethod: String,
                                                        data: E?,
                                                        parameters: [String: Any],
                                                        completion: @escaping (Result<T?, Error>) -> Void) {
        
        guard let url = url else { return }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = parameters.map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents?.queryItems = queryItems
        var request = URLRequest(url: (urlComponents?.url)!)
        
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 12575b749c2df9c83517483db37475887d5b26e5", forHTTPHeaderField: "Authorization")
        request.addValue(uuid, forHTTPHeaderField: "X-Request-Id")
        
        if let data = data {
            let encodedData = try? JSONEncoder().encode(data)
            request.httpBody = encodedData
        }
        
        let task = session.dataTask(with: request) { responseData, response, responseError in
            
            guard
                let httpStatus = (response as? HTTPURLResponse)?.statusCode
            else { return }
            
            if httpStatus == 204 {
                completion(.success(nil))
                return
            }
            
            guard let data = responseData else {
                guard let error = responseError else { return }
                completion(.failure(error))
                
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}

// MARK: ApiClientProtocol

extension APIClient: ApiClientProtocol {
    
    func getRequest<T: Decodable>(url: URL?,
                                  parameters: [String: Any],
                                  completion: @escaping (Result<T?, Error>) -> Void) {
        makeRequest(url: url,
                    httpMethod: "GET",
                    data: nil as EncodablePlaceHolder?,
                    parameters: parameters,
                    completion: completion)
        
    }
    
    func deleteRequest<T: Decodable>(url: URL?,
                                     parameters: [String: Any],
                                     completion: @escaping (Result<T?, Error>) -> Void) {
        makeRequest(url: url,
                    httpMethod: "DELETE",
                    data: nil as EncodablePlaceHolder?,
                    parameters: parameters,
                    completion: completion)
    }
    
    func postRequest<T: Decodable, E: Encodable>(url: URL?,
                                                 parameters: [String: Any],
                                                 data: E,
                                                 completion: @escaping (Result<T?, Error>) -> Void) {
        makeRequest(url: url,
                    httpMethod: "POST",
                    data: data,
                    parameters: parameters,
                    completion: completion)
    }
}
