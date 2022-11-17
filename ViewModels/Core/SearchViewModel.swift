//
//  SearchViewModel.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.11.2022.
//

import Foundation
import UIKit
protocol MainViewModelInterface{
    func viewDidLoad()
    func fetchData()
    func getTitle(at indexpath:IndexPath) -> Title
    func numberOfRows() -> Int
}

protocol SearchViewModelInterface:AnyObject,MainViewModelInterface {
    var navigationController:UINavigationController? {get set}
    var view:SearchViewInterface? {get set}
    func viewDidLoad()
    func pushToSearchResultVC(searchController:UISearchController)

}

final class SearchViewModel {
    
    weak var navigationController: UINavigationController?
    private var titleArray = [Title]()
    weak var view: SearchViewInterface?
    
}

extension SearchViewModel:SearchViewModelInterface {

    func viewDidLoad() {
        view?.setup()
        view?.style()
        view?.fetchData()
    }
    
    func fetchData() {
        
        NetworkServiceTMDB.shared.fetchDiscoverMovies { [weak self] response in
            switch response {
            case.success(let data):
                
                self?.titleArray = data.results
                
                DispatchQueue.main.async {
                    self?.view?.reloadData()
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        
        }
    }
    
    func getTitle(at indexpath: IndexPath) -> Title {
        return titleArray[indexpath.row]
    }
    
    func numberOfRows() -> Int {
        return titleArray.count
    }
    func pushToSearchResultVC(searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else {return}
        
        NetworkServiceTMDB.shared.fetchSearchResult(query: query) { result in
            switch result {
            case.success(let titles):
                resultController.titlesArray = titles.results
                DispatchQueue.main.async {
                    resultController.searchResultsCollectionView.reloadData()
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}



