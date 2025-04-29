//
//  LocationManager.swift
//  DriftApp
//
//  Created by Emre Er on 29.04.2025.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
    
    func isWithinRange(of drift: Drift) -> Bool {
        guard let userLocation = location else { return false }
        
        let driftLocation = CLLocation(latitude: drift.latitude, longitude: drift.longitude)
        let distance = userLocation.distance(from: driftLocation)
        
        return distance <= 300 // 300 meters radius
    }
}
