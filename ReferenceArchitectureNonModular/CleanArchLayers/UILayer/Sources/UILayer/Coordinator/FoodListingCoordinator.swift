//
//  FoodListingCoordinator.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/05.
//

import UIKit

public protocol FoodListingCoordinatorDependencies:
    FoodListingViewModelDependencies,
    FoodDetailViewModelDependencies {}

public class FoodListingCoordinator {
    private var dependencies: FoodListingCoordinatorDependencies
    public private(set) var navigationController = UINavigationController()
    private var foodListingViewController: FoodListingViewController?
    private var foodDetailViewController: FoodListingViewController?

    public init(dependencies: FoodListingCoordinatorDependencies) {
        self.dependencies = dependencies
    }

    public func start() {
        let viewModel = FoodListingViewModel(dependencies: dependencies)
        let mainViewController = FoodListingViewController(viewModel: viewModel)
        mainViewController.delegate = self
        foodListingViewController = mainViewController
        navigationController = UINavigationController(rootViewController: mainViewController)
    }
}

extension FoodListingCoordinator: FoodListingViewControllerDelegate {
    public func didSelect(_: FoodListingViewController, foodItem: FoodListingConfiguration?) {
        guard let foodItem = foodItem else { return }
        let viewModel = FoodDetailViewModel(dependencies: dependencies,
                                            identifier: foodItem.id)
        let viewController = FoodDetailViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .pageSheet
        self.navigationController.present(navigationController, animated: true)
    }
}
