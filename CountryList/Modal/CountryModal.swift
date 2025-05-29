//
//  CountryModal.swift
//  CountryListApp
//
//  Created by Anshu Agarwal on 28/05/25.
//

import Foundation

struct Country: Codable, Identifiable {
    var id: String { numericCode }
    let numericCode: String
    let name: String
    let capital: String?
    let currencies: [Currency]?
    
    struct Currency: Codable {
        let name: String
        let symbol: String
    }
    
    var currencyDisplay: String {
        if let first = currencies?.first {
            return "\(first.name) (\(first.symbol))"
        }
        return "N/A"
    }
}


