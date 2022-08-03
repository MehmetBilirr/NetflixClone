//
//  UpcomingViewModel.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 3.08.2022.
//

import Foundation
import UIKit

class UpcomingViewModel{
    
    let naVCon = UINavigationController()
    
    func fetchData(tableView:UITableView,titleArray:[Title]) -> [Title] {
        var array = [Title]()
        NetworkServiceTMDB.shared.fetchUpcomingMovies { response in
            switch response {
            case.success(let data):
                array = data.results
                
                
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
                
                
                
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        
        }
        print(array)
        return array
        
    }
    
    func fetchVideo(query:String,title:Title) {
        
        NetworkServiceYT.shared.fetchVideo(query: query) { result in
            switch result {
            case .success(let video):
                
                DispatchQueue.main.async { [weak self] in
                    let vc = TitlePreviewViewController()
                    let viewModel = TitlePreviewModel(title: query, youtubeView: video, titleOverview: title.overview ?? "")
                    vc.configure(model: viewModel)
                    
                    self?.naVCon.pushViewController(vc, animated: true)
                    }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
