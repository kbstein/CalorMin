//
//  HomeView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI

struct HomeView: View {
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
    @State private var text: String = ""
    @State var numberOfCalories = 2500
    @State private var showDayHistoryView: Bool = false
    @State private var showNumberKeyboard: Bool = false
    @State private var enteredCalories: String = ""
    @State private var calorieIntake: Double = 0



    var body: some View {
        ZStack {
            VStack {
                Text("\(viewModel.userSettings.calorieText)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .onAppear {
                        self.healthDataManager.fetchCalorieIntake { (result) in
                            self.viewModel.userSettings.calorieNumberBeingDisplayed = Int(result)
                        }
                    }
                Button(action:  {
                    self.showDayHistoryView = true
                }) {
                    Text("\(viewModel.userSettings.calorieNumberBeingDisplayed)")
                        .foregroundColor(.black)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: (deviceWidth * 0.80), height: 75)
                        .background(Color.gray)
                        .cornerRadius(/*@START_MENU_TOKEN@*/18.0/*@END_MENU_TOKEN@*/)
                }.sheet(isPresented: $showDayHistoryView) {
                    DayHistoryView()
                }
                Spacer()
                Text("Quick Add")
                    .font(.title2)
                    .fontWeight(.semibold)
                quickAddButton(viewModel: viewModel, deviceWidth: deviceWidth, calorieAmount: 500, healthDataManager: healthDataManager)
                    .padding(.bottom, 5.0)
                quickAddButton(viewModel: viewModel, deviceWidth: deviceWidth, calorieAmount: 100, healthDataManager: healthDataManager)
                    .padding(.bottom, 5.0)
                quickAddButton(viewModel: viewModel, deviceWidth: deviceWidth, calorieAmount: 50, healthDataManager: healthDataManager)
                Spacer()
                Button(action: {
                    self.showNumberKeyboard = true
                }) {
                    Image(systemName: "plus")
                        .frame(width: (deviceWidth * 0.15), height: (deviceWidth * 0.15))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                }
                .background(Color.gray)
                .cornerRadius(18.0)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            if (showNumberKeyboard) {
                VisualEffectView(effect: UIBlurEffect(style: .dark)).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Button(action: {
                            self.showNumberKeyboard = false
                            enteredCalories = ""
                        }) {
                            Image(systemName: "x.square")
                                .frame(width: 50, height: 50)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.black)
                                .background(Color.red)
                                .cornerRadius(18.0)
                        }
                        TextField("0", text: self.$enteredCalories, onCommit: {
                            self.numberOfCalories += Int(self.enteredCalories) ?? 0
                        })
                        .onAppear {
                            self.focusedField = .field
                        }
                        .focused($focusedField, equals: .field)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .font(.title)
                        .fontWeight(.semibold)
                        Button(action: {
                            self.showNumberKeyboard = false
                            healthDataManager.saveCalorieIntake(calories: Double(enteredCalories) ?? 0)
                            enteredCalories = ""
                            self.healthDataManager.fetchCalorieIntake { (result) in
                                DispatchQueue.main.async {
                                    viewModel.userSettings.calorieNumberBeingDisplayed = Int(result)
                                }                            }
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

struct quickAddButton: View {
    @ObservedObject var viewModel: UserSettingsViewModel
    var deviceWidth: CGFloat
    var calorieAmount: Int
    var healthDataManager: HealthDataManager

    var body: some View {
        Button {
            healthDataManager.saveCalorieIntake(calories: Double(calorieAmount))
            self.healthDataManager.fetchCalorieIntake { (result) in
                DispatchQueue.main.async {
                    viewModel.userSettings.calorieNumberBeingDisplayed = Int(result)
                }
            }
        } label: {
            Text("\(calorieAmount)")
                .foregroundColor(.black)
                .font(.title)
                .fontWeight(.bold)
                .frame(width: (deviceWidth * 0.80), height: 50)
                .background(Color.gray)
                .cornerRadius(/*@START_MENU_TOKEN@*/18.0/*@END_MENU_TOKEN@*/)
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct DayHistoryView: View {
    
    var body: some View {
        Text("Day History Screen")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: UserSettingsViewModel(), healthDataManager: HealthDataManager())
    }
}


