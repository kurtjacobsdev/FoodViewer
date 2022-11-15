//
//  AnimalDetailDTO.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import DomainLayer
import Foundation

public struct FoodDetailDTO: AppRepositoryEntity {
    public var id: String
    public var name: String
    public var content: FoodContentDTO
    public var cultivationCategory: String
    public var soilImpact: String
    public var species: String
}

public struct FoodContentDTO: Codable {
    var water: FoodContentItemDTO
    var energy: FoodContentItemDTO
    var protein: FoodContentItemDTO
}

public struct FoodContentItemDTO: Codable {
    var value: Float
    var unit: String
}

extension FoodDetailDTO {
    func entity() -> FoodDetail {
        FoodDetail(id: id,
                   name: name,
                   content: content.entity(),
                   cultivationCategory: cultivationCategory,
                   soilImpact: soilImpact,
                   species: species)
    }
}

extension FoodContentDTO {
    func entity() -> FoodContent {
        FoodContent(water: water.entity(),
                    energy: energy.entity(),
                    protein: protein.entity())
    }
}

extension FoodContentItemDTO {
    func entity() -> FoodContentItem {
        FoodContentItem(value: value,
                        unit: unit)
    }
}
