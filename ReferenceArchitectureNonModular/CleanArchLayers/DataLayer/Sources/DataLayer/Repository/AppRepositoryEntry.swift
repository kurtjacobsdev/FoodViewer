//
//  AppRepositoryEntry.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/05.
//

import Foundation

public protocol AppRepositoryEntity: Codable {
    var id: String { get set }
}
