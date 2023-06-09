//
//  HomeView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/18/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI
import NMapsMap


enum TabItems {
    case Home, Board, User
}

enum tabInfo: String, CaseIterable {
    case board = "게시판"
    case info = "공지"
    //case community = "커뮤니티"
}

struct HomeView: View {
    @State var selection = 0
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selected = TabItems.Home
    @State var shwoingUserConfigModal = false
    @State var isLogoutProcessing = false

    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
    
    init(){
        UITabBar.appearance().scrollEdgeAppearance = .init()
    }
    
    var body: some View {
        
            ZStack {
                TabView(selection: $selected) {
                    HomeTabView(text: "홈", image: "house", tag: .Home,
                                shwoingUserConfigModal: $shwoingUserConfigModal,
                                isLogoutProcessing: $isLogoutProcessing, selected: $selected)
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

//extension HomeView {
//    struct GTabView: View {               n
//        var text: String
//        var image: String
//        var tag: TabItems
//
//        var body: some View {
//            ScrollView {
//                Text(text)
//            }
//            .tabItem {
//                Label(text, systemImage: image)
//            }
//            .tag(tag)
//        }
//    }
//}

struct GTabView: View {
    var text: String
    var image: String
    var tag: TabItems
    @State private var sendMsg = false
    @State var name = ""
    @ObservedObject var locationManager = LocationManager()

    var body: some View {
        MapView(sendMsg: $sendMsg, name: $name)
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $sendMsg, content: {
            SendMsgView(sendMsg: $sendMsg, name: $name)
        })
        .tabItem {
            Label(text, systemImage: image)
        }
        .tag(tag)
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
        VStack(alignment: .leading) {
            Text(post.board.name)
                .bold()
            
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
        .padding(10)
        .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 1)
                    .shadow(color: .gray, radius: 2)
            )
        
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
    @Binding var selected: TabItems
    
    @State var isActive: Bool = false
    @State private var isRefreshing = false // For refresh control
    @State private var isLinkActive = false
 
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
                let topRatedPosts = boardConfigViewModel.topRatedPosts,
                let boardData = boardConfigViewModel.boards {
            RefreshableScrollView(onRefresh: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    boardConfigViewModel.getAllBoardsWithPinnedInfo()
                    boardConfigViewModel.getTopPosts()
                    self.isRefreshing = false
                }
            }) {
                List {
                    adminPostsView()
                        .padding(.top,8).padding(.leading, 8).padding(.trailing, 8)
                        .listRowSeparator(.hidden)
                        .padding(.horizontal, -10)
                        .padding(.bottom, -10)
                    
                    LinkCollectionView()
                        .padding(.horizontal, -10)
                        //.padding(.top, -40)
                        .padding(.bottom)
                        .listRowSeparator(.hidden)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("실시간 인기글")
                            .font(.system(size: 20))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 20)
                        
                        VStack {
                            GeometryReader { proxy in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(topRatedPosts) { post in
                                            NavigationLink(destination: ContentDetail(), isActive: $isActive) {
                                                TopRatedView(post: post)
                                                    .foregroundColor(.black)
                                                    .onTapGesture {
                                                        boardConfigViewModel.selectedPost = post
                                                        self.isActive = true
                                                    }
                                            }
                                        }
                                        .frame(width: proxy.size.width)
                                    }
                                }
                                .onAppear{ UIScrollView.appearance().isPagingEnabled = true }
                                
                            }
                        }
                        .frame(height: 150)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .padding(.horizontal, -10)
                    //.padding(.top, -20)
                    .padding(.vertical, -2)
                    .listRowSeparator(.hidden)
                    
                    //즐겨찾는 게시판 뷰
                    VStack(alignment: .leading) {
                        HStack{
                            HStack {
                                Image(systemName: "star")
                                    .imageScale(.medium)
                                    .foregroundColor(.yellow)
                                    .frame(width: 18, height: 18)
//                                    .padding(.trailing, -5)
                                
                                Text("즐겨찾는 게시판")
                                    .font(.body)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                            Button(action: {
                                selected = TabItems.Board
                            }) {
                                HStack(spacing: 0){
                                    Text("더보기")
                                        .font(.body)
                                        .padding(.trailing, 4)
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                            }
                        }
                        .padding(.bottom, -25)
                        
                        VStack {
                            ForEach(boardData.indices, id: \.self) { idx in
                                if boardData[idx].isPinned {
                                    ZStack{
                                        favorRow(boardData: boardData[idx])
                                            .foregroundColor(.black)
                                            .onTapGesture {
                                                isLinkActive = true
                                                boardConfigViewModel.selectedBoard = boardData[idx]
                                            }
                                        NavigationLink(destination: boardmain(), isActive: $isLinkActive) {
                                        }.opacity(0.0)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(10)
                        
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, -10)
                    .padding(.vertical, -2)
                    .listRowSeparator(.hidden)

                    EmptyView().frame(height:200)
                    
                    AdLinkCollectionView()
                        .frame(height : 300)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .padding(.horizontal, -10)
                        .padding(.vertical, -2)
                        .listRowSeparator(.hidden)
                    
                }.listStyle(PlainListStyle())
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
                    .animation(.easeInOut(duration: 0.3))
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
        .transition(.slide)
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
