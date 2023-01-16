//
//  SettingsView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI


struct SettingsView: View {
    @ObservedObject var viewModel: UserSettingsViewModel
    var healthDataManager: HealthDataManager
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    enum FocusField: Hashable {
      case field
    }
    @FocusState private var focusedField: FocusField?
    @State var calorieGoal: String = ""
    @State private var showNumberKeyboard: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.showNumberKeyboard = true
                }) {
                    Text(calorieGoal)
                        .frame(width: (deviceWidth * 0.85), height: 15)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10.0)
                        .foregroundColor(.black)
                        .font(.title3)
                }
                .onAppear {
                    calorieGoal = String(viewModel.userSettings.calorieGoal)
                }
                .onChange(of: viewModel.userSettings.calorieGoal, perform: { value in
                    calorieGoal = String(viewModel.userSettings.calorieGoal)
                })
                .background(Color.gray)
                .cornerRadius(18.0)
                .padding()
                
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
            if (showNumberKeyboard) {
                VisualEffectView(effect: UIBlurEffect(style: .dark)).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Button(action: {
                            self.showNumberKeyboard = false
                        }) {
                            Image(systemName: "x.square")
                                .frame(width: 50, height: 50)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.black)
                                .background(Color.red)
                                .cornerRadius(18.0)
                        }
                        TextField("0", text: self.$calorieGoal)
                        .onAppear {
                            self.focusedField = .field
                        }
                        .focused($focusedField, equals: .field)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.numberPad)
                        .font(.title)
                        .fontWeight(.semibold)
                        Button(action: {
                            self.showNumberKeyboard = false
                            viewModel.userSettings.calorieGoal = Int(calorieGoal) ?? 0
                            viewModel.save()
                            calorieGoal = ""
                        }) {
                            Image(systemName: "checkmark.square")
                                .frame(width: 50, height: 50)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.black)
                                .background(Color.green)
                                .cornerRadius(18.0)
                        }
                    }
                }
                .frame(width: 225, height: 175)
                .background(Color.white)
                .cornerRadius(18.0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundGray"))
    }
}







struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: UserSettingsViewModel(), healthDataManager: HealthDataManager())
    }
}
