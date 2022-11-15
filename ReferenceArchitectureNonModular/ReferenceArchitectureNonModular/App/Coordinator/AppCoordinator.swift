//
//  AppCoordinator.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/05.
//

import UIKit
import UILayer

protocol AppCoordinatorDependencies: FoodListingCoordinatorDependencies {}

class AppCoordinator {
    private var dependencies: AppCoordinatorDependencies

    // Coordinators
    public private(set) var foodListingCoordinator: FoodListingCoordinator!

    init(dependencies: AppCoordinatorDependencies) {
        self.dependencies = dependencies
    }

    func start() {
        foodListingCoordinator = FoodListingCoordinator(dependencies: dependencies)
        foodListingCoordinator.start()
    }
}
