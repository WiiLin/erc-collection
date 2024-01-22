//
//  RootCoordinator.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import UIKit

class RootCoordinator: Coordinator {
    private var navigationController: UINavigationController

    lazy var listCoordinator = CollectionListCoordinator(navigationController: navigationController)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        listCoordinator.start()
    }
}
