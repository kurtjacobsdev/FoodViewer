//
//  AnimalDetailProvider.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import DomainLayer
import Foundation

public class VaporFoodsDetailProvider: FoodsDetailProvider {
    private var repository: FoodsDetailRepository

    public init(repository: FoodsDetailRepository) {
        self.repository = repository
    }

    public func get(id: String) async throws -> FoodDetail? {
        let dto: FoodDetailDTO? = try await repository.get(identifier: id)
        return dto?.entity()
    }
}
