//
//  AnimalDTO.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import DomainLayer
import Foundation

public struct FoodDTO: AppRepositoryEntity {
    public var id: String
    public var name: String
    public var species: String
}

extension FoodDTO {
    func entity() -> Food {
        Food(id: id, name: name, species: species)
    }
}
