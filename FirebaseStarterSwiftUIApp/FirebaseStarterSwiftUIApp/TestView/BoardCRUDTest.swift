////
////  BoardCRUDTest.swift
////  FirebaseStarterSwiftUIApp
////
////  Created by 이현서 on 2023/05/10.
////  Copyright © 2023 iOS App Templates. All rights reserved.
////
//
//import SwiftUI
//
//
//
//struct BoardCRUDTest: View {
//    @State var contents : [Post] = []
//    var db = FireStoreAPI.inst.db
//
//    @ObservedObject var viewModel: HomeViewModel
//    @State var postId: String?
//
//    init() {
//        self.viewModel = HomeViewModel(boardAPI: BoardService(), state: AppState())
//        viewModel.state.user = User(id: "11", name: "hyunseo", email: "heart2002101@knu.ac.kr")
//    }
//
//    var body: some View {
//        VStack {
//            Button("create post") {
//                self.postId = viewModel.addPost(title: "title", content: "content")
//                print("\(postId!) post is created ")
//            }
//
//            Button("create comment") {
//                viewModel.boardAPI.saveCommentByPostId(
//                    postId: postId!,
//                    comment: Comment(commentedBy: "22", content: "comment1"))
//            }
//
//            List {
//                ForEach(contents) { content in
//                    Text(content.title)
//                }
//            }
//        }
//    }
//}
//
//struct BoardCRUDTest_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardCRUDTest()
//    }
//}
