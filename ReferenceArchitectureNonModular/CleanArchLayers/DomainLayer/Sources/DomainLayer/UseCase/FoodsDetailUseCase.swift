//
//  FoodsDetailUseCase.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/06.
//

import Foundation

public protocol FoodDetailUseCase {
    func refresh(identifier: String) async throws -> FoodDetail?
}
