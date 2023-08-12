//
//  MemorySavingTabViewControllerHolder.swift
//  
//
//  Created by Kristóf Kálai on 2023. 08. 12..
//

import UIKit

final class MemorySavingTabViewControllerHolder: ViewController {
    private var currentViewController: MemorySavingTabViewController?
    private let viewController: () -> MemorySavingTabViewController

    init(viewController: @escaping () -> MemorySavingTabViewController) {
        self.viewController = viewController
        super.init()
    }
}

extension MemorySavingTabViewControllerHolder {
    var isAttached: Bool {
        attachedViewController != nil
    }

    var attachedViewController: UIViewController? {
        currentViewController
    }

    func attachChild() {
        guard currentViewController == nil else { return }
        currentViewController = viewController().configure {
            addChild($0)
            view.addSubview($0.view)
            $0.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: $0.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: $0.view.trailingAnchor),
                view.topAnchor.constraint(equalTo: $0.view.topAnchor),
                view.bottomAnchor.constraint(equalTo: $0.view.bottomAnchor)
            ])
            $0.didMove(toParent: self)
            tabBarItem = $0.provideTabBarItem()
        }
    }

    func detachChild() {
        currentViewController?.configure {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        currentViewController = nil
    }
}
