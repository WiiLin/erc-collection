//
//  CollectionDetailViewController.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import UIKit

protocol CollectionDetailView: BaseView {
    var onFlowComplete: SimpleOutput? { get set }
    var showPermalink: ((NFT) -> Void)? { get set }
}

class CollectionDetailViewController: UIViewController, CollectionDetailView {
    // MARK: - 📌 Constants

    // MARK: - 🔶 Properties

    let viewModel: CollectionDetailViewModel

    var onFlowComplete: SimpleOutput?
    var showPermalink: ((NFT) -> Void)?

    // MARK: - 🧩 Subviews

    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var nftImageView: UIImageView!

    @IBOutlet var descriptionLabel: UILabel!

    // MARK: - 🔨 Initialization

    init(viewModel: CollectionDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        nftImageView.cancelDownloadTask()
    }

    // MARK: - 🖼 View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeViewModelOutputs()
    }
}

// MARK: - 🏗 UI

private extension CollectionDetailViewController {
    func setupUI() {
        title = viewModel.nft.contractMetadata.name

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left.circle.fill"), style: .plain, target: self, action: #selector(onClickBack))

        nameLabel.text = viewModel.nft.metadata.name
        nftImageView.setImage(url: viewModel.nft.metadata.image)
        descriptionLabel.text = viewModel.nft.description
    }

    func observeViewModelOutputs() {}
}

// MARK: - 👆 Actions

private extension CollectionDetailViewController {
    @objc func onClickBack() {
        onFlowComplete?()
    }

    @IBAction func onClickPermalink(_ sender: Any) {
        showPermalink?(viewModel.nft)
    }
}

// MARK: - 🔒 Private Methods

private extension CollectionDetailViewController {}

// MARK: - 🚌 Public Methods

extension CollectionDetailViewController {}
