//
//  HeroApiServiceProtocol.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import RxSwift

protocol HeroApiServiceProtocol {
    func getHeroList() -> Single<[Hero]?>
    func getHeroListFromCache() -> [Hero]?
}
