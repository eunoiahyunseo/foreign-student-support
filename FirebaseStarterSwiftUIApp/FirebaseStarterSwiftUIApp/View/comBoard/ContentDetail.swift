//
//  ContentDetail.swift
//  SwiftProject-Team6
//
//  Created by 정원준 on 2023/05/06.
//

import SwiftUI

struct ContentDetail: View {
    let content: Post
    @State var isGood: Int = 0
    @State var comment: String = ""
    let board: String
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel

    var body: some View {
        VStack(alignment: .leading) {
            profile
            //.padding([.leading, .top], 15)
            //.padding([.trailing, .bottom], 5)
            Text(content.title)
                .font(.title2)
                .fontWeight(.medium)
                .padding(.bottom, 3)
            Text(content.content)
                .font(.subheadline)
                //.padding([.leading, .bottom], 15)
            footView
            footbtn
            Spacer()
            ZStack{
                TextField("댓글을 남겨보세요", text: $comment)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                HStack{
                    Spacer()
                    Button(action: {
                        //댓글 작성후 액션
                    }) {
                        Image(systemName: "paperplane")
                            .padding(.trailing, 12)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            //설정 버튼액션
        }, label: {
            Image(systemName: "ellipsis")
            .rotationEffect(.degrees(90))})
            .foregroundColor(.black))
        .navigationBarItems(trailing: Button(action: {
            //검색 버튼액션
        }, label: {
            Image(systemName: "magnifyingglass")
        }))
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(board)
                        .font(.headline)
                    Text((userConfigViewModel.state.currentUser?.school)!)
                        .font(.footnote)
                        .foregroundColor(Color.secondary)

                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.leading, 15)
        .padding([.top, .trailing])
        .padding(.bottom, 7)
        
        
    }
}

private extension ContentDetail{
    var profile: some View{
        HStack{
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            VStack{
                Text("익명")
                    .font(.headline)
                    .fontWeight(.heavy)
                Text("05/05 13:14")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom, 5)
    }
    var footView: some View{
        HStack{
            Image(systemName: "hand.thumbsup")
                .imageScale(.small)
                .foregroundColor(.red)
                .frame(width: 18, height: 18)
                .padding(.trailing, -5)
            Text(String(content.likes.count))
                .font(.footnote)
                .foregroundColor(.red)
            Image(systemName: "bubble.left")
                .imageScale(.small)
                .foregroundColor(.blue)
                .frame(width: 18, height: 18)
                .padding(.leading, 5)
                .padding(.trailing, -5)
            Text(String((content.comments?.count)!))
                .font(.footnote)
                .foregroundColor(.blue)
            Image(systemName: "star")
                .imageScale(.small)
                .foregroundColor(.yellow)
                .frame(width: 18, height: 18)
                .padding(.leading, 5)
                .padding(.trailing, -5)
        }
        .padding(.bottom, 5)
    }
    var footbtn: some View{
        HStack{
            Button(action: {

            }) {
                HStack {
                    Image(systemName: "hand.thumbsup")
                        .imageScale(.small)
                        .foregroundColor(.gray)
                        .frame(width: 18, height: 18)
                        .padding(.trailing, -5)
                    Text("공감")
                        .font(.footnote)
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.bordered)
            Button(action: {

            }) {
                HStack {
                    Image(systemName: "star")
                        .imageScale(.small)
                        .foregroundColor(.gray)
                        .frame(width: 18, height: 18)
                        .padding(.trailing, -5)
                    Text("공감")
                        .font(.footnote)
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

struct ContentDetail_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        state.currentUser = mockUser
        
        return ContentDetail(content: mockPosts[0], board: "대구캠 자유게시판")
            .environmentObject(UserConfigViewModel(
                boardAPI: BoardService(), userAPI: UserService(), state: state))
    }
}
