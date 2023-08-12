# MemorySavingTabBarController
UITabBarController doesn't have to worry about the memory anymore! 📦

## Setup

Add the following to `Package.swift`:

```swift
.package(url: "https://github.com/stateman92/MemorySavingTabBarController", exact: .init(0, 0, 1))
```

[Or add the package in Xcode.](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

## Usage

Change the default implementation:

```swift
extension Presenter {
    private func getTabBarController() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            firstViewController,
            secondViewController,
            thirdViewController
        ]
        tabBarController.delegate = self
        return tabBarController
    }
}

extension Presenter: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // ...
    }
}
```

To this:

```swift
extension Presenter {
    private func getTabBarController() -> UIViewController {
        let tabBarController = MemorySavingTabBarController(viewControllers: [
            .init(isSelected: true) { firstViewController },
            .init { secondViewController },
            .init { thirdViewController }
        ])
        tabBarController.set(delegate: self)
        return tabBarController
    }
}

extension Presenter: MemorySavingTabBarControllerDelegate {
    func didAttach(controller: MemorySavingTabBarController, viewController: UIViewController, at index: Int) {
        // ...
    }
}
```

Both code snippets do the same: configure a `TabBarController` with three screens, and set the delegate.
For details see the Example app.
