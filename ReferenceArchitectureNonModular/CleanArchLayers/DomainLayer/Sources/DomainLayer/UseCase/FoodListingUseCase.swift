//
//  FoodListingUseCase.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/05.
//

import Foundation

public enum FoodListingFilter {
    case species(_ name: String)
}

public protocol FoodListingUseCase {
    func refresh() async throws
    func fetch(with filters: [FoodListingFilter]) -> [Food]
}
