//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 9/2/2024.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month(.wide).year(.defaultDigits))
    }
}
