//
//  FoodDetailViewModel.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/06.
//

import DomainLayer
import Foundation

public protocol FoodDetailViewModelDependencies {
    var foodDetailUseCase: FoodDetailUseCase { get set }
}

public class FoodDetailViewModel {
    @Published var foodDetail: FoodDetailConfiguration?
    @Published var isLoading: Bool = false
    private var dependencies: FoodDetailViewModelDependencies
    private var identifier: String

    init(dependencies: FoodDetailViewModelDependencies, identifier: String) {
        self.dependencies = dependencies
        self.identifier = identifier
    }

    func refresh() async throws {
        isLoading = true
        foodDetail = try await dependencies.foodDetailUseCase.refresh(identifier: identifier)?.configuration()
        isLoading = false
    }
}
