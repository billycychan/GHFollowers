//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 9/2/2024.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
