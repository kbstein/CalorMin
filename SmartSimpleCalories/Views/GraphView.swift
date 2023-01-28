//
//  GraphView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI

struct GraphView: View {
    @State var calorieCounts = [0, 0, 0, 0, 0, 0, 0]
    var healthDataManager: HealthDataManager
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var dayOfWeek: Int
    let daysOfTheWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        ZStack {
            VStack {
                let daysToDisplay = shiftDaysOfTheWeek(currentDay: dayOfWeek)
                Text("Daily Average: \((calorieCounts.reduce(0, +)/calorieCounts.count))")
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
            getDailyCalorieCount()
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
    
    func getDailyCalorieCount() {
        var currentDate = Date()
        for i in 0..<7 {
            self.healthDataManager.fetchCalorieIntake(day: currentDate) { (result) in
                calorieCounts[i] = Int(result)
            }
            currentDate = currentDate.dayBefore
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(healthDataManager: HealthDataManager(), dayOfWeek: 5)
    }
}

