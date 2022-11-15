//
//  SnapshotTests.swift
//
//
//  Created by Kurt Jacobs on 2022/11/15.
//

import Combine
@testable import DataLayer
@testable import DomainLayer
import Mocker
import SnapshotTesting
@testable import TestingLayer
@testable import UILayer
import XCTest

final class SnapshotTests: XCTestCase {
    private var mocker: MockerHelper = .init()

    override func setUpWithError() throws {
        isRecording = false
        mocker.start()
        try? mocker.register(url: "http://localhost:8080/foods", json: "foods", statusCode: 200)
        for index in 1 ..< 40 {
            try? mocker.register(url: "http://localhost:8080/foods/details/\(index)", json: "\(index)", statusCode: 200)
        }
    }

    func testFoodDetailViewController() async throws {
        // Arrange
        class ViewModelDepedenciesTest: FoodDetailViewModelDependencies {
            var foodDetailUseCase: FoodDetailUseCase

            init(foodDetailUseCase: FoodDetailUseCase) {
                self.foodDetailUseCase = foodDetailUseCase
            }
        }

        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsDetailRepository = VaporFoodsDetailRepository(service: service)
        let provider: FoodsDetailProvider = VaporFoodsDetailProvider(repository: repository)
        let useCase: FoodDetailUseCase = FoodDetailInteractor(foodDetailProvider: provider)
        let dependencies = ViewModelDepedenciesTest(foodDetailUseCase: useCase)
        let viewModel = FoodDetailViewModel(dependencies: dependencies, identifier: "5")
        let viewController = await FoodDetailViewController(viewModel: viewModel)
        let navigationController = await UINavigationController(rootViewController: viewController)

        // Act
        await viewController.viewDidLoad()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert
        await MainActor.run {
            assertSnapshot(matching: navigationController, as: .image)
        }
    }

    func testFoodsListingViewController() async throws {
        // Arrange
        class ViewModelDepedenciesTest: FoodListingViewModelDependencies {
            var foodListingUseCase: FoodListingUseCase

            init(foodListingUseCase: FoodListingUseCase) {
                self.foodListingUseCase = foodListingUseCase
            }
        }

        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsRepository = VaporFoodsRepository(service: service)
        let provider: FoodsProvider = VaporFoodsProvider(repository: repository)
        let useCase: FoodListingUseCase = FoodListingInteractor(foodsProvider: provider)
        let dependencies = ViewModelDepedenciesTest(foodListingUseCase: useCase)
        let viewModel = FoodListingViewModel(dependencies: dependencies)
        let viewController = await FoodListingViewController(viewModel: viewModel)
        let navigationController = await UINavigationController(rootViewController: viewController)

        // Act
        await viewController.viewDidLoad()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert
        await MainActor.run {
            assertSnapshot(matching: navigationController, as: .image)
        }
    }
}
