//
//  HeroListStoreProtocol.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation

protocol HeroListStoreProtocol {
    
    func save(heroList: [Hero])
    func getHeroList() -> [Hero]?
    func getHero(id: Int) -> Hero?
    func write(writeBlock: () -> Void)
}
