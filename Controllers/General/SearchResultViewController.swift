//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 22.07.2022.
//

import UIKit


class SearchResultViewController: UIViewController {
    var titlesArray = [Title]()
    let searchResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        stylee()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
   
    
    
}


extension SearchResultViewController {
    
    private func setup() {
        
        searchResultsCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        
    }
    
    private func stylee() {
        view.backgroundColor = .systemBackground
        searchResultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        searchResultsCollectionView.collectionViewLayout = layout
        
        
    }
    

   
        
        
        
    }
    



extension SearchResultViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell
        let title = titlesArray[indexPath.row]
        cell?.configure(with: title.poster_path ?? "")
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titlesArray[indexPath.row]
        guard let query = title.original_title else {return}
        guard let overView = title.overview else {return}
        
        NetworkServiceYT.shared.fetchVideo(query: query) { result in
            switch result {
            case .success(let video):
                
                DispatchQueue.main.async { [weak self] in
                    let titlePreviewVC = TitlePreviewViewController()
                    let model = TitlePreviewModel(title: query, youtubeView: video, titleOverview: overView)
                    titlePreviewVC.configure(model:model)
                    self?.navigationController?.pushViewController(titlePreviewVC, animated: true)
                    }
                
            case .failure(let error):
                print(error)
            }
        }
        
        
        
    }
    
}
