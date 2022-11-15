//
//  AnimalProvider.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import DomainLayer
import Foundation

public class VaporFoodsProvider: FoodsProvider {
    private var repository: FoodsRepository

    public init(repository: FoodsRepository) {
        self.repository = repository
    }

    public func get() async throws -> [Food] {
        let dtos: [FoodDTO] = try await repository.get()
        let entities = dtos.map { $0.entity() }
        return entities
    }
}
