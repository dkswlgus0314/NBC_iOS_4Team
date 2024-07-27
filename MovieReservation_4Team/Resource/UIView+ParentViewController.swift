//
//  UIView+ParentViewController.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/25/24.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
