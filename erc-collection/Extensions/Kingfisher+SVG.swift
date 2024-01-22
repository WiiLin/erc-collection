//
//  Kingfisher+SVG.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Kingfisher
import SVGKit

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.wii.SVGImgProcessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case let .image(image):
            return image
        case let .data(data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}
