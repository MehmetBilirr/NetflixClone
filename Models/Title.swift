//
//  Title.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 20.07.2022.
//

import Foundation

struct TrendingTitleRepsonse:Codable {
    let results:[Title]
    
}


struct Title:Codable {
    
    let poster_path:String?
    let id:Int
    let media_type:String?
    let overview:String?
    let release_date:String?
    let original_title:String?
    let original_name:String?
    let vote_average:Double
    let vote_count:Int
    
    
    
}



