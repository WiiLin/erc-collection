//
//  UIImageView+Kingfisher.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Kingfisher

extension UIImageView {
    func setImage(url: String?, placeholder: UIImage? = nil, complation: SimpleOutput? = nil) {
        guard let url = URL(string: url ?? "") else {
            image = placeholder
            return
        }

        kf.setImage(with: url, placeholder: placeholder, options: url.isSVGUrl ? [.processor(SVGImgProcessor())] : nil) { result in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
            complation?()
        }
    }

    func cancelDownloadTask() {
        kf.cancelDownloadTask()
    }
}
