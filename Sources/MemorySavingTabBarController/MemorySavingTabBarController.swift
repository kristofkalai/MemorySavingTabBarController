//
//  MemorySavingTabBarController.swift
//
//
//  Created by Kristóf Kálai on 2023. 08. 12..
//

import UIKit

public final class MemorySavingTabBarController: UITabBarController {
    public final class Holder {
        fileprivate let isSelected: Bool
        fileprivate let viewController: () -> MemorySavingTabViewController

        public init(isSelected: Bool = false, viewController: @escaping () -> MemorySavingTabViewController) {
            self.isSelected = isSelected
            self.viewController = viewController
        }
    }

    public override var delegate: UITabBarControllerDelegate? {
        didSet {
            if loaded {
                assertionFailure("The delegate shouldn't be set!")
            }
        }
    }

    private var loaded = false
    private weak var _delegate: MemorySavingTabBarControllerDelegate?
    private var holders: [MemorySavingTabViewControllerHolder] {
        viewControllers?.compactMap { $0 as? MemorySavingTabViewControllerHolder } ?? .init()
    }

    public init(viewControllers: [Holder], loadAllOnInit: Bool = true, delegate: MemorySavingTabBarControllerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        load(holders: viewControllers, loadAllOnInit: loadAllOnInit, _delegate: delegate)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MemorySavingTabBarController {
    private func load(holders: [Holder], loadAllOnInit: Bool, _delegate: MemorySavingTabBarControllerDelegate?) {
        delegate = self
        loaded = true
        set(delegate: _delegate)
        viewControllers = holders.map {
            MemorySavingTabViewControllerHolder(viewController: $0.viewController).configure { [holder = $0] in
                if loadAllOnInit {
                    $0.attachChild()
                    if !holder.isSelected {
                        $0.detachChild()
                    }
                } else {
                    if holder.isSelected {
                        $0.attachChild()
                    }
                }
            }
        }
        assert(holders.filter { $0.isSelected }.count == 1, "Exactly one viewController should be marked as selected!")
        holders.firstIndex { $0.isSelected }.map { selectedIndex = $0 }
    }
}

extension MemorySavingTabBarController {
    public func set(delegate: MemorySavingTabBarControllerDelegate?) {
        self._delegate = delegate
    }
}

extension MemorySavingTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard viewController !== selectedViewController else {
            return false
        }

        guard let selectedViewController = selectedViewController as? MemorySavingTabViewControllerHolder else {
            assertionFailure("The selectedViewController should be a holder!")
            return true
        }

        guard let selectedViewControllerIndex = holders.firstIndex(of: selectedViewController) else {
            assertionFailure("The selectedViewController should be stored in the viewControllers array!")
            return true
        }

        guard let attachedViewController = selectedViewController.attachedViewController else {
            assertionFailure("The selectedViewController should be attached!")
            return true
        }

        _delegate?.willDetach?(controller: self, viewController: attachedViewController, at: selectedViewControllerIndex)

        return true
    }

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let selectedViewController = viewController as? MemorySavingTabViewControllerHolder else {
            assertionFailure("The selectedViewController should be a holder!")
            return
        }

        let attachedHolders = holders.filter { $0.isAttached }
        assert(attachedHolders.count == 1, "Only one viewController should be attached!")

        holders.forEach { $0.detachChild() }
        guard let previouslySelectedViewControllerIndex = attachedHolders.first.flatMap({ holders.firstIndex(of: $0) }) else {
            assertionFailure("The previously selectedViewController should be stored in the viewControllers array!")
            return
        }

        _delegate?.didDetach?(controller: self, at: previouslySelectedViewControllerIndex)

        guard let selectedViewControllerIndex = holders.firstIndex(of: selectedViewController) else {
            assertionFailure("The selectedViewController should be stored in the viewControllers array!")
            return
        }
        _delegate?.willAttach?(controller: self, at: selectedViewControllerIndex)
        selectedViewController.attachChild()

        guard let attachedViewController = selectedViewController.attachedViewController else {
            assertionFailure("The selectedViewController should be attached!")
            return
        }
        _delegate?.didAttach?(controller: self, viewController: attachedViewController, at: selectedViewControllerIndex)
    }
}
