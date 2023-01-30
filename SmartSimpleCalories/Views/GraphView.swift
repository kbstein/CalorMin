//
//  GraphView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI

struct GraphView: View {
    @ObservedObject var viewModel: UserSettingsViewModel
    var healthDataManager: HealthDataManager
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var dayOfWeek: Int
    let daysOfTheWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State var calorieCounts = [0, 0, 0, 0, 0, 0, 0]
    @State var graphMax = 5000

    var body: some View {
        ZStack {
            VStack {
                let daysToDisplay = shiftDaysOfTheWeek(currentDay: dayOfWeek)
                Text("Daily Average: \((calorieCounts.reduce(0, +)/calorieCounts.count))")
                    .font(.title2)
                    .padding()
                Text("Daily Max: \((graphMax))")
                    .font(.title2)
                    .padding()
                Spacer()
                HStack {
                    ForEach(0..<7) { day in
                        VStack {
                            Spacer()
                            Rectangle()
                            .fill(Color.gray)
                            .frame(width: 20, height: CGFloat(calorieCounts[6 - day]) * 0.065)
                            .border(.black)
                            Text("\(daysToDisplay[day])")
                                .frame(width: 40)
                        }
                    }
                }
                Spacer().frame(height: 10)
            }
        }
        .onAppear {
            calorieCounts = viewModel.userSettings.calorieCounts
            graphMax = viewModel.userSettings.calorieCounts.max() ?? 2000
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundGray"))
    }
    
    func shiftDaysOfTheWeek(currentDay: Int) -> [String] {
        var shiftedDaysOfTheWeek = daysOfTheWeek
        for _ in 1..<currentDay + 1 {
            shiftedDaysOfTheWeek.append(shiftedDaysOfTheWeek.remove(at: 0))
        }
        return shiftedDaysOfTheWeek
    }
}



struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(viewModel: UserSettingsViewModel(), healthDataManager: HealthDataManager(), dayOfWeek: 5)
    }
}

