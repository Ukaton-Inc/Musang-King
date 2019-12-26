//
//  RecordingTableViewCell.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/24/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

struct RecordingTableViewCellModel {
    var title: String
    var date: String
    var time: String
    var description: String
    
    init(title: String, date: String, time: String, description: String) {
        self.title = title
        self.date = date
        self.time = time
        self.description = description
    }
}

class RecordingTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
           
        return label
       }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        
        return label
       }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        self.applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(descriptionLabel)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            
            // title label
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.widthAnchor, multiplier: 2/3),
            
            // date label
            self.dateLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: 20),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            
            // description label
            self.descriptionLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            self.descriptionLabel.widthAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.widthAnchor, multiplier: 1/3),
            
            // time label
            self.timeLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor),
            self.timeLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            self.timeLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    func bind(with cellModel: RecordingTableViewCellModel) {
        self.titleLabel.text = cellModel.title
        self.dateLabel.text = cellModel.date
        self.timeLabel.text = cellModel.time
        self.descriptionLabel.text = cellModel.description
    }
    

}
