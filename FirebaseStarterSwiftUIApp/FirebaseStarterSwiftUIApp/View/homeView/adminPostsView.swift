//
//  adminPostsView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/06/17.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct adminPostsView: View {
    @State var posts : [AdminBoard] = []
    private var adminBoardService : AdminBoardService = AdminBoardService()
    
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack{
                ForEach(posts) { post in
                    adminPost(title: post.title, content: post.content)
                }
            }
        }
        .onAppear{
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
}

struct adminPost : View {
    var title : String
    var content : String
    
    var body : some View {
        HStack(alignment: .top){
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "person.wave.2").font(.system(size:18)).padding(.trailing, 8)
                    
                    Text(title)
                        .font(.system(size:18)).padding(.bottom, 8)
                }
                
                Text(content)
                    .font(.system(size:14)).lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
        .frame(minWidth: 200, maxWidth: 200, minHeight: 100, maxHeight: 500, alignment: .top)
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2)
        )
        .padding(10)
    }
}
