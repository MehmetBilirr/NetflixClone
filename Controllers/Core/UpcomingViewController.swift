//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit

protocol UpcomingViewInterface:AnyObject {
    func setup()
    func fetchData()
    func reloadData()

}

final class UpcomingViewController: UIViewController {
    
    private let upcomingTableView = UITableView(frame: .zero, style: .grouped)
    private var titleArray = [Title]()
    private lazy var viewModel = UpcomingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.navigationController = navigationController
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableView.frame = view.bounds
    }
    

}

extension UpcomingViewController:UITableViewDataSource,UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.fetchVideo(at: indexPath)
        
    }
    

}


extension UpcomingViewController:UpcomingViewInterface {
    func setup() {
        
        view.backgroundColor = .systemBackground
        upcomingTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        view.addSubview(upcomingTableView)
        
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
    }
    
    func fetchData() {
        viewModel.fetchData()
    }
    
    func reloadData() {
        upcomingTableView.reloadData()
    }
    
}


    
    



