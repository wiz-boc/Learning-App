//
//  Learning_appApp.swift
//  Learning-app
//
//  Created by wizz on 7/16/21.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
