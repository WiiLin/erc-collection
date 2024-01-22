//
//  CollectionListCell.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import UIKit

class CollectionListCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var nftImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1

        nftImageView.layer.borderColor = UIColor.black.cgColor
        nftImageView.layer.borderWidth = 1
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.cancelDownloadTask()
    }

    func configure(data: NFT) {
        nameLabel.text = data.metadata.name
        nftImageView.setImage(url: data.metadata.image)
    }
}

class CollectionListLayout: UICollectionViewFlowLayout {
    let column: CGFloat = 2

    private func configure() {
        scrollDirection = .vertical
        minimumInteritemSpacing = 20
        minimumLineSpacing = 20
        sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        itemSize = itemSize()
    }

    func itemSize() -> CGSize {
        let totalPading: CGFloat = minimumInteritemSpacing * (column - 1)
        var width: CGFloat = UIScreen.main.bounds.width
        width -= totalPading
        width -= sectionInset.left
        width -= sectionInset.right
        width -= 1
        width /= column
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }

    override func prepare() {
        super.prepare()
        configure()
    }
}
