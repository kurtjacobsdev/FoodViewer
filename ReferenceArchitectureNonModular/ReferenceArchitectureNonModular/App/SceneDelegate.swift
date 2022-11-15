//
//  SceneDelegate.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import UIKit
import UILayer

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appDependencies: AppDependencies = .init()
    private lazy var listingCoordinator: FoodListingCoordinator = .init(dependencies: appDependencies)
    private lazy var appCoordinator: AppCoordinator = .init(dependencies: appDependencies)

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        appCoordinator.start()
        window?.rootViewController = appCoordinator.foodListingCoordinator.navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_: UIScene) {}

    func sceneDidBecomeActive(_: UIScene) {}

    func sceneWillResignActive(_: UIScene) {}

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {}
}
