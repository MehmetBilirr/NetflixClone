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
    
    func fetchVideo(query:String,completion:@escaping(Result<VideoElement,Error>)->Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        requestYT(route: .fetchMovie(query), method: .get, completion: completion)
    }
    
    private func requestYT(route:RouteYT,method:Method,parameters:[String:Any]? = nil, completion: @escaping(Result<VideoElement,Error>) -> Void ) {
        
        guard let request = createRequestYT(route: route, method: method, parameters: parameters) else {
            
            completion(.failure(AppError.unknownError))
            
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
                

            } catch {
                completion(.failure(error))
                
            }

        
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
