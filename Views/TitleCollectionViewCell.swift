//
//  TitleCollectionViewCell.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 20.07.2022.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model :String) {
        
        let url = "https://image.tmdb.org/t/p/w500/\(model)"
        self.posterImageView.sd_setImage(with: url.asUrl)
        
        
    
    }
    
}
