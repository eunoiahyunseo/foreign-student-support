//
//  BoardTabVIew.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/23.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

let sectionData: [String] = ["바로가기", "게시판 목록"]
let utilData: [String] = ["내가 쓴 글", "댓글 단 글", "HOT 게시판", "BEST 게시판"]
let boardData: [String] = ["영어권 게시판", "불어권 게시판", "일본인 게시판", "한국인 게시판", "아랍권 게시판", "전 세계 밥 게시판"]
let boardDescription = ["영어권 학우들을 위한 게시판입니다", "불어권 학우들을 위한 게시판입니다", "일본인 학우들을 위한 게시판입니다", "한국인 학우들을 위한 게시판입니다.", "아랍권 학우들을 위한 게시판입니다", "모든 문화권의 식사와 관련된 게시판입니다."]

struct BoardTabInnerView: View {
    var tests: tabInfo
    
    @State private var index = 1
    @State private var isShowing = false
    // NavigationLink를 타고 갈 떄 onAppear에서 true로 설정해주어야 함
    @Binding var isDetailViewVisible: Bool

    
    var body: some View {
        VStack {
            switch tests {
            case .board:
                VStack(alignment: .leading) {
                    List {
                        ForEach(boardData.indices, id: \.self) { index in
                            VStack {
                                BoardRow(boardName: boardData[index], boardDescription: boardDescription[index])
                                NavigationLink(destination: boardmain(board: boardData[index])
                                    .onAppear {
                                        self.isDetailViewVisible = true
                                    }
                                    .onDisappear {
                                        self.isDetailViewVisible = false
                                    }) {
                                }
                                .frame(width: 0).opacity(0)
                            }
                            .navigationBarTitle("", displayMode: .inline)
                            .listRowSeparator(.hidden)
                        }
                    }
//                    .frame(height: 1500)
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
    var boardName: String
    var boardDescription: String // Assuming you have a description variable
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 0) {
                Image(systemName: "pin")
                    .imageScale(.small)
                    .rotationEffect(.degrees(45))
                    .padding(.trailing)
                Text(boardName)
            }
            HStack {
                Spacer()
                Image(systemName: "info")
                    .imageScale(.small)
//                    .foregroundColor(.green)
                Text(boardDescription)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 10)
    }
}
struct BoardTabInnerView_Previews: PreviewProvider {
    static var previews: some View {
        BoardTabInnerView(tests: .board, isDetailViewVisible: .constant(false))
    }
}
