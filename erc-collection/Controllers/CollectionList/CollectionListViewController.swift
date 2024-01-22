//
//  CollectionListViewController.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Combine
import UIKit

protocol CollectionListView: BaseView {
    var onGoToDetail: ((NFT) -> Void)? { get set }
}

class CollectionListViewController: UIViewController, CollectionListView, HudPresentable, AlertPresentable {
    // MARK: - 📌 Constants

    // MARK: - 🔶 Properties

    let viewModel: CollectionListViewModel

    var onGoToDetail: ((NFT) -> Void)?

    var cancellables = Set<AnyCancellable>()

    // MARK: - 🧩 Subviews

    @IBOutlet var collectionView: UICollectionView!

    // MARK: - 🔨 Initialization

    init(viewModel: CollectionListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 🖼 View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeViewModelOutputs()
        viewModel.input.onLoad.send(())
    }
}

// MARK: - 🏗 UI

private extension CollectionListViewController {
    func setupUI() {
        collectionView.register(UINib(nibName: "\(CollectionListCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(CollectionListCell.self)")
    }

    func observeViewModelOutputs() {
        viewModel.output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.showHUD()
                } else {
                    self.hideHUD()
                }
            }
            .store(in: &cancellables)

        viewModel.output.loadingError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                self.showError(error)
            }
            .store(in: &cancellables)

        viewModel.output.reloadDataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.output.appendDataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                self.collectionView.insertItems(at: items)
            }
            .store(in: &cancellables)

        viewModel.output.updateETHValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                if let value = value {
                    title = "\(value) ETH"
                } else {
                    title = "List"
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - 👆 Actions

private extension CollectionListViewController {}

// MARK: - 🔒 Private Methods

private extension CollectionListViewController {}

// MARK: - 🚌 Public Methods

extension CollectionListViewController {}

// MARK: - UICollectionViewDelegate

extension CollectionListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onGoToDetail?(viewModel.dataSource[indexPath.row])
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionListCell.self)", for: indexPath) as! CollectionListCell
        cell.configure(data: viewModel.dataSource[indexPath.row])

        let lastElement = viewModel.dataSource.count - 1
        if indexPath.row == lastElement {
            viewModel.input.nextPage.send(())
        }
        return cell
    }
}
