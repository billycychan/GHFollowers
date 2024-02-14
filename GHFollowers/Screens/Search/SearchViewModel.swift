//
//  SearchViewModel.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 14/2/2024.
//

import Foundation

class SearchViewModel {
    
    @Published var username = ""
    
    init() {
        
    }
    
    var isUserNameEntered: Bool {
        return !username.isEmpty
    }
}
