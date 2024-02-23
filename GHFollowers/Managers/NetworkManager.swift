//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 23/1/2024.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()

    let baseURL = "https://api.github.com"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()

    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "/users/" + "\(username)"

        guard let url = URL(string: endpoint) else {
            throw GFError.invalidData
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }

        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }

    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            return image
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}

extension NetworkManager {
    func request<T: Codable>(session: URLSession,
                             _ endpoint: Endpoint,
                             type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw GFError.invalidURL
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
                (200...300) ~= response.statusCode else {
            throw GFError.invalidResponse
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
}

private extension NetworkManager {
    func buildRequest(from url: URL, methodType: Endpoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        }
        return request
    }
}
