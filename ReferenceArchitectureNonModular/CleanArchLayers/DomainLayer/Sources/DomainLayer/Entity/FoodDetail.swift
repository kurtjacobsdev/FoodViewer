//
//  AnimalDetail.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import Foundation

public struct FoodDetail {
    public var id: String
    public var name: String
    public var content: FoodContent
    public var cultivationCategory: String
    public var soilImpact: String
    public var species: String

    public init(id: String, name: String, content: FoodContent, cultivationCategory: String, soilImpact: String, species: String) {
        self.id = id
        self.name = name
        self.content = content
        self.cultivationCategory = cultivationCategory
        self.soilImpact = soilImpact
        self.species = species
    }
}

public struct FoodContent: Codable {
    public var water: FoodContentItem
    public var energy: FoodContentItem
    public var protein: FoodContentItem

    public init(water: FoodContentItem, energy: FoodContentItem, protein: FoodContentItem) {
        self.water = water
        self.energy = energy
        self.protein = protein
    }
}

public struct FoodContentItem: Codable {
    public var value: Float
    public var unit: String

    public init(value: Float, unit: String) {
        self.value = value
        self.unit = unit
    }
}
