//
//  HeroDetailViewModel.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 27/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import RxSwift

enum HeroPrimaryAttribute {
    case agi
    case str
    case int
    
    func getPrimaryAttribute() -> String {
        switch self {
        case .agi:
            return "agi"
        case .str:
            return "str"
        case .int:
            return "int"
        }
    }
}

class HeroDetailViewModel {
    
    var rxEventLoadHeroDetail: PublishSubject<Void> {
        return eventLoadHeroDetail
    }
    
    var rxEventLoadSimiliarHero: PublishSubject<Void> {
        return eventLoadSimiliarHero
    }
    
    var rxEventOpenHeroDetailPage: PublishSubject<Hero> {
        return eventOpenHeroDetailPage
    }
    
    var heroModel = Hero()
    var similiarHero = [Hero]()

    private let similiarHeroPrefix = 3
    private let eventLoadHeroDetail = PublishSubject<Void>()
    private let eventLoadSimiliarHero = PublishSubject<Void>()
    private let eventOpenHeroDetailPage = PublishSubject<Hero>()
    private let heroApi: HeroApiServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(heroApi: HeroApiServiceProtocol) {
        self.heroApi = heroApi
    }
    
    func viewLoad() {
        loadHeroDetail()
        generateSimiliarHeroes()
    }
    
    func setHeroModel(heroModel: Hero) {
        self.heroModel = heroModel
    }
    
    func openHeroDetailPage(index: Int) {
        let selectedSimiliarHero = similiarHero[index]
        eventOpenHeroDetailPage.onNext(selectedSimiliarHero)
    }
    
    private func loadHeroDetail() {
        eventLoadHeroDetail.onNext(())
    }
    
    private func generateSimiliarHeroes() {
        guard let heroList = heroApi.getHeroListFromCache() else { return }
        var sortedHeroList = [Hero]()
        
        if heroModel.primaryAttr == HeroPrimaryAttribute.agi.getPrimaryAttribute() {
            sortedHeroList = heroList.sorted(by: { $0.movementSpeed > $1.movementSpeed })
        } else if heroModel.primaryAttr == HeroPrimaryAttribute.str.getPrimaryAttribute() {
            sortedHeroList = heroList.sorted(by: { $0.baseAttackMax > $1.baseAttackMax })
        } else {
            sortedHeroList = heroList.sorted(by: { $0.baseMana < $1.baseMana })
        }
        
        similiarHero = Array(sortedHeroList.prefix(similiarHeroPrefix))
        removeCurrentHero(sortedHeroList: sortedHeroList)
    }
    
    private func removeCurrentHero(sortedHeroList: [Hero]) {
        guard let currentHeroIndex = similiarHero.firstIndex(of: heroModel) else { return }
        let count = similiarHero.count
        self.similiarHero.remove(at: currentHeroIndex)
        self.similiarHero.append(sortedHeroList[count])
    }

}
