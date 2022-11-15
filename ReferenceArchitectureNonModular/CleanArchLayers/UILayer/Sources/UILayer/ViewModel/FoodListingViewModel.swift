//
//  ViewModel.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/05.
//

import Combine
import DomainLayer
import Foundation

public protocol FoodListingViewModelDependencies {
    var foodListingUseCase: FoodListingUseCase { get set }
}

public class FoodListingViewModel {
    @Published var foods: [FoodListingConfiguration] = []
    @Published var isLoading: Bool = false

    private var dependencies: FoodListingViewModelDependencies

    init(dependencies: FoodListingViewModelDependencies) {
        self.dependencies = dependencies
    }

    func refresh() async throws {
        isLoading = true
        try await dependencies.foodListingUseCase.refresh()
        isLoading = false
    }

    func filter(filters: [FoodListingFilter]) {
        foods = dependencies.foodListingUseCase.fetch(with: filters).map { $0.configuration() }
    }
}
