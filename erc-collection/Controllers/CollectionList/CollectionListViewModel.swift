//
//  CollectionListViewModel.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Combine
import UIKit

class CollectionListViewModel {
    struct Input {
        let onLoad: PassthroughSubject<Void, Never>
        let nextPage: PassthroughSubject<Void, Never>
    }

    struct Output {
        let isLoading: CurrentValueSubject<Bool, Never>
        let loadingError: PassthroughSubject<Error, Never>
        let reloadDataSource: PassthroughSubject<Void, Never>
        let appendDataSource: PassthroughSubject<[IndexPath], Never>
        let updateETHValue: PassthroughSubject<Decimal?, Never>
    }

    let input: Input

    let output: Output

    private let apiServcie: APIService

    private(set) var dataSource: [NFT] = []

    var pageKey: String?

    var cancellables = Set<AnyCancellable>()

    // MARK: - Input

    private let onLoadSubject = PassthroughSubject<Void, Never>()
    private let nextPageSubject = PassthroughSubject<Void, Never>()

    // MARK: Output

    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let loadingErrorSubject = PassthroughSubject<Error, Never>()

    private let reloadDataSourceSubject = PassthroughSubject<Void, Never>()
    private let appendDataSourceSubject = PassthroughSubject<[IndexPath], Never>()
    private let updateETHValueSubject = PassthroughSubject<Decimal?, Never>()

    init(apiServcie: APIService) {
        self.apiServcie = apiServcie

        input = Input(onLoad: onLoadSubject, nextPage: nextPageSubject)

        output = Output(isLoading: isLoadingSubject, loadingError: loadingErrorSubject, reloadDataSource: reloadDataSourceSubject, appendDataSource: appendDataSourceSubject, updateETHValue: updateETHValueSubject)

        input.onLoad.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchCollectionList(reload: true)
            self.fetchEthereumBalance()
        }
        .store(in: &cancellables)

        input.nextPage.sink { [weak self] _ in
            guard let self = self else { return }
            if nextPageExist() {
                self.fetchCollectionList(reload: false)
            }
        }
        .store(in: &cancellables)
    }

    func nextPageExist() -> Bool {
        return pageKey != nil
    }

    func appendIndexPath(oldCount: Int, newCount: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []

        for index in oldCount ..< newCount {
            indexPaths.append(IndexPath(item: index, section: 0))
        }
        return indexPaths
    }
}

// MARK: - Private

private extension CollectionListViewModel {
    func fetchCollectionList(reload: Bool) {
        output.isLoading.send(true)

        apiServcie.fetchNFT(apikey: currentAppConfig.apiKey, owner: currentAppConfig.ethereumAddress, pageSize: 20, pageKey: reload ? nil : pageKey) { [weak self] result in
            guard let self = self else { return }
            self.output.isLoading.send(false)
            switch result {
            case let .success(response):
                self.pageKey = response.pageKey
                if reload {
                    self.dataSource = response.ownedNfts
                    self.output.reloadDataSource.send(())
                } else {
                    let oldCount = self.dataSource.count
                    self.dataSource.append(contentsOf: response.ownedNfts)
                    self.output.appendDataSource.send(self.appendIndexPath(oldCount: oldCount,
                                                                           newCount: self.dataSource.count))
                }
            case let .failure(error):
                self.output.loadingError.send(error)
            }
        }
    }

    func fetchEthereumBalance() {
        apiServcie.fetchEthereumBalance(apikey: currentAppConfig.apiKey, ethereumAddress: currentAppConfig.ethereumAddress) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.updateETHValueSubject.send(Calculator.convertWeiToEth(weiHex: response.result))
            case let .failure(error):
                print(error.description)
            }
        }
    }
}
