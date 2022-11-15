//
//  DataLayerTests.swift
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

final class DataLayerTests: XCTestCase {
    private var mocker: MockerHelper = .init()

    override func setUpWithError() throws {
        mocker.start()
        try? mocker.register(url: "http://localhost:8080/foods", json: "foods", statusCode: 200)
        for index in 1 ..< 40 {
            try? mocker.register(url: "http://localhost:8080/foods/details/\(index)", json: "\(index)", statusCode: 200)
        }
    }

    override func tearDownWithError() throws {}

    func testFoodsProvider() async throws {
        // Arrange
        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsRepository = VaporFoodsRepository(service: service)
        let provider: FoodsProvider = VaporFoodsProvider(repository: repository)

        // Act
        let foods = try await provider.get()

        // Assert
        XCTAssertEqual(foods.count, 39)
    }

    func testFoodsDetailsProvider() async throws {
        // Arrange
        let service: AppService = VaporAppService(session: mocker.urlSession)
        let repository: FoodsDetailRepository = VaporFoodsDetailRepository(service: service)
        let provider: FoodsDetailProvider = VaporFoodsDetailProvider(repository: repository)

        // Act
        let artichoke = try await provider.get(id: "1")
        let turnip = try await provider.get(id: "39")

        // Assert
        assertFoodDetail(artichoke, name: "artichoke",
                         species: "Cynara scolymus",
                         cultivationCategory: "vegetable",
                         soilImpact: "heavy feeder")
        assertFoodDetail(turnip, name: "turnip",
                         species: "Brassica rapa",
                         cultivationCategory: "vegetable",
                         soilImpact: "heavy feeder")
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
