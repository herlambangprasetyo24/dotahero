//
//  HeroListStore.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import RealmSwift

class HeroListStore: HeroListStoreProtocol {
    
    let realm = try! Realm()
    
    func save(heroList: [Hero]) {
        try! realm.write {
            realm.add(heroList, update: .all)
            let a = getHeroList()
            print(a)
        }
    }
    
    func getHeroList() -> [Hero]? {
        return Array(realm.objects(Hero.self))
    }
    
    func getHero(id: Int) -> Hero? {
        realm.objects(Hero.self).filter("id = \(id)").first
    }
    
    func write(writeBlock: () -> Void) {
        do {
            try realm.write(writeBlock)
        } catch {
            debugPrint("fail to realm write")
        }
    }

}
