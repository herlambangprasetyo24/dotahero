//
//  HeroDetailViewModelTests.swift
//  DotaHeroTests
//
//  Created by Herlambang Prasetyo on 28/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import XCTest
import RxSwift
@testable import DotaHero

class HeroDetailViewModelTests: XCTestCase {
    
    var heroDetailViewModel: HeroDetailViewModel!
    private var heroDetail: Hero?
    private var heroList: [Hero]?
    private let store = HeroListStore()
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let heroApi = HeroApiService(heroListStore: store)
        
        heroList = getHeroListMock()
        heroDetail = heroList![1]
        heroDetailViewModel = HeroDetailViewModel(heroApi: heroApi)
        heroDetailViewModel.heroModel = heroDetail!
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewLoad() {
        XCTAssertNotNil(heroDetailViewModel.viewLoad(), "")
    }
    
    func testSetHeroModel() {
        heroDetailViewModel.setHeroModel(heroModel: heroDetail!)
        XCTAssertTrue(heroDetailViewModel.heroModel.id != 0)
        XCTAssertTrue(heroDetailViewModel.heroModel.localizedName == "Axe")
        XCTAssertTrue(heroDetailViewModel.heroModel.primaryAttr == "str")
    }
    
    func testGenerateSimiliarHeroes() {
        store.save(heroList: heroList!)
        heroDetailViewModel.generateSimiliarHeroes()
        
        XCTAssertTrue(heroDetailViewModel.similiarHero.count == heroList?.count)
        XCTAssertTrue(!heroDetailViewModel.similiarHero.isEmpty)
    }
    
    func testOpenHeroDetailPage() {
        heroDetailViewModel.generateSimiliarHeroes()
        heroDetailViewModel.openHeroDetailPage(index: 1)
        
        heroDetailViewModel.rxEventOpenHeroDetailPage
            .subscribe(onNext: { hero in
                XCTAssertTrue(hero.id == 2)
                XCTAssertTrue(hero.localizedName == "Axe")
                XCTAssertTrue(hero.primaryAttr == "str")
            }).disposed(by: disposeBag)
    }
    
    func getHeroListMock() -> [Hero]? {
        if let path = Bundle.main.path(forResource: "HeroList", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let hero = try? JSONDecoder().decode([Hero].self, from: data) as [Hero]
                return hero
              } catch {
                   // handle error
              }
        }
        return nil
    }
}
