//
//  CountryViewModal.swift
//  CountryListApp
//
//  Created by Anshu Agarwal on 28/05/25.
//

import Foundation
import RealmSwift

@MainActor
class CountryViewModal: ObservableObject {
    
    @Published var countries: [Country] = []
    @Published var searchText: String = ""
    @Published var selectedCountries: [Country] = []
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func fetchCountryList() async throws {
        guard let url = URL(string: "https://restcountries.com/v2/all") else {return}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode([Country].self, from: data)
        self.countries = response
        saveToRealm(self.countries)
    }
    
    func saveToRealm(_ countries: [Country]) {
        let realm = try! Realm()
        let objects = countries.map { CountryObject(from: $0) }

        try! realm.write {
            realm.delete(realm.objects(CountryObject.self)) // Optional: clear existing
            realm.add(objects)
        }

        print("✅ Saved to Realm")
    }
    
    func loadFromRealm() {
        let realm = try! Realm()
        let objects = realm.objects(CountryObject.self)
        self.countries = objects.map { $0.toCountry() }
        print("📦 Loaded from Realm")
    }
    
    func toggleSelection(of country: Country) {
        if selectedCountries.contains(where: { $0.id == country.id }) {
            selectedCountries.removeAll { $0.id == country.id }
        } else if selectedCountries.count < 5 {
            selectedCountries.append(country)
        }
    }
    
    func isSelected(_ country: Country) -> Bool {
        selectedCountries.contains(where: { $0.id == country.id })
    }
    
}
