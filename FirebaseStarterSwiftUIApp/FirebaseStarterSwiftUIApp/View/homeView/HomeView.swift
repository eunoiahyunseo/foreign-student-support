//
//  HomeView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/18/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI


enum TabItems {
    case Home, Board, User
}

struct HomeView: View {
    @State var selection = 0
    @State var shwoingUserConfigModal = false
    @State private var selected = TabItems.Home
    
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    
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
                TabView(selection: $selected) {
                    GTabView(text: "홈", image: "house", tag: .Home)
                    GTabView(text: "게시판", image: "list.bullet.clipboard", tag: .Board)
                    GTabView(text: "지도", image: "map", tag: .User)
                }
                .navigationBarItems(leading: HeaderLeadingItem, trailing: HeaderTailintItem)
                .navigationBarTitle("", displayMode: .inline)
                .accentColor(.red)
                .font(.headline)
                .onAppear() {
                    print((userConfigViewModel.state.currentUser)!)
                    UITabBar.appearance().barTintColor = .white
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if !(userConfigViewModel.state.currentUser?.isInitialInfoSet)! {
                            shwoingUserConfigModal = true
                        }
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .sheet(isPresented: $shwoingUserConfigModal) {
            UserInformationForm(
                showingModal: $shwoingUserConfigModal
            )
        }
    }
}

extension HomeView {
    struct GTabView: View {
        var text: String
        var image: String
        var tag: TabItems
        
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
