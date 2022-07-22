//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit





class UpcomingViewController: UIViewController {
    
    private let upcomingTableView = UITableView(frame: .zero, style: .grouped)
    private var titleArray = [Title]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setup()
        style()
        fetchData()

        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableView.frame = view.bounds
    }
    
    private func setup(){
        
        upcomingTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        view.addSubview(upcomingTableView)
        
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
        
        
        
    }
    
    
    
    private func style(){
        
        view.backgroundColor = .systemBackground
    }
    
    
    
    private func fetchData(){
        NetworkService.shared.fetchUpcomingMovies { response in
            switch response {
            case.success(let data):
                
                self.titleArray = data.results
                DispatchQueue.main.async {
                    self.upcomingTableView.reloadData()
                }
                
                
                
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        
        }
    }
    
    
    
    

}

extension UpcomingViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        cell.configure(title: titleArray[indexPath.row])
                
        
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    

}

    
    



