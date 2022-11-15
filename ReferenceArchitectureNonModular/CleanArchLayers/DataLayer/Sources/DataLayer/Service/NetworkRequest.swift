//
//  NetworkRequest.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import Foundation

public enum NetworkRequestMethod {
    case GET
    case POST
    case DELETE
    case PUT
}

public protocol NetworkRequest {
    var baseURL: String { get set }
    var endpoint: String { get set }
    var method: NetworkRequestMethod { get set }
}
