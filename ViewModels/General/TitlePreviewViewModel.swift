//
//  TitlePreviewViewModel.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.11.2022.
//

import Foundation

protocol TitlePreviewViewModelInterface {
    var view:TitlePreviewViewInterface? {get set}
    func viewDidLoad()
    func didTapdownloadButton(title:Title)
}


final class TitlePreviewViewModel {
    weak var view:TitlePreviewViewInterface?
    
    
}


extension TitlePreviewViewModel:TitlePreviewViewModelInterface {
    func viewDidLoad() {
        view?.setup()
        view?.style()
        view?.layout()
    }
    
    func didTapdownloadButton(title: Title) {
        DataPersistanceManager.shared.downloadTitleWith(model: title) { [weak self] result in
            
            switch result {
            case .success():
                print("downloaded")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
