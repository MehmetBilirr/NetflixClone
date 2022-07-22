//
//  Route.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 20.07.2022.
//

import Foundation


enum RouteTMDB {
    
    static let baseUrl = "https://api.themoviedb.org/3"
    static let apiKey = "4377ea3a3ac936fc129eedc132d674df"
    
    
    
    case fetchTrendingMovies
    case fetchTrendingTvSeries
    case fetchUpComingMovies
    case fetchPopularMovies
    case fetchTopRated
    case fetchDiscoverMovies
    case search(String)
    
    
    
    var description : String {
        
        switch self {
        case.fetchTrendingMovies:
            return "/trending/movie/day?api_key=\(RouteTMDB.apiKey)"
        case .fetchTrendingTvSeries:
            return "/trending/tv/day?api_key=\(RouteTMDB.apiKey)"
        case.fetchUpComingMovies:
            return "/movie/upcoming?api_key=\(RouteTMDB.apiKey)"
        case.fetchPopularMovies:
            return "/movie/popular?api_key=\(RouteTMDB.apiKey)"
        case.fetchTopRated:
            return "/movie/top_rated?api_key=\(RouteTMDB.apiKey)"
        case.fetchDiscoverMovies:
            return "/discover/movie?api_key=\(RouteTMDB.apiKey)&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        case .search(let query):
            return "/search/movie?api_key=\(RouteTMDB.apiKey)&language=en-US&query=\(query)&page=1&include_adult=false"
    
        }
    
    
    }
}
