//
//  Model.swift
//  RecepiePlan
//
//  Created by Kamil Klimacki on 13/02/2025.
//

import Foundation

enum MealType: String, Codable {
    case breakfast
    case brunch
    case lunchDinner = "lunch/dinner"
    case snack
    case teatime
}

struct Links: Codable {
    struct Link: Codable {
        var href: String
    }
    var next: Link?
}

struct Recipes: Codable {
    enum CodingKeys: String, CodingKey {
        case hits
        case links = "_links"
    }
    var hits: [RecipeHit]
    var links: Links
}

struct RecipeHit: Codable {
    let recipe: Recipe
}

struct Recipe: Codable, Equatable {
    var label: String
    var image: String
    var dietLabels: [String]
    var ingredientLines: [String]
    var ingredients: [Ingredients]
    var mealType: [String]
    
}

struct Ingredients: Codable, Equatable {
    var text: String
    var quantity: Double
    var measure: String?
}

struct Response: Codable {
    var recipes: Recipes
    var count: String
}

extension Recipe: Identifiable {
    var id: String {
        UUID().uuidString
    }
}
