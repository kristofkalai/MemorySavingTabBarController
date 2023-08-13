//
//  UIViewController+Extensions.swift
//  Example
//
//  Created by Kristóf Kálai on 2023. 08. 13..
//

import UIKit

extension UIViewController {
    func addViewController(_ childViewController: UIViewController, toView view: UIView? = nil) {
        let view: UIView = view ?? self.view
        childViewController.removeFromParent()
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func removeViewController(_ childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.didMove(toParent: nil)
        childViewController.view.removeFromSuperview()
    }
}
