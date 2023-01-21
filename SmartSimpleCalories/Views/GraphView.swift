//
//  GraphView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI

struct GraphView: View {
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var dayOfWeek: Int
    let daysOfTheWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        ZStack {
            VStack {
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
                            .frame(width: 20, height: deviceHeight * 0.4)
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
}









struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(dayOfWeek: 4)
    }
}
