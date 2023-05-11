//
//  HomeView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/18/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var isDrawerOpen: Bool = false
    @ObservedObject private var viewModel: HomeViewModel

    
    init(state: AppState) {
        self.viewModel = HomeViewModel(boardAPI: BoardService(), state: state)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                Text("Welcome \(viewModel.state.currentUser?.email ?? "Not found")")
                    .navigationBarItems(leading: Button(action: {
                        self.isDrawerOpen.toggle()
                    }) {
                        Image(systemName: "sidebar.left")
                    })
            }
            DrawerView(isOpen: self.$isDrawerOpen)
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}
