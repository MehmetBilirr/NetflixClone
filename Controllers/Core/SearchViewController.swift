//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit

protocol SearchViewInterface:AnyObject {
    func setup()
    func style()
    func fetchData()
    func reloadData()
}

final class SearchViewController: UIViewController {

    
    
    private let discoverTableView = UITableView(frame: .zero, style: .grouped)
    private var searchController = UISearchController()
    private let resultSearchVC = SearchResultViewController()
    private let viewModel = SearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
        viewModel.navigationController = navigationController
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }

}


extension SearchViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .systemBackground
        cell.configure(title: viewModel.getTitle(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

}

extension SearchViewController:UISearchResultsUpdating,UISearchControllerDelegate {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text,!text.trimmingCharacters(in: .whitespaces).isEmpty,text.trimmingCharacters(in: .whitespaces).count >= 3 else {return}
        viewModel.pushToSearchResultVC(query: text, searchController: searchController)
        
    }
    
}

extension SearchViewController:SearchViewInterface {
    func setup() {
        discoverTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        view.addSubview(discoverTableView)
        
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
        
        searchController = UISearchController(searchResultsController: resultSearchVC)
        discoverTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
    }
    
    func style() {
        view.backgroundColor = .systemBackground
        
        searchController.searchBar.tintColor = .white
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
    }
    
    func fetchData() {
        viewModel.fetchData()
        
    }
    func reloadData() {
        discoverTableView.reloadData()
    }
    
    
}


