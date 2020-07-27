//
//  HeroModel.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import RealmSwift

class Hero: Object, Decodable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var localizedName = ""
    @objc dynamic var primaryAttr = ""
    @objc dynamic var image = ""
    @objc dynamic var movementSpeed = 0
    @objc dynamic var primaryAttribute = ""
    @objc dynamic var attackType = ""
    @objc dynamic var baseAttackMin = 0
    @objc dynamic var baseAttackMax = 0
    @objc dynamic var baseHealth = 0
    @objc dynamic var baseMana = 0
    @objc dynamic var baseArmor: Float = 0.00
    
    var roles = List<String>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case roles = "roles"
        case image = "img"
        case movementSpeed = "move_speed"
        case primaryAttribute
        case attackType = "attack_type"
        case baseAttackMin = "base_attack_min"
        case baseAttackMax = "base_attack_max"
        case baseHealth = "base_health"
        case baseMana = "base_mana"
        case baseArmor = "base_armor"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.localizedName = try values.decodeIfPresent(String.self, forKey: .localizedName) ?? ""
        self.primaryAttr = try values.decodeIfPresent(String.self, forKey: .primaryAttr) ?? ""
        self.image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.movementSpeed = try values.decodeIfPresent(Int.self, forKey: .movementSpeed) ?? 0
        self.primaryAttribute = try values.decodeIfPresent(String.self, forKey: .primaryAttribute) ?? ""
        self.attackType = try values.decodeIfPresent(String.self, forKey: .attackType) ?? ""
        self.baseAttackMin = try values.decodeIfPresent(Int.self, forKey: .baseAttackMin) ?? 0
        self.baseAttackMax = try values.decodeIfPresent(Int.self, forKey: .baseAttackMax) ?? 0
        self.baseHealth = try values.decodeIfPresent(Int.self, forKey: .baseHealth) ?? 0
        self.baseMana = try values.decodeIfPresent(Int.self, forKey: .baseMana) ?? 0
        self.baseArmor = try values.decodeIfPresent(Float.self, forKey: .baseArmor) ?? 0.00
        
        let rolesList = try values.decodeIfPresent([String].self, forKey: .roles) ?? [String()]
        roles.append(objectsIn: rolesList)
    }
    
}
