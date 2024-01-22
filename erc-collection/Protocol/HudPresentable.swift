//
//  HudPresentable.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation
import SVProgressHUD

protocol HudPresentable {
    func showHUD()
    func hideHUD()
}

extension HudPresentable {
    func showHUD() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }

    func hideHUD() {
        SVProgressHUD.dismiss()
    }
}
