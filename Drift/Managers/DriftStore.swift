//
//  DriftStore.swift
//  DriftApp
//
//  Created by Emre Er on 29.04.2025.
//

import SwiftUI
import Firebase

class DriftStore: ObservableObject {
    @Published var drifts: [Drift] = []
    private var db = Firestore.firestore()
    
    init() {
        loadDrifts()
    }
    
    func loadDrifts() {
        db.collection("drifts")
            .whereField("timestamp", isGreaterThan: Date().addingTimeInterval(-1800)) // Only get non-expired drifts
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.drifts = documents.compactMap { document -> Drift? in
                    do {
                        let data = document.data()
                        let id = document.documentID
                        let message = data["message"] as? String ?? ""
                        let latitude = data["latitude"] as? Double ?? 0
                        let longitude = data["longitude"] as? Double ?? 0
                        let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                        
                        var replies: [Reply] = []
                        if let replyData = data["replies"] as? [[String: Any]] {
                            replies = replyData.compactMap { replyDict -> Reply? in
                                guard let replyMessage = replyDict["message"] as? String,
                                      let replyTimestamp = (replyDict["timestamp"] as? Timestamp)?.dateValue() else {
                                    return nil
                                }
                                return Reply(message: replyMessage, timestamp: replyTimestamp)
                            }
                        }
                        
                        return Drift(id: id, message: message, latitude: latitude, longitude: longitude, timestamp: timestamp, replies: replies)
                    } catch {
                        print("Error decoding drift: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
    }
    
    func createDrift(message: String, latitude: Double, longitude: Double) {
        let newDrift = Drift(message: message, latitude: latitude, longitude: longitude, timestamp: Date())
        
        let data: [String: Any] = [
            "message": newDrift.message,
            "latitude": newDrift.latitude,
            "longitude": newDrift.longitude,
            "timestamp": Timestamp(date: newDrift.timestamp),
            "replies": []
        ]
        
        db.collection("drifts").document(newDrift.id).setData(data) { error in
            if let error = error {
                print("Error adding drift: \(error.localizedDescription)")
            }
        }
    }
    
    func addReply(to drift: Drift, message: String) {
        let newReply = Reply(message: message, timestamp: Date())
        
        db.collection("drifts").document(drift.id).updateData([
            "replies": FieldValue.arrayUnion([
                [
                    "id": newReply.id,
                    "message": newReply.message,
                    "timestamp": Timestamp(date: newReply.timestamp)
                ]
            ])
        ]) { error in
            if let error = error {
                print("Error adding reply: \(error.localizedDescription)")
            }
        }
    }
}
