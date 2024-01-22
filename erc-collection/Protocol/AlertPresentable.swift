//
//  AlertPresentable.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import UIKit

protocol AlertPresentable: UIViewController {
    func showError(_ error: Error, handler: SimpleOutput?)
}

extension AlertPresentable where Self: UIViewController {
    func showError(_ error: Error, handler: SimpleOutput? = nil) {
        UIAlertController.showError(error, controller: self, handler: handler)
    }
}

extension UIAlertController {
    class func showError(_ error: Error, controller: UIViewController, handler: SimpleOutput? = nil) {
        let errorMessage: String = {
            if let error = error as? APIError {
                return error.description
            } else {
                return (error as NSError).localizedDescription
            }
        }()
        Self.showError(errorMessage, controller: controller, handler: handler)
    }

    class func showError(_ error: String, controller: UIViewController, handler: SimpleOutput? = nil) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
            handler?()
        }
        alert.addAction(okAction)

        controller.present(alert, animated: true, completion: nil)
    }
}
