//
//  UpcomingViewModel.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 3.08.2022.
//

import Foundation
import UIKit


protocol UpcomingViewModelInterface:AnyObject,MainViewModelInterface {
    var view:UpcomingViewInterface? {get set}
    var navigationController:UINavigationController? {get set}
    func viewDidLoad()
    func fetchVideo(at indexpath:IndexPath)
    
}

final class UpcomingViewModel{
    weak var view: UpcomingViewInterface?
    weak var navigationController: UINavigationController?
    var titleArray = [Title]()
    
    
    
}

extension UpcomingViewModel:UpcomingViewModelInterface {
    func viewDidLoad() {
        view?.setup()
        view?.fetchData()
    }
    func fetchData() {
        
        NetworkServiceTMDB.shared.fetchUpcomingMovies { [weak self] response in
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
        titleArray.count
    }
    
    func fetchVideo(at indexpath: IndexPath) {
         let title = titleArray[indexpath.row]
        guard let query = title.original_title else {return}
        NetworkServiceYT.shared.fetchVideo(query: query) { result in
            switch result {
            case .success(let video):
                
                DispatchQueue.main.async { [weak self] in
                    let titlePreviewVC = TitlePreviewViewController()
                    let model = TitlePreviewModel(title: title, youtubeView: video)
                    titlePreviewVC.configure(model:model )
                    self?.navigationController?.pushViewController(titlePreviewVC, animated: true)
                    }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
