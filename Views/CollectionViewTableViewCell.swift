//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//

import UIKit
import SnapKit

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
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
    
    func setup() {
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func stylee() {
        contentView.backgroundColor = .systemPink
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        
        
        
    }
    
}

extension CollectionViewTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    
    
}
