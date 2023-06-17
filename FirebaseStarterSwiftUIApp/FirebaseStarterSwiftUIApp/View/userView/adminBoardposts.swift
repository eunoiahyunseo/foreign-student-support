//
//  adminBoardposts.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/06/17.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct adminBoardposts: View {
    @State private var posts : [AdminBoard] = []
    @State private var isShownTxtFeild : Bool = false
    private var adminBoardService : AdminBoardService = AdminBoardService()
    
    @State private var designatedPost : AdminBoard? = nil
    
    init() {
        isShownTxtFeild = false
    }
    
    var body: some View {
        VStack{
            Text("공지글 목록").font(.largeTitle)
            List(posts){ content in
                HStack{
                    VStack(alignment: .leading){
                        Text(content.title).font(.title)
                        Text(content.content)
                    }
                    Spacer()
                    
                    Button(action: {
                        designatedPost = content
                        isShownTxtFeild = true
                    }){
                        Text("수정")
                    }.buttonStyle(BorderlessButtonStyle())
                    
                    Button(action: {
                        adminBoardService.deletePost(id: content.id!, completion: { err in
                            if(err == nil){
                                refreshList()
                            }
                        })
                    }){
                        Text("삭제")
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
            .onAppear {
                refreshList()
            }
            .fullScreenCover(isPresented: $isShownTxtFeild, onDismiss: {
                refreshList()
            }) {
                WriteNoticeView(isShownTxtFeild: $isShownTxtFeild,
                                postBefore: $designatedPost)
            }
        }
        
    }
    
    func refreshList() {
        adminBoardService.getAllPosts(completion: { result in
            switch result{
            case .success(let boards):
                posts = boards
            case .failure(let error):
                print(error)
            }
            
        })
    }
}

struct adminBoardposts_Previews: PreviewProvider {
    static var previews: some View {
        adminBoardposts()
    }
}
