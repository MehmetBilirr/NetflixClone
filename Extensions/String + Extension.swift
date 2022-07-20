//
//  String + Extension.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 20.07.2022.
//

import Foundation


extension String {
    var asUrl : URL? {
        
        return URL(string: self)
    }
}
