//
//  ApiAssembly.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import Swinject

class ApisAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(HeroApiServiceProtocol.self) { r in
            HeroApiService()
        }
    }

}
