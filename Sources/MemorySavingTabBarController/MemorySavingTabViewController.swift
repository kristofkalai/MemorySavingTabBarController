//
//  MemorySavingTabViewController.swift
//  
//
//  Created by Kristóf Kálai on 2023. 08. 12..
//

import UIKit

public protocol MemorySavingTabViewController: UIViewController {
    func provideTabBarItem() -> UITabBarItem
}
