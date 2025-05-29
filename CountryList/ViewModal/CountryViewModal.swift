//
//  CountryViewModal.swift
//  CountryListApp
//
//  Created by Anshu Agarwal on 28/05/25.
//

import Foundation

class CountryViewModal: ObservableObject {
    
    @Published var countries: [Country] = []
    
    func fetchCountryList() async throws {
        guard let url = URL(string: "https://restcountries.com/v2/all") else {return}
        
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode([Country].self, from: data)
            self.countries = response
        
    }
    
}
