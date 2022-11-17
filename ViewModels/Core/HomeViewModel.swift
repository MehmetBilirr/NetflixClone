//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 3.08.2022.
//

import Foundation
import UIKit

protocol HomeViewModelInterface:AnyObject{
    var view:HomeViewInterface? {get set}
    var navigationController:UINavigationController? {get set}
    func fetchTrendingMovies()
    func fetchPopularMovies()
    func fetchUpcomingMovies()
    func fetchTrendingTvs()
    func fetchTopRatedMovies()
    func didTapCell(_ cell:CollectionViewTableViewCell,viewModel:TitlePreviewModel,title:Title)
}

final class HomeViewModel {
    var trendingMovies = [Title]()
    var popularMovies = [Title]()
    var trendingTVs = [Title]()
    var upcomingMovies = [Title]()
    var topRatedMovies = [Title]()
    weak var view: HomeViewInterface?
    weak var navigationController: UINavigationController?
    static var heroViewDelegate: heroHeaderViewDelegate?
    
}

extension HomeViewModel:HomeViewModelInterface {
    
    

    func viewDidLoad() {
        view?.fetchData()
        view?.setup()
        view?.configureNavBar()
    }
    
    
    func fetchTrendingMovies(){
        
        NetworkServiceTMDB.shared.fetchTrendingMovies { [weak self] result in
            switch result {
            case.success(let data):
                self?.trendingMovies = data.results
                let image = data.results[0].poster_path
                HomeViewModel.heroViewDelegate?.getheroHeaderImage(data: image!)
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchPopularMovies() {
        
        NetworkServiceTMDB.shared.fetchPopularMovies { [weak self]result in
            switch result {
            case.success(let data):
                self?.popularMovies = data.results
                
            case.failure(let error):
                print(error.localizedDescription)
            }
            

        }
    }
    
    func fetchTrendingTvs() {
        
    
    NetworkServiceTMDB.shared.fetchTrendingTvSeries { [weak self] result in
        switch result {
        case.success(let data):
            self?.trendingTVs = data.results
            
        case.failure(let error):
            print(error.localizedDescription)
        }
        

    }
        
    }
    
    func fetchUpcomingMovies() {
    NetworkServiceTMDB.shared.fetchUpcomingMovies { [weak self] result in
        switch result {
        case.success(let data):
            self?.upcomingMovies = data.results
            
        case.failure(let error):
            print(error.localizedDescription)
        }
        

    }
    }
    
    func fetchTopRatedMovies() {
    NetworkServiceTMDB.shared.fetchTopRatedMovies { [weak self] result in
        switch result {
        case.success(let data):
            self?.topRatedMovies = data.results
            
        case.failure(let error):
            print(error.localizedDescription)
        }
    }
    }
    func didTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewModel,title:Title) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(model: viewModel)
            vc.chosenTitle = title
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
