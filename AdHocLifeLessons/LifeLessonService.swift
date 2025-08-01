//
//  LifeLessonService.swift
//  AdHocLifeLessons
//
//  Created by Rohan Deshpande on 7/31/25.
//

import Foundation
import SwiftData

struct LifeLessonResponse: Codable {
    let ts: String
    let v: Int
    let s: String
}

@Observable
class LifeLessonService {
    private let apiURL = "https://rohand.app/lifelesson/quote.json"
    private let defaultLesson = "Love Each Other"
    
    var currentLesson: String = ""
    var lastUpdated: Date?
    var isLoading: Bool = false
    
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loadStoredLesson() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<LifeLesson>(
            sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)]
        )
        
        do {
            let lessons = try modelContext.fetch(descriptor)
            if let latestLesson = lessons.first {
                currentLesson = latestLesson.lesson
                lastUpdated = latestLesson.lastUpdated
            } else {
                currentLesson = defaultLesson
                lastUpdated = nil
            }
        } catch {
            currentLesson = defaultLesson
            lastUpdated = nil
        }
    }
    
    func fetchLesson() async {
        isLoading = true
        
        guard let url = URL(string: apiURL) else {
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(LifeLessonResponse.self, from: data)
            
            await MainActor.run {
                self.currentLesson = response.s
                self.lastUpdated = Date()
                self.saveLesson(response)
                self.isLoading = false
            }
        } catch {
            // If API call fails, keep the current lesson (either stored or default)
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func saveLesson(_ response: LifeLessonResponse) {
        guard let modelContext = modelContext else { return }
        
        let newLesson = LifeLesson(
            timestamp: response.ts,
            version: response.v,
            lesson: response.s,
            lastUpdated: Date()
        )
        
        modelContext.insert(newLesson)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save lesson: \(error)")
        }
    }
    
    func getTimeSinceLastUpdate() -> String {
        guard let lastUpdated = lastUpdated else {
            return "Never updated"
        }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return "Last updated: \(formatter.localizedString(for: lastUpdated, relativeTo: Date()))"
    }
}