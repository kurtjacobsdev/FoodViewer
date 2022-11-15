//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/11/07.
//

import Vapor

public struct FoodDetail: Content {
    var id: String
    var name: String
    var content: FoodDetailContent
    var cultivationCategory: String
    var soilImpact: String
    var species: String
}

public struct FoodDetailContent: Content {
    var water: FoodDetailContentItem
    var energy: FoodDetailContentItem
    var protein: FoodDetailContentItem
}

public struct FoodDetailContentItem: Content {
    var value: Float
    var unit: String
}

