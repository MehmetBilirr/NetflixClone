//
//  NetworkService.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 20.07.2022.
//

import Foundation

class NetworkServiceTMDB {
    
    static let shared = NetworkServiceTMDB()
    private init() {}
    
    func fetchTrendingMovies(completion:@escaping(Result<TrendingTitleResponse,Error>)->Void) {
        requestTMDB(route: .fetchTrendingMovies, method: .get, completion: completion)
    }
    
    func fetchTrendingTvSeries(completion:@escaping(Result<TrendingTitleResponse,Error>)->Void) {
        requestTMDB(route: .fetchTrendingTvSeries, method: .get, completion: completion)
    }
    
    
    func fetchPopularMovies(completion:@escaping(Result<TrendingTitleResponse,Error>)->Void) {
        
        requestTMDB(route: .fetchPopularMovies, method: .get, completion: completion)
    }
    
    func fetchUpcomingMovies(completion:@escaping(Result<TrendingTitleResponse,Error>)->Void) {
        requestTMDB(route: .fetchUpComingMovies, method: .get, completion: completion)
    }
    
    func fetchTopRatedMovies(completion:@escaping(Result<TrendingTitleResponse,Error>)->Void) {
        requestTMDB(route: .fetchTopRated, method: .get, completion: completion)
    }
    
    func fetchDiscoverMovies(completion:@escaping(Result<TrendingTitleResponse,Error>)->Void) {
        requestTMDB(route: .fetchDiscoverMovies, method: .get, completion: completion)
    }
    
    func fetchSearchResult(query:String,completion:@escaping(Result<TrendingTitleResponse,Error>)->Void) {
        requestTMDB(route: .search(query), method: .get, completion: completion)
    }
    
    
    private func requestTMDB<T:Codable>(route:RouteTMDB,method:Method,parameters:[String:Any]? = nil, completion: @escaping(Result<T,Error>) -> Void ) {
        
        guard let request = createRequestTMDB(route: route, method: method, parameters: parameters) else {
            
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
                let response = try? decoder.decode(TrendingTitleResponse.self, from: data)
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
    
    
     
    
    
    
    private func createRequestTMDB (route: RouteTMDB, method: Method, parameters:[String:Any]? = nil) -> URLRequest? {
        
        
        
        let urlString = RouteTMDB.baseUrl + route.description
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
