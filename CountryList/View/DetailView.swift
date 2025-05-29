//
//  DetailView.swift
//  CountryList
//
//  Created by Anshu Agarwal on 29/05/25.
//

import SwiftUI

struct DetailView: View {
    
    let countryInfo: Country
    
    var body: some View {
        Spacer().frame(height: 20)
        VStack(alignment: .leading, spacing: 5) {
            Text("Deatils of \(countryInfo.name) are as follows:").font(.headline).fontWeight(.bold)
            Text("Capital: \(countryInfo.capital ?? "N/A")")
            Text("Currency: \(countryInfo.currencyDisplay)")
            Spacer()
        }.padding()
            .navigationTitle(countryInfo.name)
            .toolbarTitleDisplayMode(.inline)
    }
}
