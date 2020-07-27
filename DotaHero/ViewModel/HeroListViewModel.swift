//
//  HeroListViewModel.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import RxSwift

class HeroListViewModel {
        
    var rxEventLoadHeroRoleList: PublishSubject<Void> {
        return eventLoadHeroRoleList
    }
    
    var rxEventLoadHeroList: PublishSubject<Void> {
        return eventLoadHeroList
    }
    
    var rxEventOpenHeroDetailPage: PublishSubject<Hero> {
        return eventOpenHeroDetailPage
    }
    
    var heroListModel = [Hero]()
    var heroCategoryList = [String]()
    var selectedHeroList = [Hero]()
    var isFirstLoad = false
    
    private let eventLoadHeroRoleList = PublishSubject<Void>()
    private let eventLoadHeroList = PublishSubject<Void>()
    private let eventOpenHeroDetailPage = PublishSubject<Hero>()
    private let heroApi: HeroApiServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(heroApi: HeroApiServiceProtocol) {
        self.heroApi = heroApi
    }
    
    func viewLoad() {
        getHeroList()
        isFirstLoad = true
    }
    
    func didSelectHeroCategory(index: Int) {
        let selectedRole = heroCategoryList[index]
        selectedHeroList.removeAll()
        heroListModel.forEach { hero in
            if hero.roles.contains(selectedRole) {
                selectedHeroList.append(hero)
            }
        }
        
        eventLoadHeroList.onNext(())
    }
    
    func openHeroDetailPage(selectedHeroIndex: Int) {
        let selectedHero = selectedHeroList[selectedHeroIndex]
        eventOpenHeroDetailPage.onNext(selectedHero)
    }
    
    private func getHeroList() {
        heroApi.getHeroList()
            .subscribe(onSuccess: { [weak self] hero in
                guard let weakSelf = self, let herList = hero else { return }
                weakSelf.heroListModel = herList
                weakSelf.generateHeroCategoryList()
            }).disposed(by: disposeBag)
    }
    
    private func generateHeroCategoryList() {
        heroListModel.forEach { hero in
            heroCategoryList = Array(Set(hero.roles).union(heroCategoryList))
        }
        heroCategoryList.sort()
        eventLoadHeroRoleList.onNext(())
    }
}


