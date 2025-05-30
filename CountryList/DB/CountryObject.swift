//
//  CountryObject.swift
//  CountryList
//
//  Created by Anshu Agarwal on 30/05/25.
//

import Foundation
import RealmSwift

class CountryObject: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var capital: String?
    @Persisted var currencyName: String?
    @Persisted var currencySymbol: String?

    convenience init(from country: Country) {
        self.init()
        self.id = country.id
        self.name = country.name
        self.capital = country.capital
        self.currencyName = country.currencies?.first?.name
        self.currencySymbol = country.currencies?.first?.symbol
    }

    func toCountry() -> Country {
        Country(numericCode: id, name: name, capital: capital, currencies: [Currency(name: currencyName ?? "", symbol: currencySymbol ?? "")])
    }
}
