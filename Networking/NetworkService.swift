//
//  NetworkService.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 20.07.2022.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func fetchTrendingMovies(completion:@escaping(Result<TrendingTitleRepsonse,Error>)->Void) {
        request(route: .fetchTrendingMovies, method: .get, completion: completion)
    }
    
    func fetchTrendingTvSeries(completion:@escaping(Result<TrendingTitleRepsonse,Error>)->Void) {
        request(route: .fetchTrendingTvSeries, method: .get, completion: completion)
    }
    
    
    func fetchPopularMovies(completion:@escaping(Result<TrendingTitleRepsonse,Error>)->Void) {
        
        request(route: .fetchPopularMovies, method: .get, completion: completion)
    }
    
    func fetchUpcomingMovies(completion:@escaping(Result<TrendingTitleRepsonse,Error>)->Void) {
        request(route: .fetchUpComingMovies, method: .get, completion: completion)
    }
    
    func fetchTopRatedMovies(completion:@escaping(Result<TrendingTitleRepsonse,Error>)->Void) {
        request(route: .fetchTopRated, method: .get, completion: completion)
    }
    
    
    private func request<T:Codable>(route:Route,method:Method,parameters:[String:Any]? = nil, completion: @escaping(Result<T,Error>) -> Void ) {
        
        guard let request = createRequest(route: route, method: method, parameters: parameters) else {
            
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
                let response = try? decoder.decode(TrendingTitleRepsonse.self, from: data)
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
    
    private func handleResponse<T:Codable>(result:Result<Data,Error>?,completion: (Result<T,Error>) -> Void){
        
        
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            
            return
        }
        
        switch result {
            
        case .success(let data):
            
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(ApiResponse<T>.self, from: data) else {
                completion(.failure(AppError.errorDecoding))
                return
            }
            
            if let error = response.error {
                completion(.failure(AppError.serverError(error)))
            }
            
            if let decodedData = response.data {
                completion(.success(decodedData))
                
            }else {
                completion(.failure(AppError.unknownError))
            }
            
        case .failure(let error):
            completion(.failure(error))
        }
        
    }
    
    
    
    private func createRequest (route: Route, method: Method, parameters:[String:Any]? = nil) -> URLRequest? {
        
        
        
        let urlString = Route.baseUrl + route.description
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
