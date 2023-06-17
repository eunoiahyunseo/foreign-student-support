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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selected = TabItems.Home
    @State var shwoingUserConfigModal = false
    @State var isLogoutProcessing = false

    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = .init()
    }
    
    var body: some View {
        
            ZStack {
                TabView(selection: $selected) {
                    HomeTabView(text: "홈", image: "house", tag: .Home,
                                shwoingUserConfigModal: $shwoingUserConfigModal,
                                isLogoutProcessing: $isLogoutProcessing)
                    BoardTabView(text: "게시판", image: "list.bullet.clipboard", tag: .Board)
                    GTabView(text: "지도", image: "map", tag: .User)
                }
                .accentColor(.red)
                .font(.headline)
                .onAppear() {
                    // board에 대한 정보도 불러온다.
//                    boardConfigViewModel.getAllBoards()
                    boardConfigViewModel.getAllBoardsWithPinnedInfo()
                    boardConfigViewModel.getTopPosts()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if !(userConfigViewModel.state.currentUser?.isInitialInfoSet)! {
                            shwoingUserConfigModal = true
                        }
                    }
                }
            }
            .alert(isPresented: $isLogoutProcessing) {
                Alert(
                    title: Text("로그아웃"),
                    message: Text("정말로 로그아웃 하시겠습니까?"),
                    primaryButton: .default(Text("확인")) {
                        presentationMode.wrappedValue.dismiss()
                        userConfigViewModel.state.isLogoutProcessing = false
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
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

func truncateStringToTwoLines(_ str: String) -> String {
    let lines = str.split(separator: "\n", maxSplits: 2, omittingEmptySubsequences: false)

    switch lines.count {
    case 0, 1:
        return str
    case 2:
        return lines.joined(separator: "\n")
    default:
        return lines.prefix(2).joined(separator: "\n") + "..."
    }
}


struct TopRatedView: View {
    var post: PostDTO
    
    var body: some View {
        return VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                
                Text((post.user?.nickname)!)
                    .font(.system(size: 16))
                
                Spacer()
                
                Text(dateConversion(targetDate: post.timestamp))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Text(post.title)
                .font(.system(size: 16))
                .bold()
            
            Text(truncateStringToTwoLines(post.content))
                .font(.system(size: 16))
            
            HStack {
                Text(post.board.name)
                
                Spacer()
                
                Image(systemName: "hand.thumbsup")
                    .imageScale(.small)
                    .foregroundColor(.red)
                    .frame(width: 18, height: 18)
                    .padding(.trailing, -5)
                Text(String((post.likes?.count)!))
                    .font(.footnote)
                    .foregroundColor(.red)
                
                Image(systemName: "bubble.left")
                    .imageScale(.small)
                    .foregroundColor(.blue)
                    .frame(width: 18, height: 18)
                    .padding(.leading, 5)
                    .padding(.trailing, -5)
                Text(String((post.comments?.count)!))
                    .font(.footnote)
                    .foregroundColor(.blue)
                
            }
        }
        .padding(.bottom, 7)
    }
}


struct HomeTabView: View {
    var text: String
    var image: String
    var tag: TabItems
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel

    @Binding var shwoingUserConfigModal: Bool
    @Binding var isLogoutProcessing: Bool
    
    @State var isActive: Bool = false
    @State private var isRefreshing = false // For refresh control
 
    var body: some View {
        let HeaderTailintItem = VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .foregroundColor(.black)
                
                NavigationLink(destination: UserDetailView()
                    .onDisappear(perform: {
                        if userConfigViewModel.state.isLogoutProcessing {
                            isLogoutProcessing = true
                        }
                    })) {
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
            Text((userConfigViewModel.state.currentUser?.school) ?? "unknown")
                .font(.system(size: 20))
                .fontWeight(.heavy)
        }
        
        return NavigationView {
            if !boardConfigViewModel.isLoading,
               let topRatedPosts = boardConfigViewModel.topRatedPosts {
            RefreshableScrollView(onRefresh: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    boardConfigViewModel.getAllBoardsWithPinnedInfo()
                    boardConfigViewModel.getTopPosts()
                    self.isRefreshing = false
                    print("Refresh Done!")
                }
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("실시간 인기글")
                        .font(.system(size: 20))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    List {
                        ForEach(topRatedPosts) { post in
                            Button(action: {
                                boardConfigViewModel.selectedPost = post
                                self.isActive = true
                            }) {
                                TopRatedView(post: post)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .background(
                        Group {
                            if let _ = boardConfigViewModel.selectedPost {
                                NavigationLink(
                                    destination: ContentDetail(),
                                    isActive: $isActive) {
                                        EmptyView()
                                    }
                                    .hidden()
                            }
                        }
                    )
                    .frame(height: 400)
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(20)
                
            }
            .navigationBarItems(leading: HeaderLeadingItem, trailing: HeaderTailintItem)
            .navigationBarTitle("", displayMode: .inline)
            } else {
                ProgressView()
            }
            
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
            BoardTabInnerView(tests: selectedPicker, isDetailViewVisible: $isDetailViewVisible)
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
                        .frame(maxWidth: .infinity / 4, minHeight: 20)
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
        
        let boardConfigViewModel = BoardConfigViewModel(
            boardAPI: BoardService(), userAPI: UserService(), state: state)
        
        boardConfigViewModel.topRatedPosts = mockPosts
        
        return NavigationView {
            HomeView()
                .environmentObject(UserConfigViewModel(
                    boardAPI: BoardService(), userAPI: UserService(), state: state))
                .environmentObject(boardConfigViewModel)
        }
    }
}
