//
//  AppConfig.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

#if DEBUG
    let currentAppConfig: AppConfig = .Develop

#else
    let currentAppConfig: AppConfig = .Production
#endif

enum AppConfig {
    case Develop

    case Production

    var apiKey: String {
        return "UtJJNjvqrmridpLwkBk1Uvo8k0_ypLeJ"
    }

    var ethereumAddress: String {
        return "0x85fD692D2a075908079261F5E351e7fE0267dB02"
    }
}
