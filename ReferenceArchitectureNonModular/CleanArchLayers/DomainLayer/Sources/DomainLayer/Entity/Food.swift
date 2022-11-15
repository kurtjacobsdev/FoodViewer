//
//  Animal.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import Foundation

public struct Food {
    public var id: String
    public var name: String
    public var species: String

    public init(id: String, name: String, species: String) {
        self.id = id
        self.name = name
        self.species = species
    }
}
