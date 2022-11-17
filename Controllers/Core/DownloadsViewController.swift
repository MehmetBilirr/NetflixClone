//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    private let downloadTableView = UITableView(frame: .zero, style: .grouped)
    private var titleArray = [TitleItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setup()
        style()
        fetchLocalStorageForDownload()

        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTableView.frame = view.bounds
    }
    
    private func setup(){
        
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
    
    
    
    private func style(){
        
        view.backgroundColor = .systemBackground
    }
    
    
    private func fetchLocalStorageForDownload() {
        DataPersistanceManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            switch result {
            case.success(let titles):
                self?.titleArray = titles
                DispatchQueue.main.async {
                    self?.downloadTableView.reloadData()
                }
                
                
            case.failure(let error):
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    
        
    
    
   

}

extension DownloadsViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }

        
                
        
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titleArray[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {return}
        NetworkServiceYT.shared.fetchVideo(query: titleName) { result in
            switch result {
            case .success(let video):
                
                DispatchQueue.main.async { [weak self] in
                    let vc = TitlePreviewViewController()
                    let viewModel = TitlePreviewModel(title: titleName, youtubeView: video, titleOverview: title.overview ?? "")
                    vc.configure(model: viewModel)
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case.delete:
            DataPersistanceManager.shared.deleteTitleWith(model: titleArray[indexPath.row]) { [weak self] result in
                switch result {
                case.success():
                    print("Deleted from the database")
                case.failure(let error):
                    print(error.localizedDescription)
                }
                self?.titleArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
}
