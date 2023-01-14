//
//  ViewModel.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/3/23.
//

import SwiftUI
import HealthKit

class UserSettingsViewModel: ObservableObject {
    @Published var userSettings: UserSettings
    @Published var calorieEntries: [HKQuantitySample] = []

    init() {
        // Try to retrieve the user's settings from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "userSettings"), let userSettings = try? JSONDecoder().decode(UserSettings.self, from: data) {
            self.userSettings = userSettings
        } else {
            // If the user's settings are not found in UserDefaults, create a new userSettings struct with default values
            self.userSettings = UserSettings(id: UUID(), calorieText: "Calories Eaten", calorieGoal: 2000, caloriesRemaining: false, calorieNumberBeingDisplayed: 0)
        }
    }

    func save() {
        // Encode the userSettings struct to data and store it in UserDefaults
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userSettings) {
            UserDefaults.standard.set(encoded, forKey: "userSettings")
        }
    }
    
    func toggleCalorieText() {
        let newText: String
        if userSettings.calorieText == "Calories Eaten" {
            newText = "Calories Remaining"
        } else {
            newText = "Calories Eaten"
        }
        DispatchQueue.main.async {
            self.userSettings.calorieText = newText
        }
    }
    
    func updateCalorieNumberBeingDisplayed(numToDisplay: Int) {
        DispatchQueue.main.async {
            self.userSettings.calorieNumberBeingDisplayed = numToDisplay
        }
    }
    
    func updateCalorieEntries(entries: [HKQuantitySample]) {
        DispatchQueue.main.async {
            self.calorieEntries = entries
        }
    }
}

