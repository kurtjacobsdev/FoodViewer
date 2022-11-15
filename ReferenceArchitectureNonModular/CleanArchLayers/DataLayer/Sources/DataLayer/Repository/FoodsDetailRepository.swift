//
//  FoodsDetailRepository.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/05.
//

import Foundation

public protocol FoodsDetailRepository {
    func get<Entity: AppRepositoryEntity>(identifier: String) async throws -> Entity?
}

public class VaporFoodsDetailRepository: FoodsDetailRepository {
    private var service: AppService

    public init(service: AppService) {
        self.service = service
    }

    public func get<Entity>(identifier: String) async throws -> Entity? where Entity: AppRepositoryEntity {
        let response = try await service.perform(request: SingleFoodsDetailRequest(identifier: identifier))
        let item = try? JSONDecoder().decode(Entity.self, from: response)
        return item
    }
}
