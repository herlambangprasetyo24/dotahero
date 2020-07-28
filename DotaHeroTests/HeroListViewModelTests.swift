//
//  HeroListViewModelTests.swift
//  DotaHeroTests
//
//  Created by Herlambang Prasetyo on 28/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import XCTest
import RxSwift
@testable import DotaHero

class HeroListViewModelTests: XCTestCase {
    
    private var heroListViewModel: HeroListViewModel!
    private var heroList: [Hero]?
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let store = HeroListStore()
        let heroApi = HeroApiService(heroListStore: store)
        
        heroList = getHeroListMock()
        heroListViewModel = HeroListViewModel(heroApi: heroApi)
        heroListViewModel.heroListModel = heroList ?? [Hero]()
        heroListViewModel.selectedHeroList = heroList ?? [Hero]()
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewLoad() {
        XCTAssertNotNil(heroListViewModel.viewLoad(), "")
    }
    
    func testDidSelectHeroCategory() {
        heroListViewModel.heroCategoryList = ["Carry", "Disabler", "Jungler", "Nuker", "Initiator"]
        heroListViewModel.didSelectHeroCategory(index: 3)
        
        XCTAssertTrue(heroListViewModel.selectedHeroList.count == 2)
        XCTAssertTrue(heroListViewModel.selectedHeroList.first?.localizedName == "Anti-Mage")
        XCTAssertTrue(heroListViewModel.selectedHeroList.first?.id == 1)
        XCTAssertTrue(heroListViewModel.selectedHeroList.last?.localizedName == "Bane")
        XCTAssertTrue(heroListViewModel.selectedHeroList.last?.id == 3)
    }
    
    func testOpenHeroDetailPage() {
        XCTAssertNotNil(heroListViewModel.openHeroDetailPage(selectedHeroIndex: 0), "")
    }
    
    func testGenerateHeroCategoryList() {
        let expectedCategoryList = ["Carry", "Disabler", "Durable", "Escape", "Initiator", "Jungler", "Nuker", "Support"]
        heroListViewModel.generateHeroCategoryList()
        
        XCTAssertTrue(!heroListViewModel.heroCategoryList.isEmpty)
        XCTAssertTrue(heroListViewModel.heroCategoryList == expectedCategoryList)
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
