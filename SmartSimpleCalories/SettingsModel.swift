//
//  SettingsModel.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/4/23.
//

import Foundation


struct UserSettings: Codable, Identifiable {
    var id: UUID
    var calorieCountText: String
    var calorieGoal: Int
}
