//
//  CountryListTests.swift
//  CountryListTests
//
//  Created by Anshu Agarwal on 29/05/25.
//

import XCTest
@testable import CountryList
import CoreLocation
import SwiftUI
import RealmSwift

@MainActor
final class CountryListTests: XCTestCase {
    
    var viewModel: CountryViewModal!
    var realm: Realm!
    
    override func setUp() {
        var config = Realm.Configuration(inMemoryIdentifier: self.name)
        config.objectTypes = [CountryObject.self]
        realm = try! Realm(configuration: config)
        
        Realm.Configuration.defaultConfiguration = config
        viewModel = CountryViewModal()
    }
    
    func testToggleSelection_addsAndRemoves() {
        let country = createCountryMockData()
        viewModel.toggleSelection(of: country)
        XCTAssertTrue(viewModel.selectedCountries.contains(where: { $0.name == country.name }))
        
        viewModel.toggleSelection(of: country)
        XCTAssertFalse(viewModel.selectedCountries.contains(where: { $0.name == country.name }))
    }
    
    func testSelectionLimit_isMaxFive() {
        let countries = (1...6).map {
            Country(numericCode: "00\($0)", name: "Country\($0)", capital: nil, currencies: nil)
        }
        
        for country in countries {
            viewModel.toggleSelection(of: country)
        }
        
        XCTAssertEqual(viewModel.selectedCountries.count, 5)
    }
    
    func testCurrencyDisplay_withSymbol() {
        let country = createCountryMockData()
        viewModel.countries = [country]
        XCTAssertEqual(viewModel.countries.first?.currencyDisplay, "Afghan afghani (Ø‹)")
    }
    
    func testCurrencyDisplay_withoutSymbol() {
        let country = Country(numericCode: "006", name: "India", capital: "Delhi", currencies: nil)
        viewModel.countries = [country]
        XCTAssertEqual(viewModel.countries.first?.currencyDisplay, "N/A")
    }
    
    func testFilteredCountries_searchMatch() {
        let country1 = Country(numericCode: "006", name: "India", capital: "Delhi", currencies: nil)
        let country2 = Country(numericCode: "007", name: "Germany", capital: "Berlin", currencies: nil)
        viewModel.countries = [country1, country2]
        
        viewModel.searchText = "ger"
        let result = viewModel.filteredCountries
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Germany")
    }
    
    func testFilteredCountries_searchMatchWithNoText() {
        let country1 = Country(numericCode: "006", name: "India", capital: "Delhi", currencies: nil)
        let country2 = Country(numericCode: "007", name: "Germany", capital: "Berlin", currencies: nil)
        viewModel.countries = [country1, country2]
        
        viewModel.searchText = ""
        let result = viewModel.filteredCountries
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.name, "India")
    }
    
    func testiSSelectedWhenToggled() {
        let country = createCountryMockData()
        let _ = viewModel.toggleSelection(of:country)
        XCTAssertTrue(viewModel.isSelected(country))
        
        let _ = viewModel.toggleSelection(of:country)
        XCTAssertFalse(viewModel.isSelected(country))
    }
    
    func testInsertMatchedCountry() {
        let country = createCountryMockData()
        viewModel.countries = [country]
        let countryName = "Afghanistan"
        let inserted = viewModel.countries.first { $0.name.lowercased() == countryName.lowercased() }
        XCTAssertNotNil(inserted)
    }
    
    func testRemoveCountryRemovesFromList() {
        var countries = [
            Country(numericCode: "006", name: "India", capital: "Delhi", currencies: nil),
            Country(numericCode: "007", name: "Germany", capital: "Berlin", currencies: nil)
        ]
        let view = MainView(countryList: Binding(get: { countries }, set: { countries = $0 }))
        view.removeCountry(countries[0])
        XCTAssertEqual(countries.count, 1)
        XCTAssertEqual(countries.first?.name, "Germany")
    }
    
    func testSaveToRealmShouldSaveCountriesinDB() {
        let country = createCountryMockData()
        let countries = [country]
        
        viewModel.saveToRealm(countries)
        
        let savedObjects = realm.objects(CountryObject.self)
        XCTAssertEqual(savedObjects.count, 1)
        XCTAssertEqual(savedObjects.first?.name, "Afghanistan")
    }
    
    func testLoadFromRealmShouldLoadCountries() {
        let countryObject = CountryObject()
        countryObject.name = "Afghanistan"
        countryObject.capital = "Kabul"
        
        try! realm.write {
            realm.add(countryObject)
        }
        
        viewModel.loadFromRealm()
        
        XCTAssertEqual(viewModel.countries.count, 1)
        XCTAssertEqual(viewModel.countries.first?.name, "Afghanistan")
    }
    
    func testSaveToRealm_shouldClearExistingData() {
        let initial = CountryObject()
        initial.name = "Old"
        try! realm.write {
            realm.add(initial)
        }
        
        let newCountry = createCountryMockData()
        
        viewModel.saveToRealm([newCountry])
        
        let savedObjects = realm.objects(CountryObject.self)
        XCTAssertEqual(savedObjects.count, 1)
        XCTAssertEqual(savedObjects.first?.name, "Afghanistan")
    }
    
    func createCountryMockData() -> Country {
        return Country.init(numericCode: "004", name: "Afghanistan", capital: "Kabul", currencies: [Currency.init(name: "Afghan afghani", symbol: "Ø‹")])
    }
    
    override func tearDown() {
        super.tearDown()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
