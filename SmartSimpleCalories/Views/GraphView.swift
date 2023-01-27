//
//  GraphView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI

struct GraphView: View {
    var healthDataManager: HealthDataManager
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var dayOfWeek: Int
    let daysOfTheWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        ZStack {
            VStack {
                let calorieCounts = getDailyCalorieCount()
                let daysToDisplay = shiftDaysOfTheWeek(currentDay: dayOfWeek)
                Text("Daily Calories")
                    .font(.title)
                Text("Todays Count")
                    .font(.title2)
                    .padding()
                Spacer()
                HStack {
                    ForEach(0..<7) { day in
                        VStack {
                            Spacer()
                            Rectangle()
                            .fill(Color.red)
                            .frame(width: 20, height: CGFloat(calorieCounts[6 - day]) * 0.05)
                            Text("\(daysToDisplay[day])")
                                .frame(width: 40)
                        }
                    }
                }
                Spacer().frame(height: 10)
            }
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
    
    func getDailyCalorieCount() -> [Int] {
        var currentDate = Date()
        var dailyCalorieList = [Int]()
        let group = DispatchGroup()
        for _ in 1..<8 {
            group.enter()
            self.healthDataManager.fetchCalorieIntake(day: currentDate) { (result) in
                dailyCalorieList.append(Int(result))
                group.leave()
            }
            currentDate = currentDate.dayBefore
        }
        group.wait()
        return dailyCalorieList
    }

    
    //func getDailyCalorieCount() -> [Int] {
    //    var currentDate = Date()
    //    var dailyCalorieList = [Int]()
    //    var currentNum = 0
    //    for _ in 1..<9 {
    //        dailyCalorieList.append(1)
    //        self.healthDataManager.fetchCalorieIntake(day: currentDate) { (result) in
    //            currentNum = Int(result)
    //        }
    //        dailyCalorieList.append(currentNum)
    //        print("\(dailyCalorieList[0])")
    //        currentDate = currentDate.dayBefore
    //    }
    //    return dailyCalorieList
    //}
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

