//
//  APIResponse.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 20.07.2022.
//

import Foundation

struct ApiResponse<T:Codable>:Codable {
    let data: T?
    let error: String?
    
    
    
}
