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
        view?.style()
    }
    func fetchData(title: Title) {
        
        guard let query = title.original_title else {return}

//        guard let text = searchController.searchBar.text,!text.trimmingCharacters(in: .whitespaces).isEmpty,text.trimmingCharacters(in: .whitespaces).count >= 3 else {return}
        NetworkServiceYT.shared.fetchVideo(query: query) { [weak self] result in
            switch result {
            case .success(let video):
                DispatchQueue.main.async { [weak self] in
                    print("--------\(video)")
                    let titlePreviewVC = TitlePreviewViewController()
                    let model = TitlePreviewModel(title: title, youtubeView: video)
                    titlePreviewVC.configure(model:model )
                    self?.navigationController?.pushViewController(titlePreviewVC, animated: true)
                    }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
  
    
 
    
    
    

}
