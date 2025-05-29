//
//  ContentView.swift
//  CountryListApp
//
//  Created by Anshu Agarwal on 28/05/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModal = CountryViewModal()
    let screenWidth = UIScreen.main.bounds.width
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            if (viewModal.countries.isEmpty) {
                ProgressView("Loading...")
            } else {
                
                ZStack(alignment: .bottom) {
                    List(viewModal.filteredCountries) { country in
                        Button {
                            viewModal.toggleSelection(of: country)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(country.name).font(.headline)
                                    Text("Capital:\(country.capital ?? "N/A")").font(.subheadline)
                                    Text("Currency: \(country.currencyDisplay)").font(.subheadline).foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 5)
                                Spacer()
                                if viewModal.isSelected(country) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }.disabled(!viewModal.isSelected(country) && viewModal.selectedCountries.count >= 5)
                    }
                    
                    VStack {
                        if viewModal.selectedCountries.count > 0 {
                            NavigationLink(destination: MainView(countryList: $viewModal.selectedCountries)) {
                                        Text("Continue")
                                            .frame(width: screenWidth - 120, height: 50)
                                            .background(Color.cyan)
                                            .foregroundColor(.white)
                                            .cornerRadius(25)
                            }.padding()
                        }
                    }
                }.navigationTitle("Country List")
                    .searchable(text: $viewModal.searchText, prompt: "Search Country").foregroundStyle(.primary)
                    .focused($isSearchFocused)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if isSearchFocused {
                                Button("Cancel") {
                                    viewModal.searchText = ""
                                    isSearchFocused = false
                                }
                            }
                        }
                    }
            }
        }
        .task {
            do {
                try await viewModal.fetchCountryList()
                
                if let userCountry = locationManager.currentCountry {
                    addUserCountry(userCountry)
                } else if locationManager.permissionDenied {
                    addDefaultCountry()
                }
            }
            catch {
                print("failed to fetch country list with error: \(error)")
            }
        }
    }
    
    func addUserCountry(_ name: String) {
        guard let matchedCountry = viewModal.countries.first(where: { $0.name.lowercased() == name.lowercased() }) else {
            addDefaultCountry()
            return
        }
        
        viewModal.selectedCountries.insert(matchedCountry, at: 0)
    }
    
    func addDefaultCountry() {
        if let defaultCountry = viewModal.countries.first(where: { $0.name == "India" }) {
            viewModal.selectedCountries.insert(defaultCountry, at: 0)
        }
    }
}

#Preview {
    ContentView()
}
