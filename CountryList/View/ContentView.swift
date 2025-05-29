//
//  ContentView.swift
//  CountryListApp
//
//  Created by Anshu Agarwal on 28/05/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModal = CountryViewModal()
    
    var body: some View {
        NavigationStack {
            if (viewModal.countries.isEmpty) {
                ProgressView("Loading...")
            } else {
                List(viewModal.countries) { country in
                    Text(country.name).font(.headline)
                }.navigationTitle("Country List")
            }
        }
        .task {
            do {
                try await viewModal.fetchCountryList()
            }
            catch {
                print("failed to fetch country list with error: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
