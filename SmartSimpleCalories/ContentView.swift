//
//  ContentView.swift
//  SmartSimpleCalories
//
//  Created by Kyle Steinicke on 1/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                SettingsView()
                    .navigationBarTitle("Settings")
            }.tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }

            NavigationView {
                HomeView()
                    .navigationBarTitle("Home")
            }.tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            NavigationView {
                GraphView()
                    .navigationBarTitle("Graph")
            }.tabItem {
                Image(systemName: "chart.bar")
                Text("Graph")
            }
        }
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings Screen")
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home Screen")
    }
}

struct GraphView: View {
    var body: some View {
        Text("Graph Screen")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
