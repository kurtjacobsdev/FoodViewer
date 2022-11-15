//
//  FoodListingConfiguration.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/06.
//

import DomainLayer
import Foundation

public struct FoodListingConfiguration: Hashable, Identifiable {
    public var id: String
    public var name: String
    public var species: String
}

extension Food {
    func configuration() -> FoodListingConfiguration {
        return FoodListingConfiguration(id: id,
                                        name: name,
                                        species: species)
    }
}
