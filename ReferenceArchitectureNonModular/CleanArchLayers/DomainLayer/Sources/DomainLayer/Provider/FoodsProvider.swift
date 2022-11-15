//
//  FoodsProvider.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/08.
//

import Foundation

public protocol FoodsProvider {
    func get() async throws -> [Food]
}
