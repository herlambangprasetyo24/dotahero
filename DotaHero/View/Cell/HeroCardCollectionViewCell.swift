//
//  HeroCardCollectionViewCell.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 25/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import UIKit

class HeroCardCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroNameView: UIView!
    @IBOutlet weak var heroName: UILabel!
    
    override func awakeFromNib() {
        setupUI()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    private func setupUI() {
        view.layer.cornerRadius = 10
        heroNameView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func setupData(heroName: String, heroImage: String) {
        self.heroName.text = heroName
        self.heroImage.loadUrl(Domain.baseUrl + heroImage)
    }
    
}
