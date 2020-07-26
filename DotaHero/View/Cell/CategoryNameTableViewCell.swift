//
//  CategoryNameTableViewCell.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 25/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import UIKit

class CategoryNameTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            categoryNameLabel.textColor = .black
            self.backgroundColor = .lightGray
        } else {
            categoryNameLabel.textColor = .white
            self.backgroundColor = .darkGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }

}
