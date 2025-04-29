//
//  CreateDriftView.swift
//  DriftApp
//
//  Created by Emre Er on 29.04.2025.
//


import SwiftUI

struct CreateDriftView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var driftStore: DriftStore
    @State private var messageText = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        VStack {
            Text("Create a new drift")
                .font(.title)
                .padding()
            
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                TextEditor(text: $messageText)
                    .padding()
                    .frame(height: 200)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding()
                
                Button(action: {
                    if let location = locationManager.location, !messageText.isEmpty {
                        driftStore.createDrift(
                            message: messageText,
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                        messageText = ""
                        showingConfirmation = true
                    }
                }) {
                    Text("Release your drift")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(messageText.isEmpty || locationManager.location == nil)
            } else {
                Text("Please enable location services to create drifts")
                    .padding()
                
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
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Drift Released!"),
                message: Text("Your drift is now floating in the digital space. It will last for 30 minutes."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}