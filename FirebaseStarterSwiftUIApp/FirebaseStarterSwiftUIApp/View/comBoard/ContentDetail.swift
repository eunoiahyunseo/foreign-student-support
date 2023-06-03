//
//  ContentDetail.swift
//  SwiftProject-Team6
//
//  Created by 정원준 on 2023/05/06.
//

import SwiftUI

enum AlertType: Identifiable {
    case likeConfirmation
    case status(StatusViewModel)
    
    var id: UUID {
        switch self {
        case .likeConfirmation:
            return UUID()
        case .status(let status):
            return status.id // Assuming 'id' in 'status' is of type String
        }
    }
}

struct ContentDetail: View {
    @State var isGood: Int = 0
    @State var comment: String = ""
    @State private var alertType: AlertType?
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel

    var body: some View {
        VStack {
            if !boardConfigViewModel.isLoading, let selectedPost = boardConfigViewModel.selectedPost {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        profile
                        HStack {
                            Text(selectedPost.title)
                                .font(.title2)
                                .fontWeight(.medium)
                                .padding(.bottom, 3)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Text(selectedPost.content)
                                .font(.subheadline)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        footView
                        footbtn
                    }

                    commentView

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
                            Text((boardConfigViewModel.selectedBoard?.name)!)
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


                commentTextFieldView
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity)
        .onChange(of: boardConfigViewModel.statusViewModel) { newStatus in
            if let newStatus = newStatus {
                alertType = .status(newStatus)
            }
        }
        .onAppear {
            boardConfigViewModel.fetchAllCommentsAndLikesRelatedWithCurrentPost()
        }
        
    }
}

private extension ContentDetail{
    var commentTextFieldView: some View {
        ZStack {
            TextField("댓글을 남겨보세요", text: $boardConfigViewModel.comment)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
            HStack {
                Spacer()
                Button(action: {
                    print("button activated")
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
    }

    var commentView: some View {
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
        .padding(.top, 10)
    }

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
    var footView: some View {
        HStack{
            Image(systemName: "hand.thumbsup")
                .imageScale(.small)
                .foregroundColor(.red)
                .frame(width: 18, height: 18)
                .padding(.trailing, -5)
            Text(String((boardConfigViewModel.selectedPost?.likes?.count)!))
                    .font(.footnote)
                    .foregroundColor(.red)

            Image(systemName: "bubble.left")
                .imageScale(.small)
                .foregroundColor(.blue)
                .frame(width: 18, height: 18)
                .padding(.leading, 5)
                .padding(.trailing, -5)
            Text(String((boardConfigViewModel.selectedPost?.comments?.count)!))
                .font(.footnote)
                .foregroundColor(.blue)

        }
        .padding(.bottom, 5)
    }
    var footbtn: some View {
        HStack{
            Button(action: {
                self.alertType = .likeConfirmation
                
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
                    Text("스크랩")
                        .font(.footnote)
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.bordered)
        }
        .alert(item: $alertType) { type in
            switch type {
            case .likeConfirmation:
                return Alert(title: Text("확인해주세요."),
                             message: Text("이 게시물에 공감하시겠습니까?"),
                             primaryButton: .default(Text("확인")) {
                                
                                boardConfigViewModel.addLikeToPost()
                             },
                             secondaryButton: .cancel(Text("취소")))
            case .status(let status):
                return Alert(title: Text(status.title),
                             message: Text(status.message),
                             dismissButton: .default(Text("OK"), action: {
                            if status.title == "Successful" {
                                boardConfigViewModel.initComment()
                                boardConfigViewModel.fetchAllCommentsAndLikesRelatedWithCurrentPost()
                            }
                            boardConfigViewModel.statusViewModel = nil
                    }))
            }
        }
    }
}

struct ContentDetail_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        state.currentUser = mockUser
        
        let selectedPost = mockPosts[0]
        let boardConfigViewModel = BoardConfigViewModel(
            boardAPI: BoardService(), userAPI: UserService(), state: state)
        boardConfigViewModel.selectedPost = selectedPost
        
        let board = Board(name: "영어권 게시판", description: "영어권 게시판입니다.")
        
        return ContentDetail()
            .environmentObject(UserConfigViewModel(
                boardAPI: BoardService(), userAPI: UserService(), state: state))
            .environmentObject(boardConfigViewModel)
    }
}
