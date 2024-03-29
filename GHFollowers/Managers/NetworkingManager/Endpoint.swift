//
//  Endpoint.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 23/2/2024.
//

import Foundation

enum Endpoint {
    case user(User)

    enum User {
        case getfollowers(username: String, page: Int)
        case getUserInfo(username: String)
    }

    enum MethodType {
        case GET
    }
}

extension Endpoint {

    var host: String { "api.github.com" }

    var path: String {
        switch self {
        case let .user(.getfollowers(username, _)):
            return "/users/\(username)/followers"
        case let .user(.getUserInfo(username)):
            return "/users/\(username)"
        }
    }

    var methodType: MethodType {
        switch self {
        case .user(.getfollowers), .user(.getUserInfo):
            return .GET
        }
    }

    var queryItems: [String: String]? {
        switch self {
        case let .user(.getfollowers(_, page)):
            return ["per_page": "100",
                    "page": String(page)]
        case .user(.getUserInfo):
            return nil
        }
    }
}

extension Endpoint {

    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path

        var requestQueryItems = [URLQueryItem]()

        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        urlComponents.queryItems = requestQueryItems

        return urlComponents.url
    }

}
