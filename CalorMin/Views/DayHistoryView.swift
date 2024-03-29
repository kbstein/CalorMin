//
//  DayHistoryView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/6/23.
//

import Foundation
import SwiftUI
import HealthKit

struct DayHistoryView: View {
    @ObservedObject var viewModel: UserSettingsViewModel
    @State var calorieEntries: [HKQuantitySample]
    var healthDataManager: HealthDataManager
    var calorieIntake: Int
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(calorieIntake)")
                    .font(.title)
                    .onAppear {
                        
                    }
                    .fontWeight(.semibold)
                Text("\(Date(), style: .date)")
                    .font(.title2)
                    .fontWeight(.medium)
                Spacer()
                    .frame(height: 10.0)
                List {
                    ForEach(calorieEntries, id: \.self) { entry in
                        Text("\(Int(entry.quantity.doubleValue(for: HKUnit.kilocalorie()))) calories at \(entry.startDate, style: .time)")
                        if calorieEntries.isEmpty {
                            Text("No Entries")
                        }
                    }
                    //.onDelete(perform: deleteCalorieEntry)
                }
            }
            .navigationBarTitle("Day History")
        }
    }
    
    func deleteCalorieEntry(at offsets: IndexSet, entry: HKQuantitySample) {
        // Delete the calorie entries at the specified indices
        viewModel.calorieEntries.remove(atOffsets: offsets)
        healthDataManager.deleteCalorieEntry(entry: entry)
    }
}






struct DayHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        DayHistoryView(viewModel: UserSettingsViewModel(), calorieEntries: [], healthDataManager: HealthDataManager(), calorieIntake: 100)
    }
}
