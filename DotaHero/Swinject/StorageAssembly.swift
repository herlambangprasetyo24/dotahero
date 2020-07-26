//
//  StorageAssembly.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import Swinject

class StoragesAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(HeroListStoreProtocol.self) { r in
            HeroListStore()
        }
    }
}
