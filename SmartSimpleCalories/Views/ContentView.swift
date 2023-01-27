//
//  ContentView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI
import HealthKit
import Combine

struct ContentView: View {
    let healthDataManager = HealthDataManager()
    var viewModel = UserSettingsViewModel()
    @State var date = Date()
    @State var calendar = Calendar.current

    var body: some View {
        TabView {
            NavigationView {
                HomeView(viewModel: viewModel, healthDataManager: healthDataManager)
                    .navigationBarTitle("Home")
            }.tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            NavigationView {
                GraphView(healthDataManager: healthDataManager, dayOfWeek: calendar.component(.weekday, from: date))
                    .navigationBarTitle("Graph")
            }.tabItem {
                Image(systemName: "chart.bar")
                Text("Graph")
            }
            NavigationView {
                SettingsView(viewModel: viewModel, healthDataManager: healthDataManager)
                    .navigationBarTitle("Settings")
            }.tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .onAppear {
                date = Date()
                calendar = Calendar.current
            }
        }.onAppear(perform: requestAuthorization)
    }
    
    func requestAuthorization() {
      healthDataManager.requestAuthorization()
    }
    
    
}


class HealthDataManager {
    let healthStore = HKHealthStore()
    let userDefaults = UserDefaults.standard
    
    func requestAuthorization() {
        if !userDefaults.bool(forKey: "healthDataAuthorized") {
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!])
            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { [weak self] (success, error) in
                guard success else {
                    // Handle error
                    return
                }
                self?.userDefaults.set(true, forKey: "healthDataAuthorized")
            }
        }
    }
    
    func fetchCalorieIntake(day: Date, completion: @escaping (Double) -> Void) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: day)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let calorieType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                // Handle error
                return
            }
            completion(sum.doubleValue(for: HKUnit.kilocalorie()))
        }
        healthStore.execute(query)
    }
    
    func fetchCalorieIntakeInt(day: Date) -> Int? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: day)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let calorieType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        var calorieIntake:Int?
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                // Handle error
                return
            }
            calorieIntake = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
        }
        healthStore.execute(query)
        return calorieIntake
    }

    
    func fetchActiveCalorieBurned(completion: @escaping (Double) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let calorieType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                // Handle error
                return
            }
            completion(sum.doubleValue(for: HKUnit.kilocalorie()))
        }
        healthStore.execute(query)
    }
    
    func fetchBasalCalorieBurned(completion: @escaping (Double) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let calorieType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                // Handle error
                return
            }
            completion(sum.doubleValue(for: HKUnit.kilocalorie()))
        }
        healthStore.execute(query)
    }
    
    func fetchBasalCalorieBurnedInt() -> Int? {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let calorieType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        var basalCalories:Int?
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                // Handle error
                return
            }
            basalCalories = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
        }
        healthStore.execute(query)
        return basalCalories
    }
    
    func saveCalorieIntake(calories: Double) {
        let calorieType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let caloriesQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
        let now = Date()
        
        let sample = HKQuantitySample(type: calorieType, quantity: caloriesQuantity, start: now, end: now)
        
        healthStore.save(sample) { (success, error) in
            // Handle success or error
        }
    }
    
    func fetchCalorieEntries(completion: @escaping ([HKQuantitySample]) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let calorieType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let query = HKAnchoredObjectQuery(type: calorieType, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, newAnchor, error) in
            guard let samples = samples as? [HKQuantitySample] else {
                // Handle error
                return
            }
            completion(samples)
        }
        healthStore.execute(query)
    }
    
    func deleteCalorieEntry(entry: HKQuantitySample) {
        healthStore.delete(entry) { (success, error) in
            if !success {
                // Handle error
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
