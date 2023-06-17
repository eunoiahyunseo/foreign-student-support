import SwiftUI

struct boardmain: View {
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel

    @State var isActive: Bool = false
    @State var isShownFullScreenCover = false
    @State var doAccuse = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    if boardConfigViewModel.isLoading  {
                        ProgressView()
                    } else {
                        if let posts = boardConfigViewModel.posts {
                            List(posts) { content in
                                Button(action: {
                                    boardConfigViewModel.selectedPost = content
                                    self.isActive = true
                                }) {
                                    ContentRow(content: content)
                                }
                            }
                            .listStyle(PlainListStyle())
                            .background(
                                Group {
                                    if let _ = boardConfigViewModel.selectedPost {
                                        NavigationLink(
                                            destination: ContentDetail(),
                                            isActive: $isActive) {
                                            EmptyView()
                                        }
                                        .hidden()
                                    }
                                }
                            )
                        }
                    }
                }
                .navigationBarItems(trailing: Menu{
                    Button("새로고침", action: {
                        print("i am here")
                    })
                    Button("글 쓰기", action: {
                        isShownFullScreenCover = true
                    })
                    .fullScreenCover(isPresented: $isShownFullScreenCover) {
                        PostCreatingCover(isShownFullScreenCover: $isShownFullScreenCover)
                    }
                    Button("신고", action: {
                        self.doAccuse = true
                    })
                    .alert(isPresented: $doAccuse) {
                        Alert(title: Text("이 이용자를 정말 신고하시겠습니까"), primaryButton: .destructive(Text("확인"), action: {
                            //
                        }), secondaryButton: .cancel(Text("취소")))
                    }
                } label: {
                    Label("", systemImage: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.black)}
                )
                .navigationBarItems(trailing: Button(action: {
                    //검색 버튼액션
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
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
            // selectedBoard와 관련있는 것만 fetch해와야 한다. 이는 당연히 boardDetail에도 뿌려줄 것이라
            // PostDTO로 가져와야 한다.
            boardConfigViewModel.fetchAllPostsInBoard()
        }
    }
}

struct PostCreatingCover: View {
    enum Field: Hashable {
        case title, content
    }
    
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
    @Binding var isShownFullScreenCover: Bool
    @State var isShownCultureAlert : Bool = false
    @State var sensitive_res : String = "응답을 기다리는 중..."
    @FocusState private var focusField: Field?
    
    var chatGPT = ChatGPTAPI(apiKey : "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")

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
                    .focused($focusField, equals: .title)
                    .submitLabel(.next)

                Divider()

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $boardConfigViewModel.content)
                        .opacity(boardConfigViewModel.content.isEmpty ? 0.25 : 1)
                        .background(Color.clear)
                        .focused($focusField, equals: .content)
                        .submitLabel(.return)
                        .onTapGesture {
                            hideKeyboard()
                        }
                    if boardConfigViewModel.content.isEmpty {
                        Text("내용을 입력해주세요")
                            .foregroundColor(.gray)
                            .padding(.all, 8)
                            .onTapGesture {
                                focusField = .content
                            }
                    }
                }
            }
            .padding()
            .onSubmit {
                if focusField == .title{
                    focusField = .content
                }
            }

        }
        .alert(item: $boardConfigViewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: {
                if status.title == "Successful" {
                    boardConfigViewModel.initField()
                    isShownFullScreenCover = false
                    boardConfigViewModel.fetchAllPostsInBoard()
                }
                boardConfigViewModel.statusViewModel = nil
            }))
        }

        Button {
            isShownCultureAlert = true
            sensitive_res = "응답을 기다리는 중..."
            Task() {
                let question : String = "영어권, 불어권, 일본, 한국, 아랍에서 문화적으로 문제가 될만한 내용을 알려줘 '" + boardConfigViewModel.content + "'"
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

//struct boardmain_Previews: PreviewProvider {
//    static var previews: some View {
//        let state = AppState()
//        state.currentUser = mockUser
//
//        let board = Board(name: "영어권 게시판", description: "영어권 게시판입니다.")
//
//        return boardmain()
//            .environmentObject(UserConfigViewModel(
//                boardAPI: BoardService(), userAPI: UserService(), state: state))
//            .environmentObject(BoardConfigViewModel(
//                boardAPI: BoardService(), userAPI: UserService(), state: state))
//
//    }
//}
