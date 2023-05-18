//
//  TapBar.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/18.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        Text("Home")
    }
}

struct BulletinBoardTabView: View {
    var body: some View {
        Text("Bulletin Board")
    }
}

struct NotificationsTabView: View {
    var body: some View {
        Text("Notifications")
    }
}

struct TapBar<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        TabView {
            content
        }
        .accentColor(.pink)
    }
}

struct TapBar_Previews: PreviewProvider {
    static var previews: some View {
        TapBar {
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            BulletinBoardTabView()
                .tabItem {
                    Label("Board", systemImage: "doc.text")
                }

            NotificationsTabView()
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                }
        }
    }
}
