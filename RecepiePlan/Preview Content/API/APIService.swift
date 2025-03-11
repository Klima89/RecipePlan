//
//  APIService.swift
//  RecepiePlan
//
//  Created by Kamil Klimacki on 13/02/2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchRecipes(mealType: String) async throws -> Recipes
    func fetchMoreRecipes(forUri: String) async throws -> Recipes
}


//klasa słuzy do pobierania przepisów
class APIService: APIServiceProtocol {
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func fetchRecipes(mealType: String) async throws -> Recipes {
        try await client.perform(GetRecipeRequest(mealType: mealType))
    }
    
    func fetchMoreRecipes(forUri: String) async throws -> Recipes {
        try await client.perform(GetNextPageRequest(path: forUri))
    }
}

//struktura przechowuje dane dotyczące zapytania do API
struct GetRecipeRequest: APIRequest {
    typealias ReturnType = Recipes
    
    let path: String = "/api/recipes/v2"
    let method: HTTPMethod = .get
    
    private let mealType: String
    private let uri: String?
    
    
    init(mealType: String, uri: String? = nil) {
        self.mealType = mealType
        self.uri = uri
    }
    
    var queryItems: [URLQueryItem]? {
        var items: [URLQueryItem] =
        [
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "app_id", value: "4134965e"),
            URLQueryItem(name: "app_key", value: "71070d7475239ef0beb5a6523f1839fd"),
            URLQueryItem(name: "diet", value: "balanced"),
            URLQueryItem(name: "health", value: "alcohol-free"),
            URLQueryItem(name: "cuisineType", value: "Central Europe"),
            URLQueryItem(name: "mealType", value: mealType),
            URLQueryItem(name: "imageSize", value: "REGULAR")
        ]
        
        if let uri = uri {
            items.append(URLQueryItem(name: "count", value: uri))
        }
        return items
    }
    
}

struct GetNextPageRequest: APIRequest {
    var queryItems: [URLQueryItem]?
    
    typealias ReturnType = Recipes
    var isFullURL: Bool { true }
    
    let path: String
    let method: HTTPMethod = .get
    
    init(path: String) {
        self.path = path
    }
}
 

//"https://api.edamam.com/api/recipes/v2?app_key=9258f19e7872f89b48c0ea61134cd4eb&mealType=breakfast&_cont=CHcVQBtNNQphDmgVQntAEX4BY0twBgQDSmxJCmsaalx6DQoORXdcEWVHYgYiAwoAFTcUBWZAY1xyVQNWEWMTA2RAYAFxAgtRUQhcETRRPAhhDgEHDg%3D%3D&health=alcohol-free&diet=balanced&cuisineType=Central%20Europe&imageSize=REGULAR&type=public&app_id=5743c2ff"


//https://api.edamam.com/api/recipes/v2/9669479bf49f463abf1c8c2b04bd046d?app_id=5743c2ff&app_key=9258f19e7872f89b48c0ea61134cd4eb
