//
//  MainView.swift
//  CountryList
//
//  Created by Anshu Agarwal on 29/05/25.
//

import SwiftUI

struct MainView: View {
    
    @Binding var countryList: [Country]
    
    var body: some View {
        NavigationStack {
            VStack {
                List(countryList) { country in
                    HStack {
                        NavigationLink(destination: DetailView(countryInfo: country)) {
                            Text(country.name)
                        }
                        Spacer()
                        Button {
                            removeCountry(country)
                        }label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    
                }
            }
        }.navigationTitle("Selected countries")
    }
    
    func removeCountry(_ country: Country) {
        countryList.removeAll{$0.id == country.id}
    }
}
