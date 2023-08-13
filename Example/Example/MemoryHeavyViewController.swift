//
//  MemoryHeavyViewController.swift
//  Example
//
//  Created by Kristóf Kálai on 2023. 08. 13..
//

import UIKit
import MemorySavingTabBarController

final class MemoryHeavyViewController: UIViewController {
    private let color: UIColor
    private let allocation = Memory.allocate(memory: .megaBytes(10))

    init(color _color: UIColor, tabBar: UITabBarItem) {
        color = _color.withAlphaComponent(0.33)
        print("INIT CALLED: \(color)")
        super.init(nibName: nil, bundle: nil)
        tabBarItem = tabBar
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit {
        print("DEINIT CALLED: \(color)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
    }
}

extension MemoryHeavyViewController: MemorySavingTabViewController {
    func provideTabBarItem() -> UITabBarItem {
        tabBarItem
    }
}
