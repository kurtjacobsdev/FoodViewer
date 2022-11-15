//
//  DomainLayerTests.swift
//
//
//  Created by Kurt Jacobs on 2022/11/09.
//

@testable import DataLayer
@testable import DomainLayer
import Mocker
@testable import TestingLayer
@testable import UILayer
import XCTest

final class DomainLayerTests: XCTestCase {
    private var mocker: MockerHelper = .init()

    override func setUpWithError() throws {
        mocker.start()
        try? mocker.register(url: "http://localhost:8080/foods", json: "foods", statusCode: 200)
        for index in 1 ..< 40 {
            try? mocker.register(url: "http://localhost:8080/foods/details/\(index)", json: "\(index)", statusCode: 200)
        }
    }

    override func tearDownWithError() throws {}

    func testFoodsDetailUseCase() async throws {
        // Arrange
        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsDetailRepository = VaporFoodsDetailRepository(service: service)
        let provider: FoodsDetailProvider = VaporFoodsDetailProvider(repository: repository)
        let useCase: FoodDetailUseCase = FoodDetailInteractor(foodDetailProvider: provider)

        // Act
        let foodDetail = try await useCase.refresh(identifier: "1")

        // Assert
        assertFoodDetail(foodDetail,
                         name: "artichoke",
                         species: "Cynara scolymus",
                         cultivationCategory: "vegetable",
                         soilImpact: "heavy feeder")
    }

    func testFoodsListingUseCase() async throws {
        // Arrange
        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsRepository = VaporFoodsRepository(service: service)
        let provider: FoodsProvider = VaporFoodsProvider(repository: repository)
        let useCase: FoodListingUseCase = FoodListingInteractor(foodsProvider: provider)

        // Act
        try await useCase.refresh()
        let foods = useCase.fetch(with: [])

        // Assert
        XCTAssertEqual(foods.count, 39)
    }

    func testFoodsListingUseCaseWithSpeciesFilter() async throws {
        // Arrange
        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsRepository = VaporFoodsRepository(service: service)
        let provider: FoodsProvider = VaporFoodsProvider(repository: repository)
        let useCase: FoodListingUseCase = FoodListingInteractor(foodsProvider: provider)

        // Act
        try await useCase.refresh()
        let foods = useCase.fetch(with: [.species("Cynara scolymus")])

        // Assert
        XCTAssertEqual(foods.count, 3)
    }

    // MARK: Helpers

    private func assertFoodDetail(_ foodDetail: FoodDetail?,
                                  name: String,
                                  species: String,
                                  cultivationCategory: String,
                                  soilImpact: String) {
        XCTAssertEqual(foodDetail?.name, name)
        XCTAssertEqual(foodDetail?.species, species)
        XCTAssertEqual(foodDetail?.cultivationCategory, cultivationCategory)
        XCTAssertEqual(foodDetail?.soilImpact, soilImpact)
    }
}
