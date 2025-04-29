//
//  Models.swift
//  DriftApp
//
//  Created by Emre Er on 29.04.2025.
//

import Foundation

struct Drift: Identifiable, Codable {
    var id: String = UUID().uuidString
    var message: String
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var replies: [Reply] = []
    
    var isExpired: Bool {
        return Date().timeIntervalSince(timestamp) > 1800 // 30 minutes
    }
    
    var formattedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

struct Reply: Identifiable, Codable {
    var id: String = UUID().uuidString
    var message: String
    var timestamp: Date
    
    var formattedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
