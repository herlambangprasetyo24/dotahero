//
//  SwinjectStoryboard+setup.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import SwinjectStoryboard
import Swinject

extension SwinjectStoryboard {
    
    @objc class func setup() {
        Container.loggingFunction = nil
        
        _ = Assembler([
            ViewControllerAssembly(),
            ApisAssembly(),
            StoragesAssembly()
            ],
            container: defaultContainer
        )
    }
}
