//
//  SearchResultViewModel.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.11.2022.
//

import Foundation
import UIKit

protocol SearchResultViewModelInterface:AnyObject {
    var view:SearchResultViewInterface? {get set}
    var navigationController : UINavigationController? {get set}
    func fetchData(title:Title)
}


final class SearchResultViewModel {
    weak var view: SearchResultViewInterface?
    weak var navigationController: UINavigationController?
}


extension SearchResultViewModel:SearchResultViewModelInterface {
    func viewDidLoad() {
        view?.setup()
        view?.setup()
    }
    func fetchData(title: Title) {
        
        
        guard let query = title.original_title else {return}
        guard let overView = title.overview else {return}
        
        NetworkServiceYT.shared.fetchVideo(query: query) { [weak self] result in
            switch result {
            case .success(let video):
                
                    let titlePreviewVC = TitlePreviewViewController()
                    let model = TitlePreviewModel(title: query, youtubeView: video, titleOverview: overView)
                    titlePreviewVC.configure(model:model)
                    self?.navigationController?.pushViewController(titlePreviewVC, animated: true)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
  
    
 
    
    
    

}
