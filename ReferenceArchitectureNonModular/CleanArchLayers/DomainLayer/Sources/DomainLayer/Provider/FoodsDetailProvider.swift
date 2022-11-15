//
//  FoodsDetailProvider.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/08.
//

import Foundation

public protocol FoodsDetailProvider {
    func get(id: String) async throws -> FoodDetail?
}
