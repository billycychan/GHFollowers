//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 12/2/2024.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager  {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType) async throws {
        var favorites = try await retrieveFavorites()
        
        switch actionType {
        case .add:
            guard !favorites.contains(favorite) else {
                throw GFError.alreadyInFavorites
            }
            favorites.append(favorite)
        case .remove:
            favorites.removeAll(where: { $0.login == favorite.login })
        }
        
        try save(favorites: favorites)
    }
    
    static func retrieveFavorites() async throws -> [Follower] {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            return favorites
        } catch {
            throw GFError.unableToComplete
        }
    }

    
    static func save(favorites: [Follower]) throws {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
        } catch {
           throw GFError.unableToFavorite
        }
    }
}
