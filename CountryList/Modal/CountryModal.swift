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
}


