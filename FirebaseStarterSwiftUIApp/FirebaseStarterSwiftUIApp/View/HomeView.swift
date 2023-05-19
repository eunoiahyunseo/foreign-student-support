//
//  HomeView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/18/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI


struct HomeView: View {
    // 이것은 Tab View에 고유한 색인을 부여해 프로그래밍 적으로 넘어가기 위해 만든 것이다.
    @State var selection = 0
    @ObservedObject private var viewModel: HomeViewModel

    @State var shwoingUserConfigModal = false
    @ObservedObject var userConfigViewModel: UserConfigViewModel

    init(state: AppState) {
        self.viewModel = HomeViewModel(boardAPI: BoardService(), state: state)
        self.userConfigViewModel = UserConfigViewModel(boardAPI: BoardService(), state: state)
    }
    
    var body: some View {
        let HeaderTailintItem = VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .foregroundColor(.black)
                
                NavigationLink(destination: UserDetailView()) {
                    Image(systemName: "person")
                        .imageScale(.medium)
                        .foregroundColor(.black)
                }
            }
        }
        
        let HeaderLeadingItem = VStack {
            Text("유학생 지원")
                .foregroundColor(.red)
                .fontWeight(.bold)
            Text(userConfigViewModel.school)
                .font(.system(size: 20))
                .fontWeight(.heavy)
        }
        
        ZStack {
            NavigationView {
                
                TabView {
                    // tab view
                    GTabView(text: "Home", image: "house", tag: 1)
                    GTabView(text: "board", image: "list.bullet.clipboard", tag: 2)
                    GTabView(text: "user", image: "person", tag: 3)
                }
                .navigationBarItems(leading: HeaderLeadingItem, trailing: HeaderTailintItem)
                .navigationBarTitle("", displayMode: .inline)
                .accentColor(.red)
                .font(.headline)
                .onAppear() {
                    UITabBar.appearance().barTintColor = .white
                    // Home화면이 나타날 때마다 유효성을 검사한다.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        print("chekc initialInfoSet -> \(viewModel.isInitialInfoSet)")
                        if !viewModel.isInitialInfoSet {
                            shwoingUserConfigModal = true
                        }
                    }
                }
                
            }
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .sheet(isPresented: $shwoingUserConfigModal) {
            UserInformationForm(
                showingModal: $shwoingUserConfigModal,
                userConfigViewModel: userConfigViewModel,
                homeViewModel: viewModel
            )
        }
    }
}

extension HomeView {
    struct GTabView: View {
        var text: String
        var image: String
        var tag: Int
        
        var body: some View {
            ScrollView {
                Text(text)
            }
            .tabItem {
                Label(text, systemImage: image)
            }
            .tag(tag)
        }
    }
}

struct UserDetailView: View {
    var body: some View {
        Text("User detail view")
            .navigationBarTitle("내 정보")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        state.currentUser = User(email: "123@gmail.com")
        return HomeView(state: state)
    }
}
