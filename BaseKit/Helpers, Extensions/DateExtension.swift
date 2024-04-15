//
//  DateExtension.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 16.04.24.
//

import Foundation

extension Date {

    // TODO: refactor and move this as a helper out of Date.
    /// Creates string from the date with EEEE d+suffix MMMM
    /// - Returns: string from the date, as per design
    func formattedWithSuffix() -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE d'\(self.daySuffix())' MMMM"
        
        return formatter.string(from: self)
    }

    private func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}
