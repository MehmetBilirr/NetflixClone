//
//  Route.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 20.07.2022.
//

import Foundation


enum Route {
    
    static let baseUrl = "https://api.themoviedb.org/3"
    static let apiKey = "4377ea3a3ac936fc129eedc132d674df"
    
    case fetchTrendingMovies
    case placeOrder(String)
    case fetchCategoryDishes(String)
    case fetchOrders
    
    
    var description : String {
        
        switch self {
        case.fetchTrendingMovies:
            return "/trending/movie/day?api_key=\(Route.apiKey)"
        case .placeOrder(let dishId):
            return "/orders/\(dishId)"
        case.fetchCategoryDishes(let categoryId):
            return "/dishes/\(categoryId)"
        case.fetchOrders:
            return "/orders"
        }
    }
}
