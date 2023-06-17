//import SwiftUI
//
//
//struct PostElementType: Identifiable {
//    var id: Int
//    var title: String
//    var content: String
//}
//
//struct MyPostsView: View {
//    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
//    @EnvironmentObject var signInViewModel: SignInViewModel
//    @EnvironmentObject var myPostViewModel: MyPostsViewModel
//    @EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
//    @Binding var isMyPostVisible: Bool
//
//    @State var isActiveMyPost: Bool = false
//
//
//
//    var body: some View {
//        let screenWidth = UIScreen.main.bounds.width
//        let HeaderLeadingItem = HStack {
//            Image(systemName: "chevron.left")
//        }
//        let HeaderTrailingItem = HStack {
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
//        }
//
//        NavigationView {
//            VStack {
//
//                HStack {
//                     Button(action:{
//                         withAnimation{
//                             isMyPostVisible.toggle()
//                         }
//                     }) {
//                         Image(systemName: "chevron.left")
//                         Text("Back").fontWeight(.light)
//                         Spacer()
//                     }.frame(height: 50)
//                         .cornerRadius(20)
//                 }.padding(.top, -25)
//                     .padding(.leading, 12)
//
//                Spacer(minLength: 20)
//                Text("내가 쓴 글")
//                    .font(.system(size: 30, weight:.heavy)).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 30)
//
//
//
//
//
//                List(myPostViewModel.posts ?? []) { post in
//                    Button(action: {
//
//                        myPostViewModel.selectedPost = post
//                        boardConfigViewModel.selectedPost = post
//                        self.isActiveMyPost = true
//                    }) {
//                        ContentRow(content: post)
//                    }
//
//
//                    //ContentRow(content: post)
//
//
//
//                }.listStyle(PlainListStyle())
//                .onAppear(perform: {
//                    myPostViewModel.fetchMyPosts(
//                        id: (myPostViewModel.state.currentUser?.id)!)
//
//                }).background(
//                    Group {
//                        if let _ = myPostViewModel.selectedPost {
//                            NavigationLink(
//                                destination: MyPostsDetail().environmentObject(boardConfigViewModel),
//                                    //.environmentObject(myPostsViewModel),
//                                isActive: $isActiveMyPost) {
//                                EmptyView()
//                            }
//                            .hidden()
//                        }
//                    }
//                )
//
//
//
//
//
//
//            }.frame(maxWidth: .infinity, maxHeight: .infinity)
//                .transition(.move(edge: .trailing))
//
//            .padding(.top, 20)
//        }
//
//    }
//}



import SwiftUI
struct PostElementType: Identifiable {
    var id: Int
    var title: String
    var content: String
}
struct MyPostsView: View {
    @EnvironmentObject var userConfigViewModel:UserConfigViewModel
 
    @StateObject var myPostsViewModel = MyPostsViewModel(
        userAPI: UserService(),
        boardAPI: BoardService(),
        state: AppState())
    @Binding var isMyPostVisible: Bool
    @EnvironmentObject var signInViewModel: SignInViewModel
    @StateObject var boardConfigViewModel = BoardConfigViewModel(
        boardAPI: BoardService(),
        userAPI: UserService(),
        state: AppState())
    @State var isActiveMyPost: Bool = false

    
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
               
                
                
                HStack {
                    Button(action:{
                        withAnimation{
                            isMyPostVisible.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Back").fontWeight(.light)
                        Spacer()
                    }.frame(height: 50)
                        .cornerRadius(20)
                }.padding(.top, -25)
                    .padding(.leading, 12)
                    Text("내가 쓴 글")
                        .font(.system(size: 30, weight:.heavy)).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 30)
                
                List(boardConfigViewModel.posts ?? []) { post in
//                    VStack(alignment: .leading) {
//                        Text(post.title)
//                            .font(.headline)
//                        Text(post.content)
//                            .font(.subheadline)
//                    }
                    Button(action: {
                        boardConfigViewModel.selectedPost = post
                        self.isActiveMyPost = true
                    }) {
                        ContentRow(content: post).environmentObject(boardConfigViewModel)
                    }
                    //ContentRow(content: post)
                    
                }.listStyle(PlainListStyle())
                    .onAppear(perform: {boardConfigViewModel.fetchMyPosts(id: (signInViewModel.state.currentUser?.id)!)})
                .background(
                    Group {
                        if let _ = boardConfigViewModel.selectedPost {
                            NavigationLink(
                                destination: MyPostsDetail().environmentObject(boardConfigViewModel)
                                    .environmentObject(signInViewModel),
                                isActive: $isActiveMyPost) {
                                EmptyView()
                            }
                            .hidden()
                        }
                    }
                )
                

             
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .trailing))
                
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
            boardAPI: BoardService(), userAPI: UserService(), state: AppState())
        let myPostsViewModel = MyPostsViewModel(userAPI: UserService(), boardAPI: BoardService(), state: state)
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
