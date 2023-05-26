import SwiftUI

struct boardmain: View {
    let board: String
    let contentSamples: [Post] = mockPosts
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @State var selectedPost: Post = mockPosts[0]
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel

    @State var isActivated: Bool = false
    @State var isShownFullScreenCover = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    if boardConfigViewModel.isLoading  {
                        ProgressView()
                    } else {
                        if let posts = boardConfigViewModel.posts {
                            List {
                                ForEach(posts) { content in
                                    NavigationLink(destination: ContentDetail(content: content, board: board)) {
                                        ContentRow(content: content)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
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
                .navigationBarTitle("", displayMode: .inline)

                Button(action: {
                    isShownFullScreenCover = true
                }) {
                    HStack(spacing: 0) {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.medium)
                            .foregroundColor(.pink)
                        Text("글 쓰기")
                            .foregroundColor(.black)
                            .padding()
                    }
                    .padding(.horizontal, 10)
                    .background(Color.primary.colorInvert())
                    .cornerRadius(20)
                    .shadow(color: .primary.opacity(0.33), radius: 1.4, x: 1, y: 1)
                }
                .padding()
                .position(x: geometry.size.width/2, y: geometry.size.height - 40)
                .fullScreenCover(isPresented: $isShownFullScreenCover) {
                    PostCreatingCover(isShownFullScreenCover: $isShownFullScreenCover)
                }
            }
        }
        .onAppear {
            boardConfigViewModel.fetchAllPosts()
        }
    }
}

struct PostCreatingCover: View {
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
    @Binding var isShownFullScreenCover: Bool
    @State var isShownCultureAlert : Bool = false
    @State var sensitive_res : String = "응답을 기다리는 중..."
    
    var chatGPT = ChatGPTAPI(apiKey : "secret-key")

    var body: some View {
        VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        isShownFullScreenCover = false
                        boardConfigViewModel.initField()
                    }) {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("글 쓰기")
                        .font(.headline)
                        .fontWeight(.bold)
                        .offset(x: 10)
                    Spacer()
                    Button(action: {
                        if !boardConfigViewModel.isValid {
                            boardConfigViewModel.statusViewModel = .postCreationFailureStatus
                        } else {
                            boardConfigViewModel.createPost()
                        }
                    }) {
                        Text("완료")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .foregroundColor(.white)
                            .background(.red)

                    }

                    .cornerRadius(20)
                    .shadow(color: .primary.opacity(0.33), radius: 1.4, x: 1, y: 1)
                }
                .padding()


            VStack {
                TextField("제목", text: $boardConfigViewModel.title)
                    .padding(.all, 8)

                Divider()

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $boardConfigViewModel.content)
                        .opacity(boardConfigViewModel.content.isEmpty ? 0.25 : 1)
                        .background(Color.clear)
                    if boardConfigViewModel.content.isEmpty {
                        Text("내용을 입력해주세요")
                            .foregroundColor(.gray)
                            .padding(.all, 8)
                    }
                }
            }
            .padding()

        }
        .alert(item: $boardConfigViewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: {
                if status.title == "Successful" {
                    boardConfigViewModel.initField()
                    isShownFullScreenCover = false
                    boardConfigViewModel.fetchAllPosts()
                }
            }))
        }

        Button {
            isShownCultureAlert = true
            sensitive_res = "응답을 기다리는 중..."
            Task() {
                var question : String = "영어권, 불어권, 일본, 한국, 아랍에서 문화적으로 문제가 될만한 내용을 알려줘 '" + boardConfigViewModel.content + "'"
                sensitive_res = try! await chatGPT.sendMessage(question)
            }
        } label: {
            Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
        }
        .alert(isPresented: $isShownCultureAlert) {
            Alert(title: Text("문화적 민감정보 확인"), message: Text(sensitive_res),
                  dismissButton: .default(Text("확인")))
        }
    }
}

struct boardmain_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        state.currentUser = mockUser

        return boardmain(board: "대구캠 자유게시판")
            .environmentObject(UserConfigViewModel(
                boardAPI: BoardService(), userAPI: UserService(), state: state))
            .environmentObject(BoardConfigViewModel(
                boardAPI: BoardService(), userAPI: UserService(), state: state))

    }
}
