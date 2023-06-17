//
//  MyPostsView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 한의진 on 2023/06/17.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//
//
//import SwiftUI
//
//struct MyPostsView: View {
//    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
//    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
//
//    @State var isActive: Bool = false
//    @State var isShownFullScreenCover = false
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                VStack {
//                    if boardConfigViewModel.isLoading  {
//                        ProgressView()
//                    } else {
//                        if let posts = boardConfigViewModel.posts {
//                            List(posts) { content in
//                                Button(action: {
//                                    boardConfigViewModel.selectedPost = content
//                                    self.isActive = true
//                                }) {
//                                    ContentRow(content: content)
//                                }
//                            }
//                            .listStyle(PlainListStyle())
//                            .background(
//                                Group {
//                                    if let _ = boardConfigViewModel.selectedPost {
//                                        NavigationLink(
//                                            destination: ContentDetail(),
//                                            isActive: $isActive) {
//                                            EmptyView()
//                                        }
//                                        .hidden()
//                                    }
//                                }
//                            )
//                        }
//                    }
//                }
//                .navigationBarItems(trailing: Menu{
//                    Button("새로고침", action: {
//                        print("i am here")
//                    })
//                    Button("글 쓰기", action: {
//                        isShownFullScreenCover = true
//                    })
//                    .fullScreenCover(isPresented: $isShownFullScreenCover) {
//                        MyPostCreatingCover(isShownFullScreenCover: $isShownFullScreenCover)
//                    }
//                    Button("신고", action: {
//                        //
//                    })
//                } label: {
//                    Label("", systemImage: "ellipsis")
//                        .rotationEffect(.degrees(90))
//                        .foregroundColor(.black)}
//                )
//                .navigationBarItems(trailing: Button(action: {
//                    //검색 버튼액션
//                }, label: {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.black)
//                }))
//                .toolbar {
//                    ToolbarItem(placement: .principal) {
//                        VStack {
//                            Text((boardConfigViewModel.selectedBoard?.name)!)
//                                .font(.headline)
//                            Text((userConfigViewModel.state.currentUser?.school)!)
//                                .font(.footnote)
//                                .foregroundColor(Color.secondary)
//
//                        }
//                    }
//                }
//                .navigationBarTitle("", displayMode: .inline)
//
//                Button(action: {
//                    isShownFullScreenCover = true
//                }) {
//                    HStack(spacing: 0) {
//                        Image(systemName: "square.and.pencil")
//                            .imageScale(.medium)
//                            .foregroundColor(.pink)
//                        Text("글 쓰기")
//                            .foregroundColor(.black)
//                            .padding()
//                    }
//                    .padding(.horizontal, 10)
//                    .background(Color.primary.colorInvert())
//                    .cornerRadius(20)
//                    .shadow(color: .primary.opacity(0.33), radius: 1.4, x: 1, y: 1)
//                }
//                .padding()
//                .position(x: geometry.size.width/2, y: geometry.size.height - 40)
//                .fullScreenCover(isPresented: $isShownFullScreenCover) {
//                    MyPostCreatingCover(isShownFullScreenCover: $isShownFullScreenCover)
//                }
//            }
//        }
//        .onAppear {
//            // selectedBoard와 관련있는 것만 fetch해와야 한다. 이는 당연히 boardDetail에도 뿌려줄 것이라
//            // PostDTO로 가져와야 한다.
//            boardConfigViewModel.fetchAllPostsInBoard()
//        }
//    }
//}
//
//struct MyPostCreatingCover: View {
//    enum Field: Hashable {
//        case title, content
//    }
//
//    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
//    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
//    @Binding var isShownFullScreenCover: Bool
//    @State var isShownCultureAlert : Bool = false
//    @State var sensitive_res : String = "응답을 기다리는 중..."
//    @FocusState private var focusField: Field?
//
//    var chatGPT = ChatGPTAPI(apiKey : "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")
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Button(action: {
//                    isShownFullScreenCover = false
//                    boardConfigViewModel.initField()
//                }) {
//                    Image(systemName: "xmark")
//                        .imageScale(.medium)
//                        .foregroundColor(.black)
//                }
//                Spacer()
//                Text("글 쓰기")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                    .offset(x: 10)
//                Spacer()
//                Button(action: {
//                    if !boardConfigViewModel.isValid {
//                        boardConfigViewModel.statusViewModel = .postCreationFailureStatus
//                    } else {
//                        boardConfigViewModel.createPost()
//                    }
//                }) {
//                    Text("완료")
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 5)
//                        .foregroundColor(.white)
//                        .background(.red)
//
//                }
//
//                .cornerRadius(20)
//                .shadow(color: .primary.opacity(0.33), radius: 1.4, x: 1, y: 1)
//            }
//            .padding()
//
//
//            VStack {
//                TextField("제목", text: $boardConfigViewModel.title)
//                    .padding(.all, 8)
//                    .focused($focusField, equals: .title)
//                    .submitLabel(.next)
//
//                Divider()
//
//                ZStack(alignment: .topLeading) {
//                    TextEditor(text: $boardConfigViewModel.content)
//                        .opacity(boardConfigViewModel.content.isEmpty ? 0.25 : 1)
//                        .background(Color.clear)
//                        .focused($focusField, equals: .content)
//                        .submitLabel(.return)
//                        .onTapGesture {
//                            //hideKeyboard()
//                        }
//                    if boardConfigViewModel.content.isEmpty {
//                        Text("내용을 입력해주세요")
//                            .foregroundColor(.gray)
//                            .padding(.all, 8)
//                            .onTapGesture {
//                                focusField = .content
//                            }
//                    }
//                }
//            }
//            .padding()
//            .onSubmit {
//                if focusField == .title{
//                    focusField = .content
//                }
//            }
//
//        }
//        .alert(item: $boardConfigViewModel.statusViewModel) { status in
//            Alert(title: Text(status.title),
//                  message: Text(status.message),
//                  dismissButton: .default(Text("OK"), action: {
//                if status.title == "Successful" {
//                    boardConfigViewModel.initField()
//                    isShownFullScreenCover = false
//                    boardConfigViewModel.fetchAllPostsInBoard()
//                }
//                boardConfigViewModel.statusViewModel = nil
//            }))
//        }
//
//        Button {
//            isShownCultureAlert = true
//            sensitive_res = "응답을 기다리는 중..."
//            Task() {
//                let question : String = "영어권, 불어권, 일본, 한국, 아랍에서 문화적으로 문제가 될만한 내용을 알려줘 '" + boardConfigViewModel.content + "'"
//                sensitive_res = try! await chatGPT.sendMessage(question)
//            }
//        } label: {
//            Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
//        }
//        .alert(isPresented: $isShownCultureAlert) {
//            Alert(title: Text("문화적 민감정보 확인"), message: Text(sensitive_res),
//                  dismissButton: .default(Text("확인")))
//        }
//    }
//}
//

import SwiftUI
struct PostElementType: Identifiable {
    var id: Int
    var title: String
    var content: String
}
struct MyPostsView: View {
    @EnvironmentObject var userConfigViewModel:UserConfigViewModel
    @StateObject var boardConfigViewModel = BoardConfigViewModel(
        boardAPI: BoardService(),
        userAPI: UserService(),
        state: AppState())
    @StateObject var myPostsViewModel = MyPostsViewModel(
        userAPI: UserService(),
        allPostsService: AllPostsService(),
        state: AppState())
    @Binding var isMyPostVisible: Bool
    @EnvironmentObject var signInViewModel: SignInViewModel

    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let HeaderLeadingItem = HStack {
            Image(systemName: "chevron.left")
        }
        let HeaderTrailingItem = HStack {
            VStack {
            Text("유학생 지원")
                .foregroundColor(.red)
                .fontWeight(.bold)
            Text("내가 쓴 글")
                .font(.system(size:20))
                .fontWeight(.heavy)

            }
            .padding(screenWidth/3)
        }

        NavigationView {
            VStack {
                Spacer(minLength: 20)
                Text("내가 쓴 글")
                    .font(.system(size: 30, weight:.heavy)).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 30)

                List(myPostsViewModel.posts ?? []) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.content)
                            .font(.subheadline)
                    }
                }.onAppear(perform: {myPostsViewModel.fetchMyPosts(id: signInViewModel.state.currentUser?.id)})

                Button(action:{
                    isMyPostVisible = false
                }) {
                    Text("닫기")
                }.frame(height: 50)
                    .cornerRadius(20)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
            .padding(.top, 20)
        }
        
    }
}



