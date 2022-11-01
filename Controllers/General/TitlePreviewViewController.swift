//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by Mehmet Bilir on 23.07.2022.
//

import UIKit
import WebKit
import SnapKit



class TitlePreviewViewController: UIViewController {
    private let webView = WKWebView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let button = UIButton()
    var chosenTitle:Title?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
        
    }
    

   
}

extension TitlePreviewViewController {
    
    private func setup(){
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(button)
    }
    
    private func style(){
        view.backgroundColor = .systemBackground
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.textAlignment = .center
        overviewLabel.font = .systemFont(ofSize: 18, weight: .regular)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byWordWrapping
        
        
        
        
        
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func layout(){
        
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(20)
            make.centerX.equalTo(view.center.x)
            
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view.center.x)
            make.width.equalTo(200)
        }
        
    }
    
    func configure(model:TitlePreviewModel) {
        
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {return }
        webView.load(URLRequest(url: url))
    }
    
    @objc func downloadButtonTapped(){
        print("downloaded")
        DataPersistanceManager.shared.downloadTitleWith(model: chosenTitle!) { [weak self] result in
            
            switch result {
                
            case .success():
                print("downloaded")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
