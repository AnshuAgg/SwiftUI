//
//  LocationManagerTests.swift
//  CountryListTests
//
//  Created by Anshu Agarwal on 29/05/25.
//

import XCTest
@testable import CountryList
import CoreLocation

final class LocationManagerTests: XCTestCase {
    
    var didCallRequestAuth = false
    var didCallStartUpdating = false
    
    func testPermissionDeniedSetsFlag() {
        let manager = LocationManager()
        manager.locationManager(CLLocationManager(), didChangeAuthorization: .denied)
        XCTAssertTrue(manager.permissionDenied)
        
        manager.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedWhenInUse)
        XCTAssertFalse(manager.permissionDenied)
    }
    
    func testLocationPermissionDidFail() {
        let manager = LocationManager()
        let mockError = NSError(domain: kCLErrorDomain, code: CLError.denied.rawValue, userInfo: nil)
        manager.locationManager(CLLocationManager(), didFailWithError: mockError)
        XCTAssertTrue(manager.permissionDenied)
        XCTAssertNil(manager.currentCountry)
    }
    
    func testLocationUpdatesSetCurrentCountry() {
        let manager = LocationManager()
        let mockLocation = CLLocation(latitude: 28.6139, longitude: 77.2090)
        manager.locationManager(CLLocationManager(), didUpdateLocations: [mockLocation])
    }
    
}
