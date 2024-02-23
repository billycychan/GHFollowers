//
//  GFError.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 23/1/2024.
//

import Foundation

enum GFError: String, Error {
    case invalidURL = "There was an error building the URL. Please try again."
    case unableToComplete = "Unable to complete your request, Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. you must REALLY like them."
}
