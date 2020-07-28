//
//  HeroApiServiceTests.swift
//  DotaHeroTests
//
//  Created by Herlambang Prasetyo on 28/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import XCTest
import RxSwift
@testable import DotaHero

class HeroApiServiceTests: XCTestCase {
    
    private var api: HeroApiService!
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let store = HeroListStore()
        api = HeroApiService(heroListStore: store)
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testGetHeroList() {
        weak var getHeroListPromise = expectation(description: "Success get hero list")
        api.getHeroList()
            .subscribe(onSuccess: { heroList in
                XCTAssertTrue(!heroList!.isEmpty)
                getHeroListPromise?.fulfill()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
