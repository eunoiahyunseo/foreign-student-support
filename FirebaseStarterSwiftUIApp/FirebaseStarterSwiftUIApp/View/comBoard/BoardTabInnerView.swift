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
    @Binding var isDetailViewVisible: Bool
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
    @State private var isLinkActive = false

    var body: some View {
        VStack {
            switch tests {
            case .board:
                if !boardConfigViewModel.isLoading, let boardData = boardConfigViewModel.boards {
                    VStack(alignment: .leading) {
                        List {
                            ForEach(boardData.indices, id: \.self) { index in
                                VStack {
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
                                        .frame(width: 0).opacity(0)
                                }
                                .navigationBarTitle("", displayMode: .inline)
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
                
            case .info:
                Text("info")
            case .community:
                Text("community")
            }
        }
        .onAppear { UITableView.appearance().separatorStyle = .none }
    }
}

struct BoardRow: View {
    var boardData: Board
    @State var isPinned: Bool = false // Added this line

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        isPinned.toggle()
                    }
                }) {
                    Image(systemName: isPinned ? "pin.fill" : "pin")
                        .imageScale(.small)
                        .rotationEffect(.degrees(isPinned ? 45 : 0))
                        .foregroundColor(isPinned ? .red : .black)
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
