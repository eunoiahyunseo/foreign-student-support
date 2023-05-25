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

enum tabInfo: String, CaseIterable {
    case board = "게시판"
    case info = "공지"
    case community = "커뮤니티"
}

struct HomeView: View {
    @State var selection = 0
    @State private var selected = TabItems.Home
    @State var shwoingUserConfigModal = false

    @EnvironmentObject var userConfigViewModel: UserConfigViewModel

    var body: some View {
//        NavigationView {
            ZStack {
                TabView(selection: $selected) {
                    HomeTabView(text: "홈", image: "house", tag: .Home,
                                shwoingUserConfigModal: $shwoingUserConfigModal)
                    BoardTabView(text: "게시판", image: "list.bullet.clipboard", tag: .Board)
                    GTabView(text: "지도", image: "map", tag: .User)
                }
                .accentColor(.red)
                .font(.headline)
                .onAppear() {
                    UITabBar.appearance().barTintColor = .white
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if !(userConfigViewModel.state.currentUser?.isInitialInfoSet)! {
                            shwoingUserConfigModal = true
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
//        }
//        .navigationViewStyle(.stack)
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

struct HomeTabView: View {
    var text: String
    var image: String
    var tag: TabItems
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @Binding var shwoingUserConfigModal: Bool
    
 
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
        
        return NavigationView {
            ScrollView {
                Text(text)
            }
            .navigationBarItems(leading: HeaderLeadingItem, trailing: HeaderTailintItem)
            .navigationBarTitle("", displayMode: .inline)
        }
        .tabItem {
            Label(text, systemImage: image)
        }
        .tag(tag)
    }
}

struct BoardTabView: View {
    @State private var selectedPicker: tabInfo = .board
    @Namespace private var animation
    // 상세 뷰의 가시성을 추적하기 위함임
    @State private var isDetailViewVisible = false
    
    var text: String
    var image: String
    var tag: TabItems
    
    var body: some View {
        
        VStack {
            if !isDetailViewVisible {
                animate()
            }
            
            BoardTabInnerView(tests: selectedPicker, isDetailViewVisible: $isDetailViewVisible
            )
        }
        .tabItem {
            Label(text, systemImage: image)
        }
        .tag(tag)
    }
    
    @ViewBuilder
    private func animate() -> some View {
        HStack {
            ForEach(tabInfo.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.title3)
                        .frame(maxWidth: .infinity / 4, minHeight: 30)
                        .foregroundColor(selectedPicker == item ? .red : .gray)
                    
                    if selectedPicker == item {
                        Capsule()
                            .foregroundColor(.red)
                            .frame(height: 4)
                            .matchedGeometryEffect(id: "info", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        state.currentUser = mockUser
        
        return NavigationView {
            HomeView()
                .environmentObject(UserConfigViewModel(
                    boardAPI: BoardService(), userAPI: UserService(), state: state))
        }
    }
        
        
}
