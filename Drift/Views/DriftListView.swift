//
//  DriftListView.swift
//  DriftApp
//
//  Created by Emre Er on 29.04.2025.
//


import SwiftUI

struct DriftListView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var driftStore: DriftStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(nearbyDrifts) { drift in
                    NavigationLink(destination: DriftDetailView(drift: drift)) {
                        VStack(alignment: .leading) {
                            Text(drift.message)
                                .font(.headline)
                            Text(drift.formattedTime)
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("\(drift.replies.count) replies")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Nearby Drifts")
        }
    }
    
    private var nearbyDrifts: [Drift] {
        driftStore.drifts.filter { drift in
            !drift.isExpired && locationManager.isWithinRange(of: drift)
        }
    }
}