//
//  HeroInformationView.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 27/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import UIKit

class HeroInformationView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var attributeValueLabel: UILabel!
    @IBOutlet weak var attributeImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    func setupUI(value: String, imageName: String) {
        attributeValueLabel.text = value
        attributeImageView.image = UIImage(named: imageName)
    }
        
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard nib.instantiate(withOwner: self, options: nil).count > 0 else { return UIView() }
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    private func commonSetup() {
        let nibView = loadViewFromNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(nibView)
    }

}
