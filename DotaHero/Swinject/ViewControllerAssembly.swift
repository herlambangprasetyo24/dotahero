//
//  ViewControllerAssembly.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class ViewControllerAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.storyboardInitCompleted(HeroListViewController.self) { r, c in
            c.heroListViewModel = HeroListViewModel(heroApi: r.resolve(HeroApiServiceProtocol.self)!)
        }
    }
}
