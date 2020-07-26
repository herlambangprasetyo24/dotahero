//
//  HeroModel.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import RealmSwift

class Hero: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var localizedName: String = ""
    @objc dynamic var primaryAttr: String = ""
    @objc dynamic var image: String = ""
    var roles = List<String>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case roles
        case image = "img"

    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.localizedName = try values.decodeIfPresent(String.self, forKey: .localizedName) ?? ""
        self.primaryAttr = try values.decodeIfPresent(String.self, forKey: .primaryAttr) ?? ""
        self.image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        
        let rolesList = try values.decodeIfPresent([String].self, forKey: .roles) ?? [String()]
        roles.append(objectsIn: rolesList)
        
    }
    
}
