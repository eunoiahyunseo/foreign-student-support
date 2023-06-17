//
//  FavorBoardHomeView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 정원준 on 2023/06/02.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct FavorBoardHomeView: View {
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
    @Binding var selected: TabItems
    
    var body: some View {
        //var posts = boardConfigViewModel.posts!
        VStack(alignment: .leading) {
            HStack{
                Text("즐겨찾는 게시판")
                    .font(.body)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    selected = TabItems.Board
                }) {
                    HStack(spacing: 0){
                        Text("더보기")
                            .font(.body)
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                }
            }
            .padding(.bottom, -5)
            //!boardConfigViewModel.isLoading,
            if let boardData = boardConfigViewModel.boards{
                if boardData.count < 5 {
                    ForEach(boardData.indices, id: \.self) { idx in
                        NavigationLink(destination: boardmain()) {
                            favorRow(boardData: boardData[idx])
                                .padding(.bottom, idx == boardData.count-1 ? 12 : 0)
                                .foregroundColor(.black)
                        }
                    }
                }else {
                    ForEach(0..<4){ idx in
                        NavigationLink(destination: boardmain()) {
                            favorRow(boardData: boardData[idx])
                                .padding(.bottom, idx == 3 ? 12 : 0)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 2)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct favorRow: View{
    var boardData: BoardDTO?
    //var boardName: String
    //var content: Post
    
    var body: some View{
        HStack{
            Text(boardData?.name ?? "")
                .font(.callout)
                .padding(.horizontal)
                .padding(.bottom, 5)
            Spacer()
            //Text(content.title)
        }
    }
}

//struct FavorBoardHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var selected = TabItems.Home
//        FavorBoardHomeView(selected: $selected)
//    }
//}
