//
//  ContentView.swift
//  DriftApp
//
//  Created by Emre Er on 28.04.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            DriftListView()
                .tabItem {
                    Label("Drifts", systemImage: "message")
                }
            
            CreateDriftView()
                .tabItem {
                    Label("Create", systemImage: "plus.circle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocationManager())
            .environmentObject(DriftStore())
    }
}
