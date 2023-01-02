//
//  HomeView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI

struct HomeView: View {
    enum FocusField: Hashable {
      case field
    }
    @FocusState private var focusedField: FocusField?
    @State private var text: String = ""
    @State var numberOfCalories = 2500
    @State private var showDayHistoryView: Bool = false
    @State var textBelowCalorieCount = "Calories Left"
    @State private var showNumberKeyboard: Bool = false
    @State private var enteredCalories: String = ""



    var body: some View {
        VStack {
            Button(action:  {
                self.showDayHistoryView = true
            }) {
                Text("\(numberOfCalories)")
                    .foregroundColor(.black)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 250, height: 75)
                
                    .background(Color.gray)
                    .cornerRadius(/*@START_MENU_TOKEN@*/18.0/*@END_MENU_TOKEN@*/)
            }.sheet(isPresented: $showDayHistoryView) {
                DayHistoryView()
            }
            Text(textBelowCalorieCount)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            Button(action: {
                self.focusedField = .field
                self.showNumberKeyboard = true
            }) {
                Image(systemName: "plus")
                    .frame(width: 50, height: 50)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.black)
            }
            .background(Color.gray)
            .cornerRadius(18.0)
            .padding()
            .sheet(isPresented: $showNumberKeyboard) {
                VStack {
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
                            .focused($focusedField, equals: .field)
                            .keyboardType(.numberPad)
                            .font(.title)
                            .fontWeight(.semibold)
                            .background(Color.green)
                            Button(action: {
                                numberOfCalories -= Int(enteredCalories) ?? 0
                                self.showNumberKeyboard = false
                                enteredCalories = ""
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
                    .frame(width: 200, height: 200)
                    .background(Color.blue)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brown)
    }
}

struct DayHistoryView: View {
    
    var body: some View {
        Text("Day History Screen")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
