//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 3.08.2022.
//

import Foundation
import UIKit


class HomeViewModel {
    
    func fetchTrendingMovies(cell:CollectionViewTableViewCell){
        
        NetworkServiceTMDB.shared.fetchTrendingMovies { result in
            switch result {
            case.success(let data):
                cell.configure(titles: data.results)
                let image = data.results[0].poster_path
                HomeViewController.heroViewdelegate?.getheroHeaderImage(data: image!)
                
                
            case.failure(let error):
                print(error.localizedDescription)
            }
            

        }
    }
    
    func fetchPopularMovies(cell:CollectionViewTableViewCell) {
        
        NetworkServiceTMDB.shared.fetchPopularMovies { result in
            switch result {
            case.success(let data):
                cell.configure(titles: data.results)
                
            case.failure(let error):
                print(error.localizedDescription)
            }
            

        }
    }
    
    func fetchTrendingTvs(cell:CollectionViewTableViewCell) {
        
    
    NetworkServiceTMDB.shared.fetchTrendingTvSeries { result in
        switch result {
        case.success(let data):
            cell.configure(titles: data.results)
            
        case.failure(let error):
            print(error.localizedDescription)
        }
        

    }
        
    }
    
    func fetchUpcomingMovies(cell:CollectionViewTableViewCell) {
    NetworkServiceTMDB.shared.fetchUpcomingMovies { result in
        switch result {
        case.success(let data):
            cell.configure(titles: data.results)
            
        case.failure(let error):
            print(error.localizedDescription)
        }
        

    }
    }
    
    func fetchTopRatedMovies(cell:CollectionViewTableViewCell) {
    NetworkServiceTMDB.shared.fetchTopRatedMovies { result in
        switch result {
        case.success(let data):
            cell.configure(titles: data.results)
            
        case.failure(let error):
            print(error.localizedDescription)
        }
        

    }
    }
}
