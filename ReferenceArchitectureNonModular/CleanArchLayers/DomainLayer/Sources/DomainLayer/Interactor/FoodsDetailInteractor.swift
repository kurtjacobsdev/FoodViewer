//
//  FoodsDetailInteractor.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/06.
//

import Foundation

public class FoodDetailInteractor: FoodDetailUseCase {
    private var foodDetailProvider: FoodsDetailProvider

    public init(foodDetailProvider: FoodsDetailProvider) {
        self.foodDetailProvider = foodDetailProvider
    }

    public func refresh(identifier: String) async throws -> FoodDetail? {
        return try await foodDetailProvider.get(id: identifier)
    }
}
