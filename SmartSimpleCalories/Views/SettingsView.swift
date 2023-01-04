//
//  SettingsView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI


struct SettingsView: View {
    @ObservedObject var viewModel: UserSettingsViewModel
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }


    
    
    var body: some View {
        VStack {
            Toggle(isOn: $viewModel.userSettings.caloriesRemaining) {
                Text("Show Remaining")
            }
            .frame(width: (deviceWidth * 0.85), height: 15)
            .padding()
            .background(Color.white)
            .cornerRadius(10.0)
            .onChange(of: viewModel.userSettings.caloriesRemaining) { value in
                if value {
                    viewModel.userSettings.calorieText = "Calories Remaining"
                    viewModel.save()
                } else {
                    viewModel.userSettings.calorieText = "Calories Eaten"
                    viewModel.save()
                }
            }
            HStack {
                Text("When enabled, home screen will show calories remaining instead of calories eaten")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, (deviceWidth * 0.075))
                    .padding(.trailing, (deviceWidth * 0.075))
                Spacer()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundGray"))
    }
}







struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: UserSettingsViewModel())
    }
}
