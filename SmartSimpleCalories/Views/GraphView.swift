//
//  GraphView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI

struct GraphView: View {

    var dayOfWeek: Int
    let daysOfTheWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    
    var body: some View {
        VStack {
            Text("\(daysOfTheWeek[dayOfWeek - 1])")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundGray"))
    }
}









struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(dayOfWeek: 1)
    }
}
