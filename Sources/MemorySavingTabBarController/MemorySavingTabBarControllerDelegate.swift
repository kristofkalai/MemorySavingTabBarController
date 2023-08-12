//
//  MemorySavingTabBarControllerDelegate.swift
//  
//
//  Created by Kristóf Kálai on 2023. 08. 12..
//

import UIKit

@objc public protocol MemorySavingTabBarControllerDelegate: AnyObject {
    @objc optional func willDetach(controller: MemorySavingTabBarController, viewController: UIViewController, at index: Int)
    @objc optional func didDetach(controller: MemorySavingTabBarController, at index: Int)
    @objc optional func willAttach(controller: MemorySavingTabBarController, at index: Int)
    @objc optional func didAttach(controller: MemorySavingTabBarController, viewController: UIViewController, at index: Int)
}
