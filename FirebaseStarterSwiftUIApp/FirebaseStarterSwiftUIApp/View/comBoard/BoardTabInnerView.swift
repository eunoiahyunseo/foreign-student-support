//
//  BoardTabVIew.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/23.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct BoardTabInnerView: View {
    var tests: tabInfo
    
    @State private var index = 1
    @State private var isShowing = false
    // NavigationLink를 타고 갈 떄 onAppear에서 true로 설정해주어야 함
    // NavigationLink를 타고 갈 떄 onAppear에서 true로 설정해주어야 함
    @Binding var isDetailViewVisible: Bool
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
    @State private var isLinkActive = false
    @State var posts : [AdminBoard] = []
    var adminBoardService : AdminBoardService = AdminBoardService()

    var body: some View {
        List{
            switch tests {
                //!boardConfigViewModel.isLoading,
            case .board:
                if !boardConfigViewModel.isLoading, let boardData = boardConfigViewModel.boards{
                    ForEach(boardData.indices, id: \.self) { index in
                        ZStack {
                            Button(action: {
                                isLinkActive = true
                                boardConfigViewModel.selectedBoard = boardData[index]
                            }) {
                                BoardRow(boardData: boardData[index])
                            }
                            NavigationLink(destination: boardmain()
                                .onAppear {
                                    self.isDetailViewVisible = true
                                }
                                .onDisappear {
                                    self.isDetailViewVisible = false
                                }, isActive: $isLinkActive) {
                                    EmptyView()
                                }
                                .frame(width: 0)
                                .opacity(0)
                        }
    //                    Color.primary
    //                        .opacity(0.3)
    //                        .frame(maxWidth: .infinity, maxHeight: 1)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .listRowSeparator(.hidden)
                } else {
                    ProgressView()
                }
            case .info:
                //Text("info")
//                ScrollView(.vertical, showsIndicators: false){
//                    LazyVStack{
//                        ForEach(posts) { post in
//                            adminList(title: post.title, content: post.content)
//                        }
//                    }
//                }
                ForEach(posts) { post in
                    adminList(title: post.title, content: post.content)
                }
                
            }
        }
        .onAppear{
            adminBoardService.getAllPosts(completion: { result in
                switch result{
                case .success(let boards):
                    posts = boards
                case .failure(let error):
                    print(error)
                }
                
            })
        }
        .listStyle(PlainListStyle())
    }
}

//VStack {
//    switch tests {
//    case .board:
//        if !boardConfigViewModel.isLoading, let boardData = boardConfigViewModel.boards {
//            VStack(alignment: .leading) {
//                List {
//                    ForEach(boardData.indices, id: \.self) { index in
//                        VStack {
//                            Button(action: {
//                                isLinkActive = true
//                                boardConfigViewModel.selectedBoard = boardData[index]
//                            }) {
//                                BoardRow(boardData: boardData[index])
//                            }
//                            NavigationLink(destination: boardmain()
//                                .onAppear {
//                                    self.isDetailViewVisible = true
//                                }
//                                .onDisappear {
//                                    self.isDetailViewVisible = false
//                                }, isActive: $isLinkActive) {
//                                    EmptyView()
//                                }
//                                .frame(width: 0).opacity(0)
//                        }
//                        .navigationBarTitle("", displayMode: .inline)
//                        .listRowSeparator(.hidden)
//                        .foregroundColor(.black)
//                    }
//                }
//            }
//        } else {
//            ProgressView()
//        }
//
//    case .info:
//        Text("info")
//    case .community:
//        Text("community")
//    }
//}
////.onAppear { UITableView.appearance().separatorStyle = .none }

struct BoardRow: View {
    var boardData: BoardDTO
    
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        // 우선 선택된 보드를 뷰모델에 반영해서 그 안에서 이 정보를 가지고 지지고복고를 해야할듯?
                        boardConfigViewModel.selectedBoard = boardData
                        
                        if !boardData.isPinned {
                            boardConfigViewModel.addPin()
                        } else {
                            boardConfigViewModel.removePin()
                        }
                        
                        
                    }
                }) {
                    Image(systemName: boardData.isPinned ? "pin.fill" : "pin")
                        .imageScale(.small)
                        .rotationEffect(.degrees(boardData.isPinned ? 45 : 0))
                        .foregroundColor(boardData.isPinned ? .red : .black)
                        .padding(.trailing)
                }
                Text(boardData.name)
            }
            HStack {
                Spacer()
                Image(systemName: "info")
                    .imageScale(.small)

                Text(boardData.description)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
        }
        .alert(item: $boardConfigViewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: {
                if status.title == "Successful" {
                    boardConfigViewModel.getAllBoardsWithPinnedInfo() // 갱신해준다.
                }
                boardConfigViewModel.statusViewModel = nil
            }))
        }
        .padding(.vertical, 10)
    }
}

struct BoardTabInnerView_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        state.currentUser = mockUser
        
        return BoardTabInnerView(tests: .board, isDetailViewVisible: .constant(false))
            .environmentObject(BoardConfigViewModel(
                boardAPI: BoardService(), userAPI: UserService(), state: state))
    }
}
