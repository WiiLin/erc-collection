//
//  CollectionListCoordinator.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Combine
import UIKit

class CollectionListCoordinator: Coordinator {
    private let navigationController: UINavigationController

    private var cancellables = Set<AnyCancellable>()

    var detailCoordinator: CollectionDetailCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let listView = makeCollectionListView()
        setupFlows(of: listView)
        navigationController.push(listView, animated: false)
    }

    func navigateToDetail(data: NFT) {
        detailCoordinator = CollectionDetailCoordinator(nft: data, navigationController: navigationController)
        detailCoordinator?.start()
    }
}

// MARK: - Private

private extension CollectionListCoordinator {
    func makeCollectionListView() -> CollectionListView {
        let listView: CollectionListView = CollectionListViewController(viewModel: CollectionListViewModel(apiServcie: APIHandler.shared))
        return listView
    }

    func setupFlows(of collectionListView: CollectionListView) {
        collectionListView.onGoToDetail = { [weak self] nft in
            guard let self = self else { return }
            self.navigateToDetail(data: nft)
        }
    }
}
