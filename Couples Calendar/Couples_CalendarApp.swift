//
//  Couples_CalendarApp.swift
//  Couples Calendar
//
//  Created by Denis Bielat on 9/22/25.
//

import SwiftUI

@main
struct Couples_CalendarApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
    }
}
