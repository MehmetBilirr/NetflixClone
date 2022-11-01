//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit
import SnapKit

protocol CollectionViewTableViewCellDelegate:AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell:CollectionViewTableViewCell,viewModel:TitlePreviewModel,title:Title)
}


class CollectionViewTableViewCell: UITableViewCell {
    weak var delegate: CollectionViewTableViewCellDelegate?
    static let identifier = "CollectionViewTableViewCell"
    var titlesArray = [Title]()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        
        stylee()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    
}


extension CollectionViewTableViewCell {
    
    private func setup() {
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private func stylee() {
        contentView.backgroundColor = .systemPink
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        
    }
    func configure(titles:[Title]) {
            self.titlesArray = titles
        
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    private func downloadTitleAt(indexpath:IndexPath) {
        
        DataPersistanceManager.shared.downloadTitleWith(model: titlesArray[indexpath.row]) { result in
            switch result{
            case.success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    
}

extension CollectionViewTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell
        cell?.configure(with: titlesArray[indexPath.row].poster_path ?? "")
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titlesArray[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title else {return}
        
        
        NetworkServiceYT.shared.fetchVideo(query: titleName + "trailer") { [weak self] result in
            switch result {
            case.success(let video):
                guard let title = self?.titlesArray[indexPath.row] else {return}
                guard let strongSelf = self else {return}
                let titleName = title.original_title ?? title.original_name
                
                let overview = title.overview
                let viewModel = TitlePreviewModel(title: titleName ?? "", youtubeView: video, titleOverview: overview ?? "")
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel, title: title)
            case.failure(let error):
                print(error)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self.downloadTitleAt(indexpath: indexPath)
                collectionView.reloadData()
                
            
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
        
    }
    
    
    
}
