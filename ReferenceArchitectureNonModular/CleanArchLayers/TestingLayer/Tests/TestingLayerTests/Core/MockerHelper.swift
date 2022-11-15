//
//  MockerHelper.swift
//  ReferenceArchitectureNonModularTests
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import Foundation
import Mocker

public final class MockedData {}

enum MockerHelperError: Error {
    case registerFailed
}

public class MockerHelper {
    var urlSession: URLSession!

    func start() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }

    func register(url: String, json: String, statusCode: Int) throws {
        let jsonPath = Bundle.module.path(forResource: json, ofType: "json")!
        let routeURL = URL(string: url)!
        guard let data = try? NSData(contentsOfFile: jsonPath) else { throw MockerHelperError.registerFailed }

        let mock = Mock(url: routeURL, dataType: .json, statusCode: statusCode, data: [
            .get: data as Data
        ])
        mock.register()
    }
}
