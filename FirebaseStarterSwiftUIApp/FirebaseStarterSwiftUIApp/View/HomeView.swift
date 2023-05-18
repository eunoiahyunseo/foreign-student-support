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
//                Text("Welcome \(viewModel.state.currentUser?.email ?? "Not found")")
//                    .navigationBarItems(leading: Button(action: {
//                        self.isDrawerOpen.toggle()
//                    }) {
//                        Image(systemName: "sidebar.left")
//                    })
//                TabBar {
//
//                }
                
                HStack {
                    VStack {
                        Text("유학생 지원 커뮤니티")
                        Text("경북대")
                    }

                    Spacer()

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().stroke(Color.black, lineWidth: 2))
                        Image(systemName: "user")
                    }
                }
            }
            DrawerView(isOpen: self.$isDrawerOpen)
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        var state = AppState()
        return HomeView(state: state)
    }
}
