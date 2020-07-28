//
//  Constant.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation

struct Constant {
    struct Domain {
        static let baseApiUrl = "https://api.opendota.com/api/"
        static let baseUrl = "https://api.opendota.com"
    }
    
    struct NavigationIdentifier {
        static let openHeroDetailPage = "openHeroDetailPage"
    }
    
    struct Error {
        static let noInternetTitle = "Connection Lost"
        static let noInternetMessage = "No Internet Connection"
        static let cancelButton = "Cancel"
        static let retryButton = "Retry"
    }
    
    struct ViewControllerIdentifier {
        static let heroDetailViewController = "HeroDetailViewController"
    }
    
}
