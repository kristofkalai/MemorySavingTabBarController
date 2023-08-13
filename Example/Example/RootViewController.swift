//
//  RootViewController.swift
//  Example
//
//  Created by Kristóf Kálai on 2023. 08. 13..
//

import UIKit
import MemorySavingTabBarController

final class RootViewController: UIViewController {
    private enum State {
        case defaultTabController
        case memorySavingTabController
    }

    private enum Screen {
        fileprivate static var firstViewController: MemorySavingTabViewController {
            MemoryHeavyViewController(
                color: .red,
                tabBar: .init(
                    title: "RED",
                    image: .init(systemName: "square.and.arrow.up"),
                    selectedImage: .init(systemName: "square.and.arrow.up.fill")
                )
            )
        }

        fileprivate static var secondViewController: MemorySavingTabViewController {
            MemoryHeavyViewController(
                color: .black,
                tabBar: .init(
                    title: "BLACK",
                    image: .init(systemName: "square.and.arrow.up.on.square"),
                    selectedImage: .init(systemName: "square.and.arrow.up.on.square.fill")
                )
            )
        }

        fileprivate static var thirdViewController: MemorySavingTabViewController {
            MemoryHeavyViewController(
                color: .blue,
                tabBar: .init(
                    title: "BLUE",
                    image: .init(systemName: "rectangle.portrait.and.arrow.forward"),
                    selectedImage: .init(systemName: "rectangle.portrait.and.arrow.forward.fill")
                )
            )
        }
    }

    private weak var currentTabBarController: UITabBarController?
    private let container = UIView()
    private let button = UIButton()
    private let memoryLabel = UILabel()
    private var state: State = .defaultTabController {
        didSet {
            refresh()
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension RootViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        button.titleLabel?.numberOfLines = .zero
        button.titleLabel?.textAlignment = .center
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 24).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true

        memoryLabel.numberOfLines = .zero
        memoryLabel.textAlignment = .center
        view.addSubview(memoryLabel)
        memoryLabel.translatesAutoresizingMaskIntoConstraints = false
        memoryLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 24).isActive = true
        memoryLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        memoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        memoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true

        button.addAction(.init(handler: { [weak self] _ in
            self?.state = self?.state == .defaultTabController ? .memorySavingTabController : .defaultTabController
        }), for: .touchUpInside)

        refresh()
    }
}

extension RootViewController {
    private func refresh() {
        currentTabBarController.map(removeViewController(_:))

        let title = {
            switch state {
            case .defaultTabController:
                currentTabBarController = {
                    let tabBarController = UITabBarController()
                    tabBarController.viewControllers = [
                        Screen.firstViewController,
                        Screen.secondViewController,
                        Screen.thirdViewController
                    ]
                    tabBarController.delegate = self
                    return tabBarController
                }()
                return "MemorySavingTabBarController"
            case .memorySavingTabController:
                currentTabBarController = {
                    let tabBarController = MemorySavingTabBarController(viewControllers: [
                        .init(isSelected: true) { Screen.firstViewController },
                        .init { Screen.secondViewController },
                        .init { Screen.thirdViewController }
                    ])
                    tabBarController.set(delegate: self)
                    return tabBarController
                }()
                return "UITabBarController"
            }
        }()
        button.setTitle("Tap to change to \(title)!", for: .normal)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.memoryLabel.text = "Used megabytes: \(Memory.getUsedMemory()?.megaBytes.description ?? "NA")"
        }

        currentTabBarController.map { addViewController($0, toView: container) }
    }
}

extension RootViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("tabBarController didSelect")
    }
}

extension RootViewController: MemorySavingTabBarControllerDelegate {
    func willAttach(controller: MemorySavingTabBarController, at index: Int) {
        print("controller willAttach")
    }

    func didAttach(controller: MemorySavingTabBarController, viewController: UIViewController, at index: Int) {
        print("controller didAttach")
    }

    func willDetach(controller: MemorySavingTabBarController, viewController: UIViewController, at index: Int) {
        print("controller willDetach")
    }

    func didDetach(controller: MemorySavingTabBarController, at index: Int) {
        print("controller didDetach")
    }
}
