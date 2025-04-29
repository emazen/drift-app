//
//  MapView.swift
//  DriftApp
//
//  Created by Emre Er on 29.04.2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var driftStore: DriftStore
    @State private var selectedDrift: Drift?
    
    var body: some View {
        ZStack {
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                Map(coordinateRegion: .constant(region), showsUserLocation: true, annotationItems: nearbyDrifts) { drift in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: drift.latitude, longitude: drift.longitude)) {
                        Button(action: {
                            selectedDrift = drift
                        }) {
                            Image(systemName: "message.fill")
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(Circle().fill(.white))
                                .shadow(radius: 2)
                        }
                    }
                }
                .ignoresSafeArea()
            } else {
                VStack {
                    Text("Please enable location services to use this app")
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .sheet(item: $selectedDrift) { drift in
            DriftDetailView(drift: drift)
        }
    }
    
    private var region: MKCoordinateRegion {
        if let location = locationManager.location {
            return MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        } else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
    private var nearbyDrifts: [Drift] {
        driftStore.drifts.filter { drift in
            !drift.isExpired && locationManager.isWithinRange(of: drift)
        }
    }
}
