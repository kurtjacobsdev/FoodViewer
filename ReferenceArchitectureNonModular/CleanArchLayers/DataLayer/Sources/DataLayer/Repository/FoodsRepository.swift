//
//  AnimalRepository.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import Foundation

public protocol FoodsRepository {
    func get<Entity: AppRepositoryEntity>() async throws -> [Entity]
}

public class VaporFoodsRepository: FoodsRepository {
    private var service: AppService

    public init(service: AppService) {
        self.service = service
    }

    public func get<Entity: AppRepositoryEntity>() async throws -> [Entity] {
        let response = try await service.perform(request: AllFoodsRequest())
        let items = try JSONDecoder().decode([Entity].self, from: response)
        return items
    }
}
