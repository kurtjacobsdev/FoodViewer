//
//  FoodDetailConfiguration.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/06.
//

import DomainLayer
import Foundation

public struct FoodDetailContentItemConfiguration: Hashable {
    public var value: Float
    public var unit: String
}

public struct FoodDetailConfiguration: Hashable, Identifiable {
    public var id: String
    public var name: String
    public var content: [FoodDetailContentItemConfiguration]
    public var cultivationCategory: String
    public var soilImpact: String
    public var species: String
}

extension FoodDetail {
    func configuration() -> FoodDetailConfiguration {
        return FoodDetailConfiguration(id: id,
                                       name: name,
                                       content: [
                                        content.water.configuration(),
                                        content.energy.configuration(),
                                        content.protein.configuration()
                                       ],
                                       cultivationCategory: cultivationCategory,
                                       soilImpact: soilImpact,
                                       species: species)
    }
}

extension FoodContentItem {
    func configuration() -> FoodDetailContentItemConfiguration {
        FoodDetailContentItemConfiguration(value: value,
                                           unit: unit)
    }
}
