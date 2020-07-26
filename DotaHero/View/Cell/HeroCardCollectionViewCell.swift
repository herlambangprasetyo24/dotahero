//
//  HeroCardCollectionViewCell.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 25/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import UIKit

class HeroCardCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    func setupUI(heroName: String, heroImage: String) {
        self.heroName.text = heroName
        self.heroImage.loadUrl(Domain.baseUrl + heroImage)
    }
    
}
