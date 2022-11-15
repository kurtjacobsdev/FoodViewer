//
//  AnimalDetailRequest.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import Foundation

public struct SingleFoodsDetailRequest: NetworkRequest {
    public init(identifier: String) {
        endpoint = "foods/details/\(identifier)"
    }

    public var baseURL: String = "http://localhost:8080/"
    public var endpoint: String
    public var method: NetworkRequestMethod = .GET
}