//struct MyPostsView: View {
//    @EnvironmentObject var userConfigViewModel:UserConfigViewModel
//    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
//    @Binding var isMyPostVisible: Bool
//
//    var posts: [PostElementType] = [
//            PostElementType(id: 0, title: "첫 번째 글", content: "첫 번째 글의 내용입니다."),
//            PostElementType(id: 1, title: "두 번째 글", content: "두 번째 글의 내용입니다."),
//            PostElementType(id: 2, title: "세 번째 글", content: "세 번째 글의 내용입니다."),
//            PostElementType(id: 3, title: "네 번째 글", content: "네 번째 글의 내용입니다.")
//        ]
//
//
//    var body: some View {
//        let screenWidth = UIScreen.main.bounds.width
//        let HeaderLeadingItem =
//        HStack{
//            Image(systemName: "chevron.left")
//        }
//        let HeaderTrailingItem =
//        HStack{
//            VStack {
//            Text("유학생 지원")
//                .foregroundColor(.red)
//                .fontWeight(.bold)
//            Text("내가 쓴 글")
//                .font(.system(size:20))
//                .fontWeight(.heavy)
//
//            }
//            .padding(screenWidth/3)
//
//        }
//        NavigationView
//        {
//
//
//                VStack{
//                    Spacer(minLength: 20)
//                    Text("내가 쓴 글")
//                        .font(.system(size: 30, weight:.heavy)).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 30)
//
//
//
//
//
//                        List(posts) { post in
//                                        VStack(alignment: .leading) {
//                                            Text(post.title)
//                                                .font(.headline)
//                                            Text(post.content)
//                                                .font(.subheadline)
//                                        }
//
//                        }
//
//                    Button(action:{
//                        //print("닫기")
//                        isMyPostVisible = false
//                    }) {
//                        Text("닫기")
//                    }
//
//
//
//                }.frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding(.top, 20)
//
//                //            .overlay {
//                //                RoundedRectangle(cornerRadius: 20)
//                //                    .stroke(lineWidth: 2)
//                //                    .foregroundColor(.gray)
//                //
//                //            }
//                //            .padding(20)
//        }
//        .navigationBarItems(
//            leading: HeaderLeadingItem,
//                trailing: HeaderTrailingItem
//            )
//
//        }
//
//}

struct MyPostsView_Previews:
    PreviewProvider {
  

    static var previews: some View {
        let state = AppState()
        state.currentUser = mockUser

        let boardConfigViewModel = BoardConfigViewModel(
            boardAPI: BoardService(), userAPI: UserService(), state: state)
        let myPostsViewModel = MyPostsViewModel(userAPI: UserService(), allPostsService: AllPostsService(), state: state)
        //boardConfigViewModel.topRatedPosts = mockPosts
        //myPostsViewModel.allPostsService = mockPosts
        return NavigationView {
            MyPostsView(isMyPostVisible: .constant(true))
                .environmentObject(UserConfigViewModel(
                    boardAPI: BoardService(), userAPI: UserService(), state: state))
                .environmentObject(boardConfigViewModel)
        }
    }
}
