//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit
import SnapKit


protocol heroHeaderViewDelegate {
    func getheroHeaderImage(data:String)
}

enum Sections:Int {
    case trendingMovies = 0
    case popular = 1
    case trendingTvs = 2
    case upcoming = 3
    case topRated = 4
}




final class HomeViewController: UIViewController {
    
    private let homeFeedTableView = UITableView(frame: .zero, style: .grouped)
    let sectionTitles : [String] = ["Trendıng Movıes","Popular", "Trendıng Tv","Upcomıng Movıes","Top Rated"]
    var titleArray = [Title]()
    static var heroViewdelegate : heroHeaderViewDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
        configureNavBar()
        
        navigationController?.pushViewController(TitlePreviewViewController(), animated: true)
        
        
        
        
    }
    

   
}


extension HomeViewController {
    
    private func setup(){
        homeFeedTableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        view.addSubview(homeFeedTableView)
        
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTableView.tableHeaderView = headerView
        
    }
    
    
    
    private func style(){
        
        view.backgroundColor = .systemBackground
        
        
        
        
    }
    
    private func layout(){
        
        homeFeedTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    private func configureNavBar(){
        
        let netflixButton = UIButton()
        netflixButton.setImage(UIImage(named: "netflix"), for: .normal)
            
        let leftButton = UIBarButtonItem(customView: netflixButton)
        leftButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        leftButton.customView?.snp.makeConstraints {
         $0.width.height.equalTo(32)
        }
        navigationItem.leftBarButtonItem = leftButton
        
        
        
        navigationItem.rightBarButtonItems = [
            
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
            
        ]
    }
    
    
    
    
    
}

extension HomeViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case Sections.trendingMovies.rawValue:
            NetworkServiceTMDB.shared.fetchTrendingMovies { result in
                switch result {
                case.success(let data):
                    cell.configure(titles: data.results)
                    let image = data.results[0].poster_path
                    HomeViewController.heroViewdelegate?.getheroHeaderImage(data: image!)
                    
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
                

            }
        case Sections.popular.rawValue:
            NetworkServiceTMDB.shared.fetchPopularMovies { result in
                switch result {
                case.success(let data):
                    cell.configure(titles: data.results)
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
                

            }
            
        case Sections.trendingTvs.rawValue:
            NetworkServiceTMDB.shared.fetchTrendingTvSeries { result in
                switch result {
                case.success(let data):
                    cell.configure(titles: data.results)
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
                

            }
            
        case Sections.upcoming.rawValue:
            
            NetworkServiceTMDB.shared.fetchUpcomingMovies { result in
                switch result {
                case.success(let data):
                    cell.configure(titles: data.results)
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
                

            }
        case Sections.topRated.rawValue:
            NetworkServiceTMDB.shared.fetchTopRatedMovies { result in
                switch result {
                case.success(let data):
                    cell.configure(titles: data.results)
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
                

            }
            
        
        default:
            return UITableViewCell()
            
        }
        return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y:min(0, -offset))
    }
    
    
    
}



    

