//
//  APIClient.swift
//  RecepiePlan
//
//  Created by Kamil Klimacki on 13/02/2025.
//

import Foundation

//HTTP method
enum HTTPMethod: String {
    case get = "GET"
}

//define API qustions
protocol APIRequest {
    associatedtype ReturnType: Codable
    var path: String {get}
    var queryItems: [URLQueryItem]? {get}
    var method: HTTPMethod {get}
    var isFullURL: Bool {get}
}


extension APIRequest {
    var isFullURL: Bool {
        return false
    }
}

protocol APIClientProtocol {
    func perform<T: APIRequest>(_ request: T) async throws -> T.ReturnType
}


//API client wysyła zapytanai do API a protokół perform tworzy URL -> wysyła zapytanie do API -> pobiera JSON i dekoduje a jeśli powstaje błąd to go zwraca
final class APIClient: APIClientProtocol {
    func perform<T>(_ request: T) async throws -> T.ReturnType where T: APIRequest {
        var apiRequest: URLRequest
        if request.isFullURL {
            apiRequest = URLRequest.init(url: URL(string: request.path)!)
        } else {
            var components = URLComponents()
            components.queryItems = request.queryItems
            components.path = request.path
            components.scheme = "https"
            components.host = "api.edamam.com"
            
            guard let url = components.url else {
                throw APIError.invalidURL
            }
            apiRequest = URLRequest(url: url)
        }
        
        apiRequest.httpMethod = request.method.rawValue
        
        let (data, _) = try await URLSession.shared.data(for: apiRequest)
        
        do {
            return try JSONDecoder().decode(T.ReturnType.self, from: data)
        } catch {
            throw error
        }
    }
}

enum APIError: Error {
    case invalidURL
}

