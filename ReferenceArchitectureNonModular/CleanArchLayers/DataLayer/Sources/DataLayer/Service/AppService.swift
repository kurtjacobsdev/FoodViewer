//
//  AnimalsService.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import Foundation

public protocol AppService {
    func perform(request: NetworkRequest) async throws -> Data
}

public class VaporAppService: AppService {
    private var session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    public func perform(request: NetworkRequest) async throws -> Data {
        switch request.method {
        case .DELETE:
            var urlRequest = URLRequest(url: URL(string: request.baseURL + request.endpoint)!)
            urlRequest.httpMethod = "DELETE"
            let (result, _) = try await session.data(for: urlRequest)
            return result
        case .GET:
            var urlRequest = URLRequest(url: URL(string: request.baseURL + request.endpoint)!)
            urlRequest.httpMethod = "GET"
            let (result, _) = try await session.data(for: urlRequest)
            return result
        case .POST:
            var urlRequest = URLRequest(url: URL(string: request.baseURL + request.endpoint)!)
            urlRequest.httpMethod = "POST"
            let (result, _) = try await session.data(for: urlRequest)
            return result
        case .PUT:
            var urlRequest = URLRequest(url: URL(string: request.baseURL + request.endpoint)!)
            urlRequest.httpMethod = "PUT"
            let (result, _) = try await session.data(for: urlRequest)
            return result
        }
    }
}
