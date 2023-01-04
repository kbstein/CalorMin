//
//  ViewModel.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/3/23.
//

import SwiftUI

class UserSettingsViewModel: ObservableObject {
    @Published var userSettings: UserSettings

    init() {
        // Try to retrieve the user's settings from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "userSettings"), let userSettings = try? JSONDecoder().decode(UserSettings.self, from: data) {
            self.userSettings = userSettings
        } else {
            // If the user's settings are not found in UserDefaults, create a new userSettings struct with default values
            self.userSettings = UserSettings(id: UUID(), calorieText: "Calories Eaten", calorieGoal: 2000)
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
        if userSettings.calorieText == "Calories Eaten" {
            userSettings.calorieText = "Calories Remaining"
        } else {
            userSettings.calorieText = "Calories Eaten"
        }
    }
}
