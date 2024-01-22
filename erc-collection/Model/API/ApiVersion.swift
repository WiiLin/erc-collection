//
//  ApiVersion.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

enum APIVersion {
    case v1
    case v2

    var versionString: String {
        switch self {
        case .v1:
            return "v1"
        case .v2:
            return "v2"
        }
    }
}
