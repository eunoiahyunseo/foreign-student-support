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
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel

    var body: some View {
        VStack {
            if !boardConfigViewModel.isLoading {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        profile
                        Text(content.title)
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.bottom, 3)
                        Text(content.content)
                            .font(.subheadline)
                        footView
                        footbtn
                        ForEach((boardConfigViewModel.selectedPost?.comments)!) { comment in
                            VStack(alignment: .leading) {
                                HStack {
                                    HStack {
                                        Image(systemName: "person.crop.square.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.gray)
                                        Text(comment.commentedUser)
                                            .font(.system(size: 14))
                                    }
                                    Spacer()
                                    HStack {
                                        Group {
                                            Button(action: {}) {
                                                Image(systemName: "hand.thumbsup")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 10, height: 10)
                                            }
                                            
                                            Text("|")
                                            
                                            Button(action: {}) {
                                                Image(systemName: "ellipsis")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .rotationEffect(.degrees(90))
                                                    .frame(width: 10, height: 10)
                                            }
                                        }
                                        .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 3)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                Text(comment.content)
                                    .font(.system(size: 16))
                                Text(dateConversion(targetDate: comment.timestamp))
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                
                                Divider()
                                
                            }
                            .padding(.bottom, 10)
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
                
                
                ZStack{
                    TextField("댓글을 남겨보세요", text: $boardConfigViewModel.comment)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                    HStack{
                        
                        Spacer()
                        Button(action: {
                            print("button activated")
                            // comment가 비어있으면 API호출을 할 수 없다.
                            if boardConfigViewModel.comment.isEmpty {
                                boardConfigViewModel.statusViewModel = .commentCreationFailureStatus
                            } else {
                                boardConfigViewModel.addCommentToPost()
                            }
                        }) {
                            Image(systemName: "paperplane")
                                .padding(.trailing, 12)
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(10)
                .offset(y: -10)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            // 뷰가 appear될 때 딱 한번만 댓글을 로드해온다.
            boardConfigViewModel.fetchAllCommentsRelatedWithCurrentPost()
        }
        
        
    }
}

private extension ContentDetail{
    func dateConversion(targetDate: Date) -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "MM-dd HH:mm"
        let dateString = formmater.string(from: targetDate)
        return dateString
    }
    
    var profile: some View{
        HStack{
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            VStack(alignment: .leading) {
                Text((boardConfigViewModel.selectedPost?.postedUser)!)
                    .font(.headline)
                    .fontWeight(.heavy)
                Text(dateConversion(targetDate: (boardConfigViewModel.selectedPost?.timestamp)!))
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
        .alert(item: $boardConfigViewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: {
                if status.title == "Successful" {
                    boardConfigViewModel.initComment()
                    boardConfigViewModel.fetchAllCommentsRelatedWithCurrentPost()
                }
            }))
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
            .environmentObject(BoardConfigViewModel(
                boardAPI: BoardService(), userAPI: UserService(), state: state))
    }
}
