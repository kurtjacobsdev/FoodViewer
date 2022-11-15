//
//  FoodListingInteractor.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/05.
//

import Foundation

public class FoodListingInteractor: FoodListingUseCase {
    private var foodsProvider: FoodsProvider
    private var foods: [Food] = []

    public init(foodsProvider: FoodsProvider) {
        self.foodsProvider = foodsProvider
    }

    public func refresh() async throws {
        foods = try await foodsProvider.get()
    }

    public func fetch(with filters: [FoodListingFilter]) -> [Food] {
        var foods = self.foods
        for filter in filters {
            foods = apply(filter: filter, to: foods)
        }
        return foods
    }

    private func apply(filter: FoodListingFilter, to foods: [Food]) -> [Food] {
        switch filter {
        case let .species(name):
            return foods.filter { $0.species.contains(name) }
        }
    }
}
