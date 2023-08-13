//
//  Memory.swift
//  Example
//
//  Created by Kristóf Kálai on 2023. 08. 13..
//

import Foundation

enum Memory {
    struct Allocation {
        fileprivate let values: [UInt8]
    }

    case bytes(Int)
    static func kiloBytes(_ kiloBytes: Int) -> Self {
        .bytes(1024 * kiloBytes)
    }
    static func megaBytes(_ megaBytes: Int) -> Self {
        .kiloBytes(1024 * megaBytes)
    }

    var bytes: Int {
        switch self {
        case .bytes(let bytes): return bytes
        }
    }

    var kiloBytes: Int {
        bytes / 1024
    }

    var megaBytes: Int {
        kiloBytes / 1024
    }

    static func allocate(memory: Memory) -> Allocation {
        .init(values: [UInt8](repeating: 0, count: memory.bytes))
    }

    static func getUsedMemory() -> Memory? {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4

        let error = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        return error == KERN_SUCCESS ? .bytes(Int(info.resident_size)) : nil
    }
}
