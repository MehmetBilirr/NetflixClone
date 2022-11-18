//
//  DownloadViewModel.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 18.11.2022.
//

import Foundation
import UIKit

protocol DownloadViewModelInterface:AnyObject {
     var view:DownloadsViewInterface? {get set}
    func viewDidLoad()
    func fetchData()
    func getTitle(at indexpath: IndexPath) -> TitleItem
    func numberOfRows() -> Int
    func deleteItem(at indexpath:IndexPath,tableView:UITableView,editingStyle: UITableViewCell.EditingStyle)
}


final class DownloadViewModel {
    weak var view: DownloadsViewInterface?
    private var titleArray = [TitleItem]()
}


extension DownloadViewModel:DownloadViewModelInterface {
    func viewDidLoad() {
        view?.setup()
        view?.fetchLocalStorageForDownload()
    }
    
    func fetchData() {
        DataPersistanceManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            
            switch result {
            case.success(let titles):
                print("titles:\(titles)")
                self?.titleArray = titles
                DispatchQueue.main.async {
                    self?.view?.reloadData()
                }
                
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        
        }
    }
    
    func getTitle(at indexpath: IndexPath) -> TitleItem {
        return titleArray[indexpath.row]
    }
    
    func numberOfRows() -> Int {
        titleArray.count
    }
    
    func deleteItem(at indexpath: IndexPath, tableView: UITableView, editingStyle: UITableViewCell.EditingStyle) {
        
        switch editingStyle {
        case.delete:
            DataPersistanceManager.shared.deleteTitleWith(model: titleArray[indexpath.row]) { [weak self] result in
                switch result {
                case.success():
                    print("Deleted from the database")
                case.failure(let error):
                    print(error.localizedDescription)
                }
                self?.titleArray.remove(at: indexpath.row)
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
        default:
            break;
        }
        
    }
    
    
}
