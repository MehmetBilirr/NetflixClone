//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 22.07.2022.
//

import UIKit


protocol SearchResultViewInterface:AnyObject {
    func setup()
    func style()
}


class SearchResultViewController: UIViewController {
    var titlesArray = [Title]()
    private lazy var viewModel = SearchResultViewModel()
    let searchResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.navigationController = navigationController
        viewModel.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
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
        viewModel.fetchData(title: title)
    }
    
}

extension SearchResultViewController:SearchResultViewInterface {
    func setup() {
        searchResultsCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    func style() {
        
        view.backgroundColor = .systemBackground
        searchResultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        searchResultsCollectionView.collectionViewLayout = layout
    }
    
    
}
