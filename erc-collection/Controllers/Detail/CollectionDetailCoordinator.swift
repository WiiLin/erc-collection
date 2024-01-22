//
//  CollectionDetailCoordinator.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Combine
import UIKit

class CollectionDetailCoordinator: Coordinator {
    private var navigationController: UINavigationController

    private var cancellables = Set<AnyCancellable>()

    private let nft: NFT

    init(nft: NFT, navigationController: UINavigationController) {
        self.nft = nft
        self.navigationController = navigationController
    }

    func start() {
        let detailView = makeCollectionDetailView()

        setupFlows(of: detailView)

        navigationController.push(detailView, animated: true)
    }
}

// MARK: - Private

private extension CollectionDetailCoordinator {
    func makeCollectionDetailView() -> CollectionDetailView {
        let detailView: CollectionDetailView = CollectionDetailViewController(viewModel: CollectionDetailViewModel(nft: nft))

        return detailView
    }

    func setupFlows(of collectionDetailView: CollectionDetailView) {
        collectionDetailView.onFlowComplete = { [weak self] in
            guard let self = self else { return }

            self.navigationController.popViewController(animated: true)
        }

        collectionDetailView.showPermalink = { nft in
            guard let url = nft.permalink else { return }
            UIApplication.shared.open(url)
        }
    }
}
