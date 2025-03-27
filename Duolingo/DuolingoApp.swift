//
//  DuolingoApp.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

//  DuolingoCloneApp.swift
import SwiftUI

@main
struct DuolingoApp: App {
    @StateObject var appState = ChineseAppState() // Create the app state here
    @State private var preferredColorScheme: ColorScheme? = nil

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.theme, preferredColorScheme == .dark ? .dark : .light) // Apply initial theme
                .preferredColorScheme(preferredColorScheme)
                .onAppear {
                    // Optionally load a user's preferred color scheme from UserDefaults
                    // let userColorScheme = UserDefaults.standard.string(forKey: "preferredColorScheme")
                    // preferredColorScheme = userColorScheme == "dark" ? .dark : .light
                }
                //.onChange(of: appState.userProgress) { _ in  //Example of saveProgress best practice
                    //appState.saveProgress()
                //}
        }
    }
}
