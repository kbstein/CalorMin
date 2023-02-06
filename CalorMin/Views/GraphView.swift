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
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var dayOfWeek: Int
    let daysOfTheWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State var calorieCounts = [0, 0, 0, 0, 0, 0, 0]
    @State var graphMax = 0

    var body: some View {
        ZStack {
            let maxGraphHeight = deviceHeight * 0.4
            //let graphLines = Int(round(Double(viewModel.userSettings.calorieCounts.max() ?? 2000) / 1000))
            VStack {
                let daysToDisplay = shiftDaysOfTheWeek(currentDay: dayOfWeek)
                Text("Daily Average: \((calorieCounts.reduce(0, +)/calorieCounts.count))")
                    .font(.title2)
                    .padding(.all, 3)
                Text("Max For Week: \((graphMax))")
                    .font(.title2)
                Spacer()
                ZStack {
                    //VStack {
                    //    ForEach(1..<graphLines) { line in
                    //        HStack {
                    //            Text("\(1000 * (graphLines - line))")
                    //                .padding(.trailing, 1.0)
                    //            Rectangle()
                    //                .fill(Color.gray)
                    //                .frame(height: 1)
                    //            .border(.black)
                    //        }
                    //        Spacer()
                    //    }
                    //}

                    Spacer()
                        .frame(height: maxGraphHeight)
                    HStack {
                        ForEach(0..<7) { day in
                            //if day == 0 {
                            //    Spacer()
                            //        .frame(width: 150 - (deviceWidth * 0.3))
                            //}
                            VStack {
                                Spacer()
                                if graphMax > 0 {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 20, height: (CGFloat(calorieCounts[6 - day]) / CGFloat(graphMax)) * maxGraphHeight)
                                }
                                Text("\(daysToDisplay[day])")
                                    .frame(width: 40, height: 10)
                            }
                        }
                    }

                }
                Spacer().frame(height: 10)
            }
        }
        .onAppear {
            calorieCounts = viewModel.userSettings.calorieCounts
            if viewModel.userSettings.calorieCounts.max() ?? 5000 > 0 {
                graphMax = viewModel.userSettings.calorieCounts.max() ?? 5000
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
        GraphView(viewModel: UserSettingsViewModel(), healthDataManager: HealthDataManager(), dayOfWeek: 5)
    }
}

