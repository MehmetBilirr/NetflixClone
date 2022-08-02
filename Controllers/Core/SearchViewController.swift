//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    
    
    
    private let discoverTableView = UITableView(frame: .zero, style: .grouped)
    private var titleArray = [Title]()
    private var searchController = UISearchController()
    private let resultSearchVc = SearchResultViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setup()
        style()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
    
    private func setup(){
        
        discoverTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        view.addSubview(discoverTableView)
        
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
        
        
        
        searchController = UISearchController(searchResultsController: resultSearchVc)
        discoverTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        
        
        
    }
        
        
    
    
    
    
    private func style(){
        
        view.backgroundColor = .systemBackground
        
        searchController.searchBar.tintColor = .white
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
    }
    
    
    
    
    
    private func fetchData(){
        NetworkServiceTMDB.shared.fetchDiscoverMovies { response in
            switch response {
            case.success(let data):
                
                self.titleArray = data.results
                
                DispatchQueue.main.async {
                    self.discoverTableView.reloadData()
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        
        }
    }

}


extension SearchViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titleArray[indexPath.row]
        let titleViewModel = TitleViewModel(titleName: title.original_title ?? "", posterPath: title.poster_path ?? "")
        cell.configure(title: titleViewModel)
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    

}

extension SearchViewController:UISearchResultsUpdating,UISearchControllerDelegate {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else {return}
        resultController.delegate = self
        
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

extension SearchViewController: SearchResultViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewModel) {

        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(model: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
}
