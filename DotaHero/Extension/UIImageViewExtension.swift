//
//  UIImageViewExtension.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    func loadUrl(_ urlString: String, completion: ((_ image: UIImage?) -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        
        sd_setImage(with: url, placeholderImage: nil, options: .highPriority) { image, error, _, _ -> Void in
            guard let completion = completion , error == nil else { return }
            completion(image)
        }
    }
}
