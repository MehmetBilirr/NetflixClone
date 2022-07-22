//
//  NetworkServiceYT.swift.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 23.07.2022.
//

import Foundation

class NetworkServiceYT {
    
    static let shared = NetworkServiceYT()
    private init() {}
    
    func fetchVideo(query:String,completion:@escaping(Result<YoutubeSearchResponse,Error>)->Void) {
        requestYT(route: .fetchMovie(query), method: .get, completion: completion)
    }
    
    private func requestYT<T:Codable>(route:RouteYT,method:Method,parameters:[String:Any]? = nil, completion: @escaping(Result<T,Error>) -> Void ) {
        
        guard let request = createRequestYT(route: route, method: method, parameters: parameters) else {
            
            completion(.failure(AppError.unknownError))
            
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            var result: Result<Data,Error>?
            if let data = data {
//                result = .success(data)
//                let responseString = String(data:data, encoding: .utf8) ?? "Could not stringify our data"
//                print("The response is :\n \(responseString)")
                let decoder = JSONDecoder()
                let response = try? decoder.decode(YoutubeSearchResponse.self, from: data)
                completion(.success(response as! T))
                
                
                
                
            }else if let error = error {
                result = .failure(error)
                print("The error is : \(error.localizedDescription)")
            }
            
            
//            DispatchQueue.main.async {
//
//                // TODO decode our result and send back to the user
//                self.handleResponse(result: result, completion: completion)
//
//
//            }
        }.resume()
        
        
        
    }
    
    
     
    
    
    
    private func createRequestYT(route: RouteYT, method: Method, parameters:[String:Any]? = nil) -> URLRequest? {
        
        
        
        let urlString = RouteYT.YoutubeBaseURL + route.description
        guard let url = urlString.asUrl else {return nil}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map {
                    URLQueryItem(name: $0, value: "\($1)")}
                urlRequest.url = urlComponent?.url
                
            case .post,.delete,.patch:
                let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                
                
                urlRequest.httpBody = bodyData
                
            }
        }
        return urlRequest
    }
    
    
    
    
}
