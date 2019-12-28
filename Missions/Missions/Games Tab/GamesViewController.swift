//
//  GamesViewController.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/27/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

struct GameTitle {
    static let one = "one"
    static let two = "two"
    static let three = "three"
}

class GamesViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
               collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(GameCVCell.self, forCellWithReuseIdentifier: "gameCell")
        
        return collectionView
    }()
    
    private lazy var games: [GameCellModel] = {
        let game1 = GameCellModel(title: "one", image: UIImage(named: "game_1")!)
        let game2 = GameCellModel(title: "two", image: UIImage(named: "game_2")!)
        let game3 = GameCellModel(title: "two", image: UIImage(named: "game_2")!)

        return [game1, game2, game3]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.configureNavBar()
        self.addSubviews()
        self.applyContraints()
    }

}

extension GamesViewController {
    
    func configureNavBar() {
        self.tabBarController?.navigationItem.title = "Games"
    }
    
    func addSubviews() {
        self.view.addSubview(collectionView)
    }
    
    func applyContraints() {
        let layoutMargin = self.view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: layoutMargin.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: layoutMargin.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: layoutMargin.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: layoutMargin.bottomAnchor)
        ])
        
    }
    
}

extension GamesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GameCVCell
        cell.bind(with: games[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.width * 0.9 * 0.75)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let game = games[indexPath.row]
        
        switch game.title {
        case GameTitle.one :
            self.navigationController?.pushViewController(ActivityPredictionViewController(), animated: true)
        case GameTitle.two:
            self.navigationController?.pushViewController(ActivityPredictionViewController(), animated: true)
        default:
            self.navigationController?.pushViewController(ActivityPredictionViewController(), animated: true)
        }
        
    }
}
