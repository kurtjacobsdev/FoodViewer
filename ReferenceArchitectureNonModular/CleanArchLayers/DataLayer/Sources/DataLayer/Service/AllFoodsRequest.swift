//
//  AnimalRequest.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import Foundation

public struct AllFoodsRequest: NetworkRequest {
    public var baseURL: String = "http://localhost:8080/"
    public var endpoint: String = "foods"
    public var method: NetworkRequestMethod = .GET
}
