//
//  NSObjectProtocol+Extensions.swift
//  
//
//  Created by Kristóf Kálai on 2023. 08. 12..
//

import Foundation

extension NSObjectProtocol {
    @discardableResult func configure(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
