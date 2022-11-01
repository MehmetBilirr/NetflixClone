//
//  UpcomingTableViewCell.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 21.07.2022.
//

import UIKit
import SnapKit
class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    private let posterImage = UIImageView()
    private let nameLabel = UILabel()
    private let playButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        stylee()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
}



extension TitleTableViewCell {
    
    func setup(){
        contentView.addSubview(posterImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(playButton)
    }
    
    private func stylee() {
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.contentMode = .scaleAspectFit
        posterImage.clipsToBounds = true
        posterImage.image = UIImage(named: "batman")
        
        nameLabel.textAlignment = .center
        
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        playButton.setImage(image, for: .normal)
        playButton.tintColor = .white
        
        
        
        
        
        
    }
    
    private func layout(){
        
        posterImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(100)
            make.bottom.equalToSuperview()
        }
        
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(posterImage.snp.right).offset(20)
            make.top.equalToSuperview().offset(55)
            make.right.equalTo(playButton.snp.left)
        }
        
        playButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(55)
            make.width.equalTo(50)
            
        }
        
    }
    
    func configure(title:TitleViewModel) {
        let path =  title.posterPath
        let name = title.titleName 
        
        
        let url = "https://image.tmdb.org/t/p/w500/\(path)"
        self.posterImage.sd_setImage(with: url.asUrl)
        
        nameLabel.text = name
        
    }

}
