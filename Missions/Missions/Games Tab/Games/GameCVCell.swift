//
//  GameCVCell.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/27/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

struct GameCellModel {
    
    let title: String
    let image: UIImage
    
    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }
    
}

class GameCVCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
        self.applyContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GameCVCell {
    
    func setupViews() {
        self.contentView.addSubview(imageView)
    }
    
    func applyContraints() {
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
    }
    
    func bind(with cellModel: GameCellModel) {
        self.titleLabel.text = cellModel.title
        self.imageView.image = cellModel.image
    }
}
