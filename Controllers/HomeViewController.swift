//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let homeFeedTableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
        
    }
    

   
}


extension HomeViewController {
    
    func setup(){
        homeFeedTableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        view.addSubview(homeFeedTableView)
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        
    }
    
    
    
    func style(){
        
        view.backgroundColor = .systemBackground
        
        
        
        
    }
    
    func layout(){
        
        homeFeedTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

extension HomeViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
    
}
