//
//  AppDependencies.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/05.
//

import DataLayer
import DomainLayer
import Foundation
import UILayer

public class AppDependencies: AppCoordinatorDependencies {
    var service: AppService = VaporAppService(session: URLSession.shared)
    lazy var foodsRepository: FoodsRepository = VaporFoodsRepository(service: service)
    lazy var foodsDetailRepository: FoodsDetailRepository = VaporFoodsDetailRepository(service: service)
    lazy var foodsProvider: FoodsProvider = VaporFoodsProvider(repository: foodsRepository)
    lazy var foodsDetailProvider: FoodsDetailProvider = VaporFoodsDetailProvider(repository: foodsDetailRepository)
    public lazy var foodListingUseCase: FoodListingUseCase = FoodListingInteractor(foodsProvider: foodsProvider)
    public lazy var foodDetailUseCase: FoodDetailUseCase = FoodDetailInteractor(foodDetailProvider: foodsDetailProvider)
}
