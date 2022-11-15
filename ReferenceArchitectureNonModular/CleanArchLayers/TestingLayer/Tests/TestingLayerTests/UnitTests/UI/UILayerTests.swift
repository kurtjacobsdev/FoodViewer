//
//  UILayerTests.swift
//
//
//  Created by Kurt Jacobs on 2022/11/09.
//

import Combine
@testable import DataLayer
@testable import DomainLayer
import Mocker
@testable import TestingLayer
@testable import UILayer
import XCTest

final class UILayerTests: XCTestCase {
    private var mocker: MockerHelper = .init()

    override func setUpWithError() throws {
        mocker.start()
        try? mocker.register(url: "http://localhost:8080/foods", json: "foods", statusCode: 200)
        for index in 1 ..< 40 {
            try? mocker.register(url: "http://localhost:8080/foods/details/\(index)", json: "\(index)", statusCode: 200)
        }
    }

    override func tearDownWithError() throws {}

    func testFoodsDetailViewModel() async throws {
        // Arrange
        class ViewModelDepedenciesTest: FoodDetailViewModelDependencies {
            var foodDetailUseCase: FoodDetailUseCase

            init(foodDetailUseCase: FoodDetailUseCase) {
                self.foodDetailUseCase = foodDetailUseCase
            }
        }

        let expectation = XCTestExpectation(description: "Refresh ViewModel Getting FoodDetail")

        var cancelBag: Set<AnyCancellable> = []
        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsDetailRepository = VaporFoodsDetailRepository(service: service)
        let provider: FoodsDetailProvider = VaporFoodsDetailProvider(repository: repository)
        let useCase: FoodDetailUseCase = FoodDetailInteractor(foodDetailProvider: provider)
        let dependencies = ViewModelDepedenciesTest(foodDetailUseCase: useCase)
        let viewModel = FoodDetailViewModel(dependencies: dependencies, identifier: "5")

        viewModel.$foodDetail.dropFirst().sink { foodDetail in
            // Assert
            XCTAssertEqual(foodDetail?.name, "beet")
            XCTAssertEqual(foodDetail?.species, "Cynara scolymus")
            XCTAssertEqual(foodDetail?.soilImpact, "light feeder")
            XCTAssertEqual(foodDetail?.cultivationCategory, "vegetable")
            expectation.fulfill()
        }.store(in: &cancelBag)

        // Act
        try await viewModel.refresh()

        wait(for: [expectation], timeout: 1)
    }

    func testFoodsListingViewModel() async throws {
        // Arrange
        class ViewModelDepedenciesTest: FoodListingViewModelDependencies {
            var foodListingUseCase: FoodListingUseCase

            init(foodListingUseCase: FoodListingUseCase) {
                self.foodListingUseCase = foodListingUseCase
            }
        }

        let expectation = XCTestExpectation(description: "Refresh ViewModel Getting All Foods")

        var cancelBag: Set<AnyCancellable> = []
        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsRepository = VaporFoodsRepository(service: service)
        let provider: FoodsProvider = VaporFoodsProvider(repository: repository)
        let useCase: FoodListingUseCase = FoodListingInteractor(foodsProvider: provider)
        let dependencies = ViewModelDepedenciesTest(foodListingUseCase: useCase)
        let viewModel = FoodListingViewModel(dependencies: dependencies)

        viewModel.$foods.dropFirst().sink { foodsConfigurations in
            // Assert
            XCTAssertEqual(foodsConfigurations.count, 39)
            expectation.fulfill()
        }.store(in: &cancelBag)

        // Act
        try await viewModel.refresh()
        viewModel.filter(filters: [])

        wait(for: [expectation], timeout: 1)
    }

    func testFoodsListingViewModelWithFilter() async throws {
        // Arrange
        class ViewModelDepedenciesTest: FoodListingViewModelDependencies {
            var foodListingUseCase: FoodListingUseCase

            init(foodListingUseCase: FoodListingUseCase) {
                self.foodListingUseCase = foodListingUseCase
            }
        }

        let expectation = XCTestExpectation(description: "Refresh ViewModel Getting All Foods")

        var cancelBag: Set<AnyCancellable> = []
        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsRepository = VaporFoodsRepository(service: service)
        let provider: FoodsProvider = VaporFoodsProvider(repository: repository)
        let useCase: FoodListingUseCase = FoodListingInteractor(foodsProvider: provider)
        let dependencies = ViewModelDepedenciesTest(foodListingUseCase: useCase)
        let viewModel = FoodListingViewModel(dependencies: dependencies)

        viewModel.$foods.dropFirst().sink { foodsConfigurations in
            // Assert
            XCTAssertEqual(foodsConfigurations.count, 2)
            expectation.fulfill()
        }.store(in: &cancelBag)

        // Act
        try await viewModel.refresh()
        viewModel.filter(filters: [.species("Lactuca sativa")])

        wait(for: [expectation], timeout: 1)
    }
}
