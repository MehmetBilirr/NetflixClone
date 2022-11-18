//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit

protocol DownloadsViewInterface:AnyObject {
    func setup()
    func fetchLocalStorageForDownload()
    func reloadData()
}

final class DownloadsViewController: UIViewController {
    private let downloadTableView = UITableView(frame: .zero, style: .grouped)
    private lazy var viewModel = DownloadViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTableView.frame = view.bounds
    }
    
    
}

extension DownloadsViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .systemBackground
        cell.setup(title: viewModel.getTitle(at: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        viewModel.deleteItem(at: indexPath, tableView: tableView, editingStyle: editingStyle)
    }
    
}


extension DownloadsViewController:DownloadsViewInterface {
    func setup() {
        view.backgroundColor = .systemBackground
        downloadTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        view.addSubview(downloadTableView)
        
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        
        
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    func fetchLocalStorageForDownload() {
        viewModel.fetchData()
       
    }
    
    func reloadData() {
        downloadTableView.reloadData()
    }
    
}
