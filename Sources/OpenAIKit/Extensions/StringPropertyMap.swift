//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Arnett on 10/10/23.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

internal extension [String: Property] {
    var body: [String: Any] {
        var result: [String: Any] = [:]
        for key in self.keys {
            let value = self[key]
            if let value {
                result[key] = value.body
            }
        }
        return result
    }
}
