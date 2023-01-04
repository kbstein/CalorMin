//
//  SettingsView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI


struct SettingsView: View {
    var viewModel: UserSettingsViewModel
    @State var isSettingEnabled: Bool

    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    var body: some View {
        VStack {
            Toggle(isOn: $isSettingEnabled) {
                Text("Show Consumed")
            }
            .frame(width: (deviceWidth * 0.85), height: 15)
            .padding()
            .cornerRadius(10.0)
            HStack {
                Text("This setting does something")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, (deviceWidth * 0.075))
                Spacer()
            }
        }
    }
}







struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: UserSettingsViewModel(), isSettingEnabled: false)
    }
}
