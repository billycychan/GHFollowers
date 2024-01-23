//
//  GFError.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 23/1/2024.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invaid request. Please try again."
    case unableToComplete = "Unable to complete your request, Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
