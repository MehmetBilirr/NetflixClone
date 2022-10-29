//
//  HeroHeaderUIView.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 17.07.2022.
//


import UIKit
import SnapKit
import SDWebImage
final class HeroHeaderUIView: UIView {
    private let playButton = UIButton()
    private let downloadButton = UIButton()
    private let heroImageView = UIImageView()
    let homeV = HomeViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
        
        HomeViewModel.heroViewDelegate = self
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}

extension HeroHeaderUIView {
    
    
    private func style(){
        addSubview(heroImageView)
        
        heroImageView.contentMode = .scaleAspectFit
        heroImageView.clipsToBounds = true
//        heroImageView.image = UIImage(named: "batman")
        
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        addGradient()
        addSubview(playButton)
        playButton.setTitle("Play", for: .normal)
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 1
        playButton.layer.cornerRadius = 5
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(downloadButton)
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.borderWidth = 1
        downloadButton.layer.cornerRadius = 5
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
    }
    
    private func layout(){
        
        playButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(75)
            make.top.equalToSuperview().offset(350)
            make.width.equalTo(100)
            
        }
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.top)
            make.right.equalToSuperview().offset(-75)
            make.width.equalTo(100)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
}


extension HeroHeaderUIView:heroHeaderViewDelegate {
    
    
    func getheroHeaderImage(data: String) {
        let url = "https://image.tmdb.org/t/p/w500/\(data)"
        self.heroImageView.sd_setImage(with: url.asUrl)
    }
    
    
}
    
    
    
    
    
    

