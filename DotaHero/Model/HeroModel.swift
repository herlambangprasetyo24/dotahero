//
//  HeroModel.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import UIKit

struct Hero: Codable {
    var id: Int = 0
    var name: String = ""
    var localizedName: String = ""
    var primaryAttr: String = ""
    var roles = [String]()
    var image: String  = ""
        
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case roles = "roles"
        case image = "img"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        localizedName = try values.decodeIfPresent(String.self, forKey: .localizedName) ?? ""
        primaryAttr = try values.decodeIfPresent(String.self, forKey: .primaryAttr) ?? ""
        roles = try values.decodeIfPresent([String].self, forKey: .roles) ?? [String]()
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
    }
}
