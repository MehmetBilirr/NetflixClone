//
//  RouteYT.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 22.07.2022.
//

import Foundation

enum RouteYT {
    
    static let YoutubeAPI_Key = "AIzaSyAaKCJPed26OEeh6G4OMvHpraHJ0u1TlsM"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search"
    
    case fetchMovie(String)
    
    var description:String {
        switch self {
        case .fetchMovie(let query):
            return "?q=\(query)&key=\(RouteYT.YoutubeAPI_Key)"
        }
    }
}


