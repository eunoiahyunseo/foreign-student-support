import SwiftUI


struct PostElementType: Identifiable {
    var id: Int
    var title: String
    var content: String
}

struct MyPostsView: View {
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @EnvironmentObject var signInViewModel: SignInViewModel
    @EnvironmentObject var myPostViewModel: MyPostsViewModel
    
    @Binding var isMyPostVisible: Bool

    
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

                List(myPostViewModel.posts ?? []) { post in
                    ContentRow(content: post)
                }.listStyle(PlainListStyle())
                .onAppear(perform: {
                    myPostViewModel.fetchMyPosts(
                        id: (myPostViewModel.state.currentUser?.id)!)
                    
                })
                
                Button(action:{
                    withAnimation{
                        isMyPostVisible.toggle()
                    }
                }) {
                    Text("닫기")
                }.frame(height: 50)
                    .cornerRadius(20)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .trailing))
                
            .padding(.top, 20)
        }
        
    }
}
