//
//  DriftDetailView.swift
//  DriftApp
//
//  Created by Emre Er on 29.04.2025.
//


import SwiftUI

struct DriftDetailView: View {
    @EnvironmentObject var driftStore: DriftStore
    let drift: Drift
    @State private var replyText = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(drift.message)
                            .font(.headline)
                        Text(drift.formattedTime)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    
                    if drift.replies.isEmpty {
                        Text("No replies yet...")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(drift.replies) { reply in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(reply.message)
                                Text(reply.formattedTime)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Reply anonymously...", text: $replyText)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Button(action: {
                    if !replyText.isEmpty {
                        driftStore.addReply(to: drift, message: replyText)
                        replyText = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .disabled(replyText.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Drift Detail")
    }
}