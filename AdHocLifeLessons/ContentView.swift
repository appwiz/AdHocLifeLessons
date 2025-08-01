//
//  ContentView.swift
//  AdHocLifeLessons
//
//  Created by Rohan Deshpande on 7/31/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var lifeLessonService = LifeLessonService()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Main lesson content area
                ScrollView {
                    VStack {
                        Spacer()
                        
                        Text(lifeLessonService.currentLesson)
                            .font(.system(size: 48, weight: .medium, design: .default))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height - 80) // Account for footer height
                }
                
                // Footer
                VStack(spacing: 8) {
                    Divider()
                    
                    HStack {
                        Text(lifeLessonService.getTimeSinceLastUpdate())
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await lifeLessonService.fetchLesson()
                            }
                        }) {
                            HStack(spacing: 4) {
                                if lifeLessonService.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "arrow.clockwise")
                                }
                                Text("Refresh")
                            }
                            .font(.caption)
                        }
                        .disabled(lifeLessonService.isLoading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
                .background(Material.bar)
            }
        }
        .onAppear {
            lifeLessonService.setModelContext(modelContext)
            lifeLessonService.loadStoredLesson()
            
            // Start automatic background fetching every hour
            lifeLessonService.startBackgroundFetching()
            
            // Fetch fresh lesson on app launch
            Task {
                await lifeLessonService.fetchLesson()
            }
        }
        .onDisappear {
            // Stop background fetching when view disappears
            lifeLessonService.stopBackgroundFetching()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LifeLesson.self, inMemory: true)
}
